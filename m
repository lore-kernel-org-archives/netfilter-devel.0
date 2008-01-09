From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 22/27] Rename ipt_iprange to xt_iprange
Date: Wed, 9 Jan 2008 14:55:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801091453210.29244@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022131230.14900@fbirervta.pbzchgretzou.qr>
 <47839CFA.9090005@trash.net> <Pine.LNX.4.64.0801081714430.3032@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44899 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYAINzf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:55:35 -0500
In-Reply-To: <Pine.LNX.4.64.0801081714430.3032@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 8 2008 17:16, Jan Engelhardt wrote:
>--- /dev/null
>+++ b/include/linux/netfilter/xt_iprange.h
>@@ -0,0 +1,17 @@
>+#ifndef _LINUX_NETFILTER_XT_IPRANGE_H
>+#define _LINUX_NETFILTER_XT_IPRANGE_H 1
>+
>+enum {
>+	IPRANGE_SRC     = 1 << 0,	/* match source IP address */
>+	IPRANGE_DST     = 1 << 1,	/* match destination IP address */
>+	IPRANGE_SRC_INV = 1 << 2,	/* negate the condition */
>+	IPRANGE_DST_INV = 1 << 3,	/* -"- */
>+};

Flag holes can be evil :-/
Please apply, thanks.

===

commit 0f91c13e8fe1389a0b6879b72da59c13182d4b76
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 9 14:53:10 2008 +0100

    [NETFILTER]: xt_iprange: Need to keep old constats from ipt_iprange
    
    ipt_iprange left a "hole" in its flags field, i.e.
    	#define IPRANGE_SRC     0x01  <=>  IPRANGE_SRC     = 1 << 0,
    	#define IPRANGE_DST     0x02  <=>  IPRANGE_DST     = 1 << 1,
    	#define IPRANGE_SRC_INV 0x10  <=>  IPRANGE_SRC_INV = 1 << 4,
    	#define IPRANGE_DST_INV 0x20  <=>  IPRANGE_DST_INV = 1 << 5,
    We need to keep this for compat.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_iprange.h b/include/linux/netfilter/xt_iprange.h
index c983a55..a4299c7 100644
--- a/include/linux/netfilter/xt_iprange.h
+++ b/include/linux/netfilter/xt_iprange.h
@@ -4,8 +4,8 @@
 enum {
 	IPRANGE_SRC     = 1 << 0,	/* match source IP address */
 	IPRANGE_DST     = 1 << 1,	/* match destination IP address */
-	IPRANGE_SRC_INV = 1 << 2,	/* negate the condition */
-	IPRANGE_DST_INV = 1 << 3,	/* -"- */
+	IPRANGE_SRC_INV = 1 << 4,	/* negate the condition */
+	IPRANGE_DST_INV = 1 << 5,	/* -"- */
 };
 
 struct xt_iprange_mtinfo {
