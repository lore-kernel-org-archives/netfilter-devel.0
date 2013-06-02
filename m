From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 2/5] expression: don't free TYPE_INVALID datatype
Date: Sun,  2 Jun 2013 12:38:29 +0200
Message-ID: <1370169512-23500-3-git-send-email-eric@regit.org>
References: <1370169512-23500-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36293 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab3FBKiz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:38:55 -0400
In-Reply-To: <1370169512-23500-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

TYPE_INVALID datatype are unitialised and should not be free.

The following invalid command was segfaulting:
 nft add rule global filter  ip daddr . tcp dport { 192.168.0.1 . 22\; 192.168.0.3 . 89 } drop
with the following backtrace:
 (gdb) bt
 #0  0x00007ffff6f39295 in __GI_raise (sig=sig@entry=6) at ../nptl/sysdeps/unix/sysv/linux/raise.c:56
 #1  0x00007ffff6f3c438 in __GI_abort () at abort.c:90
 #2  0x00007ffff6f7486b in __libc_message (do_abort=do_abort@entry=2, fmt=fmt@entry=0x7ffff7070d28 "*** Error in `%s': %s: 0x%s ***\n") at ../sysdeps/unix/sysv/linux/libc_fatal.c:199
 #3  0x00007ffff6f7eac6 in malloc_printerr (action=3, str=0x7ffff706ccca "free(): invalid pointer", ptr=<optimized out>) at malloc.c:4902
 #4  0x00007ffff6f7f843 in _int_free (av=<optimized out>, p=0x428530, have_lock=0) at malloc.c:3758
 #5  0x000000000041aae8 in xfree (ptr=0x428540 <invalid_type>) at src/utils.c:29
 #6  0x000000000040bc43 in concat_type_destroy (dtype=0x428540 <invalid_type>) at src/datatype.c:690
 #7  0x000000000040cebf in concat_expr_destroy (expr=0x643b90) at src/expression.c:571
 #8  0x000000000040bef4 in expr_free (expr=0x643b90) at src/expression.c:67
 #9  0x000000000040cd8e in compound_expr_destroy (expr=0x643c20) at src/expression.c:542
 #10 0x000000000040bef4 in expr_free (expr=0x643c20) at src/expression.c:67
 #11 0x000000000041c314 in yydestruct (yymsg=0x4354a1 "Error: popping", yytype=242, yyvaluep=0x7fffffffbcf8, yylocationp=0x7fffffff9db8, scanner=0x643690, state=0x7fffffffdf90) at src/parser.y:398
 #12 0x000000000041ffb7 in nft_parse (scanner=0x643690, state=0x7fffffffdf90) at src/parser.c:5519
 #13 0x00000000004074df in nft_run (scanner=0x643690, state=0x7fffffffdf90, msgs=0x7fffffffdf80) at src/main.c:156
 #14 0x0000000000407a78 in main (argc=19, argv=0x7fffffffe698) at src/main.c:288

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/expression.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 8cf3f62..e4108d0 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -568,7 +568,8 @@ void compound_expr_remove(struct expr *compound, struct expr *expr)
 
 static void concat_expr_destroy(struct expr *expr)
 {
-	concat_type_destroy(expr->dtype);
+	if (expr->dtype && expr->dtype->type != TYPE_INVALID)
+		concat_type_destroy(expr->dtype);
 	compound_expr_destroy(expr);
 }
 
-- 
1.7.10.4

