;+---------------------------------------------------------------------------
;
;  Microsoft Windows
;  Copyright (C) Microsoft Corporation, 1996.
;
;  File:       stubless.asm
;
;  Contents:   This module contains interpreter support routines for
;              Intel platforms.
;
;  Functions:  Invoke - Calls a function from an interpreter.
;              ObjectStublessClient3 - ObjectStublessClient511
;
;  History:    07-Nov-94 DKays     Created
;              24-Apr-96 ShannonC  Added Invoke and support for 
;                                  512 stubless client methods.
;
;----------------------------------------------------------------------------

.386p

EXTRN   _ObjectStublessClient@8:NEAR

_TEXT   SEGMENT DWORD PUBLIC 'CODE'


;+---------------------------------------------------------------------------
;
;  Function:   REGISTER_TYPE __stdcall Invoke(MANAGER_FUNCTION pFunction, 
;                                             REGISTER_TYPE   *pArgumentList,
;                                             ULONG            cArguments);
;
;  Synopsis:   Given a function pointer and an argument list, Invoke builds 
;              a stack frame and calls the function.
;
;  Arguments:  pFunction - Pointer to the function to be called.
;
;              pArgumentList - Pointer to the buffer containing the 
;                              function parameters.
;
;              cArguments - The size of the argument list in REGISTER_TYPEs.
;
;  Notes:     In the __stdcall calling convention, the callee must pop
;             the parameters.
;
;----------------------------------------------------------------------------
_Invoke@12 PROC PUBLIC

push ebp;          Save ebp
mov  ebp, esp;     Set ebp so the debugger can display the stack trace.

;Here is our stack layout.
;[ebp+0]  = saved ebp
;[ebp+4]  = return address
;[ebp+8]  = pFunction
;[ebp+12] = pArgumentList
;[ebp+16] = cArguments

push edi;          Save edi
push esi;          Save esi

mov eax, [ebp+16]; Load number of parameters
shl eax, 2;        Calculate size of parameters
sub esp, eax;      Grow the stack

;Copy parameters from bottom to top.
mov esi, [ebp+12]; Load pointer to parameters
mov ecx, [ebp+16]; Load number of parameters
sub eax, 4;
mov edi, esp
add esi, eax;      Get pointer to last source parameter
add edi, eax;      Get pointer last destination parameter

pushf;             Save direction flag
std;               Set direction flag
rep movsd;         Copy the parameters
popf;              Restore direction flag

;call the server
mov eax, [ebp+8];  Load pointer to function.
call eax

mov edi, [ebp-4];  Restore edi
mov esi, [ebp-8];  Restore esi
mov esp, ebp;      Restore stack pointer
pop ebp;           Restore ebp
ret 12 ;           Pop parameters       

_Invoke@12 ENDP 


;
; Define ObjectStublessClient routine macro.
;
StublessClientProc macro    Method

    _ObjectStublessClient&Method&@0 PROC PUBLIC
        
        ;
        ; NOTE :
        ; Don't use edi, esi, or ebx unless you add code to save them on 
        ; the stack!
        ;
    
        mov     ecx, Method
        jmp     ObjectStubless

    _ObjectStublessClient&Method&@0 ENDP 

endm


;On entry, ecx contains method number.
ObjectStubless PROC PUBLIC
        
        ;
        ; NOTE :
        ; Don't use edi, esi, or ebx unless you add code to save them on 
        ; the stack!
        ;
    
        ;
        ; Do this so the debugger can figure out the stack trace correctly.
        ; Will make debugging much easier.
        ;
        push    ebp
        mov     ebp, esp

        ; Push the method number.
        push    ecx

        ; Push the stack address of the parameters.
        mov     eax, ebp
        add     eax, 8
        push    eax

        call    _ObjectStublessClient@8

        ;
        ; After the call :
        ;   Real return for the proxy is in eax.
        ;   Parameter stack size is put in ecx by ObjectStublessClient for us.
        ;
        ; At this pointer eax (return), ecx (ParamSize), and edi, esi, ebx
        ; (non-volatile registers) can not be written!!!
        ;

        ; Don't forget to pop ebp.
        pop     ebp

        ; Pop our return address.
        pop     edx

        ; Pop params explicitly.
        add     esp, ecx

        ; This will return us from whichever StublessClient routine was called.
        jmp     edx

    ObjectStubless ENDP 

