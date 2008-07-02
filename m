From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit counters
 (v3)
Date: Wed, 02 Jul 2008 15:40:10 +0200
Message-ID: <486B853A.205@trash.net>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <Pine.LNX.4.64.0807021358370.4958@bizon.gios.gov.pl> <486B7D9C.4070501@trash.net> <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl> <486B80F5.7050801@trash.net> <Pine.LNX.4.64.0807021522520.4958@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020009010106020808080402"
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38043 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYGBNkM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:40:12 -0400
In-Reply-To: <Pine.LNX.4.64.0807021522520.4958@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020009010106020808080402
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Krzysztof Oledzki wrote:
> (...)
> bool nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
> (...)
> module_param_named(acct, nf_ct_acct, bool, 0644);        <- line 28
> (...)
> 
> net/netfilter/nf_conntrack_acct.c: In function '__check_acct':
> net/netfilter/nf_conntrack_acct.c:28: warning: return from incompatible 
> pointer type

Seems you're the first to try module_param_named with a bool :)
Does this help?




--------------020009010106020808080402
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index ec62438..1663ab1 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -155,7 +155,7 @@ extern int param_get_charp(char *buffer, struct kernel_param *kp);
 
 extern int param_set_bool(const char *val, struct kernel_param *kp);
 extern int param_get_bool(char *buffer, struct kernel_param *kp);
-#define param_check_bool(name, p) __param_check(name, p, int)
+#define param_check_bool(name, p) __param_check(name, p, bool)
 
 extern int param_set_invbool(const char *val, struct kernel_param *kp);
 extern int param_get_invbool(char *buffer, struct kernel_param *kp);

--------------020009010106020808080402--
