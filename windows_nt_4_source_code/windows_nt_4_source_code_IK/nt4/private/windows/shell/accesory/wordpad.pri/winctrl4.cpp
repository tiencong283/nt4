// This is a part of the Microsoft Foundation Classes C++ library.
// Copyright (C) 1992-1995 Microsoft Corporation
// All rights reserved.
//
// This source code is only intended as a supplement to the
// Microsoft Foundation Classes Reference and related
// electronic documentation provided with the library.
// See these sources for detailed information regarding the
// Microsoft Foundation Classes product.

#include "stdafx.h"

#ifdef AFX_CMNCTL_SEG
#pragma code_seg(AFX_CMNCTL_SEG)
#endif

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define new DEBUG_NEW

#ifndef _AFX_NO_RICHEDIT_SUPPORT

/////////////////////////////////////////////////////////////////////////////
// _AFX_RICHEDIT_STATE

_AFX_RICHEDIT_STATE::~_AFX_RICHEDIT_STATE()
{
	if (m_hInstRichEdit != NULL)
#ifndef _MAC
		::FreeLibrary(m_hInstRichEdit);
#else
		REFreeLibrary(m_hInstRichEdit);
#endif
}

_AFX_RICHEDIT_STATE* AFX_CDECL AfxGetRichEditState()
{
	return _afxRichEditState.GetData();
}

/////////////////////////////////////////////////////////////////////////////
// CWordpadRichEdit

#ifdef _MAC
extern "C" int __gForceREInit;
#endif

BOOL CWordpadRichEditCtrl::Create(DWORD dwStyle, const RECT& rect, CWnd* pParentWnd, UINT nID)
{
	_AFX_RICHEDIT_STATE* pState = _afxRichEditState;
	if (pState->m_hInstRichEdit == NULL)
	{
#ifndef _MAC
		pState->m_hInstRichEdit = LoadLibrary(szRicheditDLLName);
#else
#ifndef _AFXDLL
		// Ordinarily the __gForceREInit reference would be produced by richedit.h, but
		// MFC builds with _WLM_NOFORCE_LIBS, which prevents richedit.h from generating
		// the reference.
		pState->m_hInstRichEdit = ((HINSTANCE)__gForceREInit), RELoadLibrary();
#else
		pState->m_hInstRichEdit = RELoadLibrary();
#endif
#endif
		if (pState->m_hInstRichEdit == NULL)
			return FALSE;
	}

	CWnd* pWnd = this;
	return pWnd->Create(RICHEDIT_CLASS, NULL, dwStyle, rect, pParentWnd, nID);
}

typedef struct tagEM32S {
	DWORD wParam;
	DWORD lParam;
} EM32S;
// Win32s specific

LRESULT CWordpadRichEditCtrl::Send32s(UINT nMsg, WPARAM wParam, LPARAM lParam) const
{
	ASSERT(afxData.bWin31);
	EM32S em;
	em.wParam = (DWORD)wParam;
	em.lParam = (DWORD)lParam;
	return ::SendMessage(m_hWnd, WM_USER+nMsg, 0, (LPARAM)&em);
}

int CWordpadRichEditCtrl::GetLine(int nIndex, LPTSTR lpszBuffer) const
{
	ASSERT(::IsWindow(m_hWnd));
	if (afxData.bWin31)
		return (int)Send32s(EM_GETLINE, nIndex, (LPARAM)lpszBuffer);
	else
	{
		return (int)::SendMessage(m_hWnd, EM_GETLINE, nIndex,
			(LPARAM)lpszBuffer);
	}
}

int CWordpadRichEditCtrl::LineIndex(int nLine /* = -1 */) const
{
	ASSERT(::IsWindow(m_hWnd));
	if (afxData.bWin31)
		return (int)Send32s(EM_LINEINDEX, nLine, 0);
	else
		return (int)::SendMessage(m_hWnd, EM_LINEINDEX, nLine, 0);
}

int CWordpadRichEditCtrl::LineLength(int nLine /* = -1 */) const
{
	ASSERT(::IsWindow(m_hWnd));
	if (afxData.bWin31)
		return (int)Send32s(EM_LINELENGTH, nLine, 0);
	else
		return (int)::SendMessage(m_hWnd, EM_LINELENGTH, nLine, 0);
}

void CWordpadRichEditCtrl::LineScroll(int nLines, int nChars /* = 0 */)
{
	ASSERT(::IsWindow(m_hWnd));
	if (afxData.bWin31)
		Send32s(EM_LINESCROLL, nLines, nChars);
	else
		::SendMessage(m_hWnd, EM_LINESCROLL, nChars, nLines);
}

void CWordpadRichEditCtrl::SetSel(long nStartChar, long nEndChar)
{
	ASSERT(::IsWindow(m_hWnd));
	CHARRANGE cr;
	cr.cpMin = nStartChar;
	cr.cpMax = nEndChar;
	::SendMessage(m_hWnd, EM_EXSETSEL, 0, (LPARAM)&cr);
}

BOOL CWordpadRichEditCtrl::CanPaste(UINT nFormat) const
{
	ASSERT(::IsWindow(m_hWnd));
	COleMessageFilter* pFilter = AfxOleGetMessageFilter();
	if (pFilter != NULL)
		pFilter->BeginBusyState();
	BOOL b = (BOOL)::SendMessage(m_hWnd, EM_CANPASTE, nFormat, 0L);
	if (pFilter != NULL)
		pFilter->EndBusyState();
	return b;
}