StublessClientProc  3
StublessClientProc  4
StublessClientProc  5
StublessClientProc  6
StublessClientProc  7
StublessClientProc  8
StublessClientProc  9
StublessClientProc  10
StublessClientProc  11
StublessClientProc  12
StublessClientProc  13
StublessClientProc  14
StublessClientProc  15
StublessClientProc  16
StublessClientProc  17
StublessClientProc  18
StublessClientProc  19
StublessClientProc  20
StublessClientProc  21
StublessClientProc  22
StublessClientProc  23
StublessClientProc  24
StublessClientProc  25
StublessClientProc  26
StublessClientProc  27
StublessClientProc  28
StublessClientProc  29
StublessClientProc  30
StublessClientProc  31
StublessClientProc  32
StublessClientProc  33
StublessClientProc  34
StublessClientProc  35
StublessClientProc  36
StublessClientProc  37
StublessClientProc  38
StublessClientProc  39
StublessClientProc  40
StublessClientProc  41
StublessClientProc  42
StublessClientProc  43
StublessClientProc  44
StublessClientProc  45
StublessClientProc  46
StublessClientProc  47
StublessClientProc  48
StublessClientProc  49
StublessClientProc  50
StublessClientProc  51
StublessClientProc  52
StublessClientProc  53
StublessClientProc  54
StublessClientProc  55
StublessClientProc  56
StublessClientProc  57
StublessClientProc  58
StublessClientProc  59
StublessClientProc  60
StublessClientProc  61
StublessClientProc  62
StublessClientProc  63
StublessClientProc  64
StublessClientProc  65
StublessClientProc  66
StublessClientProc  67
StublessClientProc  68
StublessClientProc  69
StublessClientProc  70
StublessClientProc  71
StublessClientProc  72
StublessClientProc  73
StublessClientProc  74
StublessClientProc  75
StublessClientProc  76
StublessClientProc  77
StublessClientProc  78
StublessClientProc  79
StublessClientProc  80
StublessClientProc  81
StublessClientProc  82
StublessClientProc  83
StublessClientProc  84
StublessClientProc  85
StublessClientProc  86
StublessClientProc  87
StublessClientProc  88
StublessClientProc  89
StublessClientProc  90
StublessClientProc  91
StublessClientProc  92
StublessClientProc  93
StublessClientProc  94
StublessClientProc  95
StublessClientProc  96
StublessClientProc  97
StublessClientProc  98
StublessClientProc  99
StublessClientProc  100
StublessClientProc  101
StublessClientProc  102
StublessClientProc  103
StublessClientProc  104
StublessClientProc  105
StublessClientProc  106
StublessClientProc  107
StublessClientProc  108
StublessClientProc  109
StublessClientProc  110
StublessClientProc  111
StublessClientProc  112
StublessClientProc  113
StublessClientProc  114
StublessClientProc  115
StublessClientProc  116
StublessClientProc  117
StublessClientProc  118
StublessClientProc  119
StublessClientProc  120
StublessClientProc  121
StublessClientProc  122
StublessClientProc  123
StublessClientProc  124
StublessClientProc  125
StublessClientProc  126
StublessClientProc  127
StublessClientProc  128
StublessClientProc  129
StublessClientProc  130
StublessClientProc  131
StublessClientProc  132
StublessClientProc  133
StublessClientProc  134
StublessClientProc  135
StublessClientProc  136
StublessClientProc  137
StublessClientProc  138
StublessClientProc  139
StublessClientProc  140
StublessClientProc  141
StublessClientProc  142
StublessClientProc  143
StublessClientProc  144
StublessClientProc  145
StublessClientProc  146
StublessClientProc  147
StublessClientProc  148
StublessClientProc  149
StublessClientProc  150
StublessClientProc  151
StublessClientProc  152
StublessClientProc  153
StublessClientProc  154
StublessClientProc  155
StublessClientProc  156
StublessClientProc  157
StublessClientProc  158
StublessClientProc  159
StublessClientProc  160
StublessClientProc  161
StublessClientProc  162
StublessClientProc  163
StublessClientProc  164
StublessClientProc  165
StublessClientProc  166
StublessClientProc  167
StublessClientProc  168
StublessClientProc  169
StublessClientProc  170
StublessClientProc  171
StublessClientProc  172
StublessClientProc  173
StublessClientProc  174
StublessClientProc  175
StublessClientProc  176
StublessClientProc  177
StublessClientProc  178
StublessClientProc  179
StublessClientProc  180
StublessClientProc  181
StublessClientProc  182
StublessClientProc  183
StublessClientProc  184
StublessClientProc  185
StublessClientProc  186
StublessClientProc  187
StublessClientProc  188
StublessClientProc  189
StublessClientProc  190
StublessClientProc  191
StublessClientProc  192
StublessClientProc  193
StublessClientProc  194
StublessClientProc  195
StublessClientProc  196
StublessClientProc  197
StublessClientProc  198
StublessClientProc  199
StublessClientProc  200
StublessClientProc  201
StublessClientProc  202
StublessClientProc  203
StublessClientProc  204
StublessClientProc  205
StublessClientProc  206
StublessClientProc  207
StublessClientProc  208
StublessClientProc  209
StublessClientProc  210
StublessClientProc  211
StublessClientProc  212
StublessClientProc  213
StublessClientProc  214
StublessClientProc  215
StublessClientProc  216
StublessClientProc  217
StublessClientProc  218
StublessClientProc  219
StublessClientProc  220
StublessClientProc  221
StublessClientProc  222
StublessClientProc  223
StublessClientProc  224
StublessClientProc  225
StublessClientProc  226
StublessClientProc  227
StublessClientProc  228
StublessClientProc  229
StublessClientProc  230
StublessClientProc  231
StublessClientProc  232
StublessClientProc  233
StublessClientProc  234
StublessClientProc  235
StublessClientProc  236
StublessClientProc  237
StublessClientProc  238
StublessClientProc  239
StublessClientProc  240
StublessClientProc  241
StublessClientProc  242
StublessClientProc  243
StublessClientProc  244
StublessClientProc  245
StublessClientProc  246
StublessClientProc  247
StublessClientProc  248
StublessClientProc  249
StublessClientProc  250
StublessClientProc  251
StublessClientProc  252
StublessClientProc  253
StublessClientProc  254
StublessClientProc  255
StublessClientProc  256
StublessClientProc  257
StublessClientProc  258
StublessClientProc  259
StublessClientProc  260
StublessClientProc  261
StublessClientProc  262
StublessClientProc  263
StublessClientProc  264
StublessClientProc  265
StublessClientProc  266
StublessClientProc  267
StublessClientProc  268
StublessClientProc  269
StublessClientProc  270
StublessClientProc  271
StublessClientProc  272
StublessClientProc  273
StublessClientProc  274
StublessClientProc  275
StublessClientProc  276
StublessClientProc  277
StublessClientProc  278
StublessClientProc  279
StublessClientProc  280
StublessClientProc  281
StublessClientProc  282
StublessClientProc  283
StublessClientProc  284
StublessClientProc  285
StublessClientProc  286
StublessClientProc  287
StublessClientProc  288
StublessClientProc  289
StublessClientProc  290
StublessClientProc  291
StublessClientProc  292
StublessClientProc  293
StublessClientProc  294
StublessClientProc  295
StublessClientProc  296
StublessClientProc  297
StublessClientProc  298
StublessClientProc  299
StublessClientProc  300
StublessClientProc  301
StublessClientProc  302
StublessClientProc  303
StublessClientProc  304
StublessClientProc  305
StublessClientProc  306
StublessClientProc  307
StublessClientProc  308
StublessClientProc  309
StublessClientProc  310
StublessClientProc  311
StublessClientProc  312
StublessClientProc  313
StublessClientProc  314
StublessClientProc  315
StublessClientProc  316
StublessClientProc  317
StublessClientProc  318
StublessClientProc  319
StublessClientProc  320
StublessClientProc  321
StublessClientProc  322
StublessClientProc  323
StublessClientProc  324
StublessClientProc  325
StublessClientProc  326
StublessClientProc  327
StublessClientProc  328
StublessClientProc  329
StublessClientProc  330
StublessClientProc  331
StublessClientProc  332
StublessClientProc  333
StublessClientProc  334
StublessClientProc  335
StublessClientProc  336
StublessClientProc  337
StublessClientProc  338
StublessClientProc  339
StublessClientProc  340
StublessClientProc  341
StublessClientProc  342
StublessClientProc  343
StublessClientProc  344
StublessClientProc  345
StublessClientProc  346
StublessClientProc  347
StublessClientProc  348
StublessClientProc  349
StublessClientProc  350
StublessClientProc  351
StublessClientProc  352
StublessClientProc  353
StublessClientProc  354
StublessClientProc  355
StublessClientProc  356
StublessClientProc  357
StublessClientProc  358
StublessClientProc  359
StublessClientProc  360
StublessClientProc  361
StublessClientProc  362
StublessClientProc  363
StublessClientProc  364
StublessClientProc  365
StublessClientProc  366
StublessClientProc  367
StublessClientProc  368
StublessClientProc  369
StublessClientProc  370
StublessClientProc  371
StublessClientProc  372
StublessClientProc  373
StublessClientProc  374
StublessClientProc  375
StublessClientProc  376
StublessClientProc  377
StublessClientProc  378
StublessClientProc  379
StublessClientProc  380
StublessClientProc  381
StublessClientProc  382
StublessClientProc  383
StublessClientProc  384
StublessClientProc  385
StublessClientProc  386
StublessClientProc  387
StublessClientProc  388
StublessClientProc  389
StublessClientProc  390
StublessClientProc  391
StublessClientProc  392
StublessClientProc  393
StublessClientProc  394
StublessClientProc  395
StublessClientProc  396
StublessClientProc  397
StublessClientProc  398
StublessClientProc  399
StublessClientProc  400
StublessClientProc  401
StublessClientProc  402
StublessClientProc  403
StublessClientProc  404
StublessClientProc  405
StublessClientProc  406
StublessClientProc  407
StublessClientProc  408
StublessClientProc  409
StublessClientProc  410
StublessClientProc  411
StublessClientProc  412
StublessClientProc  413
StublessClientProc  414
StublessClientProc  415
StublessClientProc  416
StublessClientProc  417
StublessClientProc  418
StublessClientProc  419
StublessClientProc  420
StublessClientProc  421
StublessClientProc  422
StublessClientProc  423
StublessClientProc  424
StublessClientProc  425
StublessClientProc  426
StublessClientProc  427
StublessClientProc  428
StublessClientProc  429
StublessClientProc  430
StublessClientProc  431
StublessClientProc  432
StublessClientProc  433
StublessClientProc  434
StublessClientProc  435
StublessClientProc  436
StublessClientProc  437
StublessClientProc  438
StublessClientProc  439
StublessClientProc  440
StublessClientProc  441
StublessClientProc  442
StublessClientProc  443
StublessClientProc  444
StublessClientProc  445
StublessClientProc  446
StublessClientProc  447
StublessClientProc  448
StublessClientProc  449
StublessClientProc  450
StublessClientProc  451
StublessClientProc  452
StublessClientProc  453
StublessClientProc  454
StublessClientProc  455
StublessClientProc  456
StublessClientProc  457
StublessClientProc  458
StublessClientProc  459
StublessClientProc  460
StublessClientProc  461
StublessClientProc  462
StublessClientProc  463
StublessClientProc  464
StublessClientProc  465
StublessClientProc  466
StublessClientProc  467
StublessClientProc  468
StublessClientProc  469
StublessClientProc  470
StublessClientProc  471
StublessClientProc  472
StublessClientProc  473
StublessClientProc  474
StublessClientProc  475
StublessClientProc  476
StublessClientProc  477
StublessClientProc  478
StublessClientProc  479
StublessClientProc  480
StublessClientProc  481
StublessClientProc  482
StublessClientProc  483
StublessClientProc  484
StublessClientProc  485
StublessClientProc  486
StublessClientProc  487
StublessClientProc  488
StublessClientProc  489
StublessClientProc  490
StublessClientProc  491
StublessClientProc  492
StublessClientProc  493
StublessClientProc  494
StublessClientProc  495
StublessClientProc  496
StublessClientProc  497
StublessClientProc  498
StublessClientProc  499
StublessClientProc  500
StublessClientProc  501
StublessClientProc  502
StublessClientProc  503
StublessClientProc  504
StublessClientProc  505
StublessClientProc  506
StublessClientProc  507
StublessClientProc  508
StublessClientProc  509
StublessClientProc  510
StublessClientProc  511

_TEXT   ends

end

