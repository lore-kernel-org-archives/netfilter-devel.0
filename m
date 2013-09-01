From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: xt_TCPMSS: correct return value in
 tcpmss_mangle_packet
Date: Sun, 1 Sep 2013 08:32:21 -0700
Message-ID: <20130901153221.GB10125@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48455 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab3IAPcp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:32:45 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so3759645pdi.5
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Sep 2013 08:32:45 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit b396966c4 (netfilter: xt_TCPMSS: Fix missing fragmentation handling),
I attempted to add safe fragment handling to xt_TCPMSS.  However, Andy Padavan
of Project N56U correctly points out that returning XT_CONTINUE in this
function does not work.  The callers (tcpmss_tg[46]) expect to receive a value
of 0 in order to return XT_CONTINUE.

Signed-off-by: Phil Oester <kernel@linuxace.com>



--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-tcpmss-frag

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 6113cc7..cd24290 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -60,7 +60,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 
 	/* This is a fragment, no TCP header is available */
 	if (par->fragoff != 0)
-		return XT_CONTINUE;
+		return 0;
 
 	if (!skb_make_writable(skb, skb->len))
 		return -1;

--fUYQa+Pmc3FrFX/N--
