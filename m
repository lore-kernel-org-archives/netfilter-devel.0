From: Nir Tzachar <nir.tzachar@gmail.com>
Subject: [PATCH]: Fix ipt_REJECT problem with nf_bridge
Date: Thu, 26 Feb 2009 10:48:26 +0200
Message-ID: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64367 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZBZIs3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:48:29 -0500
Received: by fxm24 with SMTP id 24so385463fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2009 00:48:26 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

There is a problem with the current version of ipt_REJECT when
operating on a bridge interface.
To be more exact, an RST is never sent to connections over the bridge,
as the ip_route_me_harder function always fail.

The problem arises from the following code
(net/ipv4/netfilter/ipt_REJECT.c line 221:)

        if (hook != NF_INET_FORWARD
#ifdef CONFIG_BRIDGE_NETFILTER
            || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
#endif
           )
                addr_type = RTN_LOCAL;

but, as nskb was newly allocated just a few line back, the
oldskb->nf_bridge was never copied, so nskb->nf_bridge is always NULL.
The following patch corrects the problem. Please review and apply.

Cheers, Nir.


Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
Tested-by: Elad Kertis <elad.kertis@gmail.com>

--- linux-2.6.28.7.old/net/ipv4/netfilter/ipt_REJECT.c	2009-02-26
10:28:51.000000000 +0200
+++ linux-2.6.28.7/net/ipv4/netfilter/ipt_REJECT.c	2009-02-26
10:31:26.000000000 +0200
@@ -98,6 +98,12 @@
 				       niph->saddr, niph->daddr,
 				       csum_partial(tcph,
 						    sizeof(struct tcphdr), 0));
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (oldskb->nf_bridge){
+		nf_bridge_get(oldskb->nf_bridge);
+		nskb->nf_bridge = oldskb->nf_bridge;
+	}
+#endif

 	addr_type = RTN_UNSPEC;
 	if (hook != NF_INET_FORWARD
