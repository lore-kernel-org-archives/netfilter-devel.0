From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: remove redundant skb check in
 nf_conntrack_put_reasm
Date: Wed, 19 Jun 2013 10:27:35 -0400
Message-ID: <20130619142735.GA2758@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63640 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935546Ab3FTDaX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:30:23 -0400
Received: by mail-pd0-f171.google.com with SMTP id y14so5756542pdi.2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2013 20:30:23 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

kfree_skb already checks for skb existence - remove redundant check from
nf_conntrack_put_reasm.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-put_reasm

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a7393ad..3da70ba 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2604,8 +2604,7 @@ static inline void nf_conntrack_get_reasm(struct sk_buff *skb)
 }
 static inline void nf_conntrack_put_reasm(struct sk_buff *skb)
 {
-	if (skb)
-		kfree_skb(skb);
+	kfree_skb(skb);
 }
 #endif
 #ifdef CONFIG_BRIDGE_NETFILTER

--82I3+IH0IqGh5yIs--
