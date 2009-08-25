From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Tue, 25 Aug 2009 15:23:27 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908251522240.9492@fbirervta.pbzchgretzou.qr>
References: <4A93D817.4080706@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33832 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZHYNX1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:23:27 -0400
In-Reply-To: <4A93D817.4080706@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-08-25 14:24, Patrick McHardy wrote:

>I'm about to commit a couple of patches from some private trees
>to my nf-next-2.6.git tree. Any comments welcome.
>
> 
> int (*nf_nat_seq_adjust_hook)(struct sk_buff *skb,
> 			      struct nf_conn *ct,
>@@ -113,8 +114,11 @@ static unsigned int ipv4_confirm(unsigned int hooknum,
> 
> 	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
> 			   ct, ctinfo);
>-	if (ret != NF_ACCEPT)
>+	if (ret != NF_ACCEPT) {
>+		nf_log_packet(AF_INET, hooknum, skb, in, out, NULL,
>+			      "nf_ct_%s: dropping packet", helper->name);
> 		return ret;
>+	}

These calls should probably be using NFPROTO_*.

Also, the actual helpers should be audited and any "we dropped things"
messages be removed since now that is done by your patch.

>+	if (ret != NF_ACCEPT) {
>+		nf_log_packet(AF_INET6, hooknum, skb, in, out, NULL,
>+			      "nf_ct_%s: dropping packet", helper->name);
> 		return ret;
>+	}
