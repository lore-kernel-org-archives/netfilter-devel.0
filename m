From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 12/13] Add all necessary header files - compilation fix
 for various cases
Date: Sun, 13 Apr 2008 12:05:14 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804131144430.29681@fbirervta.pbzchgretzou.qr>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <0b061f76d73e268a7dd95d036235812728b9c120.1207813085.git.jengelh@computergmbh.de> <4801986E.9070500@trash.net> <alpine.LNX.1.10.0804130808320.30942@fbirervta.pbzchgretzou.qr>
 <4801D3FE.3080807@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55399 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYDMKFP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 06:05:15 -0400
In-Reply-To: <4801D3FE.3080807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-04-13 11:35, Patrick McHardy wrote:
>> > > Allow iptables to compile without a kernel source tree. This
>> > > implies fixing build for older kernels, such as 2.6.17 which
>> > > lack xt_SECMARK.h.
>> > >       
>> > Which version are these headers based on?
>>
>> There is just one version. The file never changed since it
>> was initially added as v2.6.17-69-g5e6874c.
>
> The question referred to all those headers.
>
They are from kaber/nf-2.6.26.git (46ae7629).
Except netfilter.h, which is from 7b33ed22^.

If you fold in the hunks below, it too will be up to 46ae7629. Thanks.

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 6922c7f..4196a51 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -1,7 +1,6 @@
 #ifndef __LINUX_NETFILTER_H
 #define __LINUX_NETFILTER_H
 
-//#include <linux/compiler.h>
 
 /* Responses from hook functions. */
 #define NF_DROP 0
@@ -20,7 +19,7 @@
 #define NF_VERDICT_QMASK 0xffff0000
 #define NF_VERDICT_QBITS 16
 
-#define NF_QUEUE_NR(x) (((x << NF_VERDICT_QBITS) & NF_VERDICT_QMASK) | NF_QUEUE)
+#define NF_QUEUE_NR(x) ((((x) << NF_VERDICT_BITS) & NF_VERDICT_QMASK) | NF_QUEUE)
 
 /* only for userspace compatibility */
 /* Generic cache responses from hook functions.
@@ -38,7 +37,7 @@ enum nf_inet_hooks {
 };
 
 union nf_inet_addr {
-	u_int32_t	all[4];
+	__u32		all[4];
 	__be32		ip;
 	__be32		ip6[4];
 	struct in_addr	in;
