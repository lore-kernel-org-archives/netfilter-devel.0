From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] segfault in expr_clone()
Date: Tue, 6 Oct 2015 10:48:49 +0200
Message-ID: <CAOkSjBgyW232aqidQ-EPPinpAqkd21pjqV3W0VE_0N3RVL89pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36854 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbJFItJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 04:49:09 -0400
Received: by wicgb1 with SMTP id gb1so154682270wic.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 01:49:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

debian users are reporting [0] a segfault related to expr_clone().

Is this the issue fixed by Florian's patch [1] ?

In concrete, this is the backtrace:

[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.=
1".

Program received signal SIGSEGV, Segmentation fault.
0x0000000000000000 in ?? ()
(gdb) bt
#0  0x0000000000000000 in ?? ()
#1  0x000000000040a9ad in expr_clone (expr=3Dexpr@entry=3D0x6549b0) at
expression.c:51
#2  0x000000000040ab08 in compound_expr_clone (new=3D0x65e500,
expr=3D0x654a40) at expression.c:656
#3  0x000000000040a9ad in expr_clone (expr=3D0x654a40) at expression.c:=
51
#4  0x000000000040c7ff in expr_evaluate_symbol (expr=3D<optimized out>,
ctx=3D<optimized out>) at evaluate.c:183
#5  expr_evaluate (ctx=3D0x7fffffffe9e8, expr=3D0x6569d8) at evaluate.c=
:1074
#6  0x000000000040c20f in expr_evaluate_relational (expr=3D<optimized
out>, ctx=3D<optimized out>) at evaluate.c:891
#7  expr_evaluate (ctx=3D0x7fffffffe9e8, expr=3D0x656a48) at evaluate.c=
:1108
#8  0x000000000040dd6c in stmt_evaluate_expr (stmt=3D0x656a00,
ctx=3D0x7fffffffe9e8) at evaluate.c:1117
#9  stmt_evaluate (ctx=3Dctx@entry=3D0x7fffffffe9e8,
stmt=3Dstmt@entry=3D0x656a00) at evaluate.c:1688
#10 0x000000000040e43f in rule_evaluate (ctx=3D0x7fffffffe9e8,
rule=3D0x656b70) at evaluate.c:1816
#11 0x000000000040e5f7 in chain_evaluate
(ctx=3Dctx@entry=3D0x7fffffffe9e8, chain=3Dchain@entry=3D0x655c90) at
evaluate.c:1901
#12 0x000000000040ec2f in table_evaluate (table=3D0x655690,
ctx=3D0x7fffffffe9e8) at evaluate.c:1933
#13 cmd_evaluate_add (cmd=3D<optimized out>, ctx=3D0x7fffffffe9e8) at
evaluate.c:1954
#14 cmd_evaluate (ctx=3D0x7fffffffe9e8, cmd=3D<optimized out>) at evalu=
ate.c:2112
#15 0x0000000000425b05 in nft_parse (scanner=3Dscanner@entry=3D0x6504b0=
,
state=3Dstate@entry=3D0x7fffffffe400) at parser_bison.y:566
#16 0x00000000004062ed in nft_run (scanner=3Dscanner@entry=3D0x6504b0,
state=3Dstate@entry=3D0x7fffffffe400, msgs=3Dmsgs@entry=3D0x7fffffffe3f=
0) at
main.c:231
#17 0x0000000000405f50 in main (argc=3D<optimized out>, argv=3D<optimiz=
ed
out>) at main.c:357

thanks, best regards.

[0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D801087
[1] http://patchwork.ozlabs.org/patch/524679/
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