void CWordpadRichEditCtrl::PasteSpecial(UINT nClipFormat, DWORD dvAspect, HMETAFILE hMF)
{
	ASSERT(::IsWindow(m_hWnd));
	REPASTESPECIAL reps;
	reps.dwAspect = dvAspect;
	reps.dwParam = (DWORD)hMF;
	::SendMessage(m_hWnd, EM_PASTESPECIAL, nClipFormat, (LPARAM)&reps);
}

int CWordpadRichEditCtrl::GetLine(int nIndex, LPTSTR lpszBuffer, int nMaxLength) const
{
	ASSERT(::IsWindow(m_hWnd));
	*(LPINT)lpszBuffer = nMaxLength;
	return (int)::SendMessage(m_hWnd, EM_GETLINE, nIndex, (LPARAM)lpszBuffer);
}

void CWordpadRichEditCtrl::GetSel(long& nStartChar, long& nEndChar) const
{
	ASSERT(::IsWindow(m_hWnd));
	CHARRANGE cr;
	::SendMessage(m_hWnd, EM_EXGETSEL, 0, (LPARAM)&cr);
	nStartChar = cr.cpMin;
	nEndChar = cr.cpMax;
}

CString CWordpadRichEditCtrl::GetSelText() const
{
	ASSERT(::IsWindow(m_hWnd));
	CHARRANGE cr;
	cr.cpMin = cr.cpMax = 0;
	::SendMessage(m_hWnd, EM_EXGETSEL, 0, (LPARAM)&cr);
	LPSTR lpsz = (char*)_alloca((cr.cpMax - cr.cpMin + 1)*2);
	lpsz[0] = NULL;
	::SendMessage(m_hWnd, EM_GETSELTEXT, 0, (LPARAM)lpsz);
	return lpsz;
}

IRichEditOle* CWordpadRichEditCtrl::GetIRichEditOle() const
{
	ASSERT(::IsWindow(m_hWnd));
	IRichEditOle *pRichItem = NULL;
	::SendMessage(m_hWnd, EM_GETOLEINTERFACE, 0, (LPARAM)&pRichItem);
	return pRichItem;
}

BOOL CWordpadRichEditCtrl::SetDefaultCharFormat(CHARFORMAT &cf)
{
	ASSERT(::IsWindow(m_hWnd));
	cf.cbSize = sizeof(CHARFORMAT);
	return (BOOL)::SendMessage(m_hWnd, EM_SETCHARFORMAT, 0, (LPARAM)&cf);
}

BOOL CWordpadRichEditCtrl::SetSelectionCharFormat(CHARFORMAT &cf)
{
	ASSERT(::IsWindow(m_hWnd));
	cf.cbSize = sizeof(CHARFORMAT);
	return (BOOL)::SendMessage(m_hWnd, EM_SETCHARFORMAT, SCF_SELECTION, (LPARAM)&cf);
}

BOOL CWordpadRichEditCtrl::SetWordCharFormat(CHARFORMAT &cf)
{
	ASSERT(::IsWindow(m_hWnd));
	cf.cbSize = sizeof(CHARFORMAT);
	return (BOOL)::SendMessage(m_hWnd, EM_SETCHARFORMAT, SCF_SELECTION|SCF_WORD, (LPARAM)&cf);
}

DWORD CWordpadRichEditCtrl::GetDefaultCharFormat(CHARFORMAT &cf) const
{
	ASSERT(::IsWindow(m_hWnd));
	cf.cbSize = sizeof(CHARFORMAT);
	return (DWORD)::SendMessage(m_hWnd, EM_GETCHARFORMAT, 0, (LPARAM)&cf);
}

DWORD CWordpadRichEditCtrl::GetSelectionCharFormat(CHARFORMAT &cf) const
{
	ASSERT(::IsWindow(m_hWnd));
	cf.cbSize = sizeof(CHARFORMAT);
	return (DWORD)::SendMessage(m_hWnd, EM_GETCHARFORMAT, 1, (LPARAM)&cf);
}

DWORD CWordpadRichEditCtrl::GetParaFormat(PARAFORMAT &pf) const
{
	ASSERT(::IsWindow(m_hWnd));
	pf.cbSize = sizeof(PARAFORMAT);
	return (DWORD)::SendMessage(m_hWnd, EM_GETPARAFORMAT, 0, (LPARAM)&pf);
}

BOOL CWordpadRichEditCtrl::SetParaFormat(PARAFORMAT &pf)
{
	ASSERT(::IsWindow(m_hWnd));
	pf.cbSize = sizeof(PARAFORMAT);
	return (BOOL)::SendMessage(m_hWnd, EM_SETPARAFORMAT, 0, (LPARAM)&pf);
}

#endif //!_AFX_NO_RICHEDIT_SUPPORT

/////////////////////////////////////////////////////////////////////////////

#ifndef _AFX_NO_RICHEDIT_SUPPORT
#if defined(_MAC) && !defined(_AFXDLL)
	#ifdef _DEBUG
		#pragma comment(lib, "richedd.lib")
		#ifdef _68K_
			#pragma comment(lib, "wlmoled.lib")
		#endif
	#else
		#pragma comment(lib, "riched.lib")
		#ifdef _68K_
			#pragma comment(lib, "wlmole.lib")
		#endif
	#endif
	#pragma comment(linker, "/macres:riched.rsc")
#endif // _MAC && !_AFXDLL
#endif // _AFX_NO_RICHEDIT_SUPPORT

#pragma warning(disable: 4074)
#pragma warning(disable: 4073)
#pragma init_seg(lib)
#pragma warning(default: 4073)

#ifndef _AFX_NO_RICHEDIT_SUPPORT
PROCESS_LOCAL(_AFX_RICHEDIT_STATE, _afxRichEditState)
#endif

/////////////////////////////////////////////////////////////////////////////

