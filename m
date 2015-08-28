From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nfnetlink: work around wrong endianess
 with old nft userspace
Date: Fri, 28 Aug 2015 21:01:43 +0200
Message-ID: <20150828190143.GA5575@salvia>
References: <1440713863-18469-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58813 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbbH1SzU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 14:55:20 -0400
Content-Disposition: inline
In-Reply-To: <1440713863-18469-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 28, 2015 at 12:17:43AM +0200, Florian Westphal wrote:
> The nfgenmsg res_id is __be16.  Unfortunately nftables batch support uses
> host byte order.
> 
> This adds a compat workaround for old nft userspace.

Would you be also OK with the attached patch? Thanks.

--1yeeQ81UyVL57Vl7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nfnetlink-work-around-wrong-endianess-in-r.patch"

>From 97901f6e597987be7c9d9b1f6875004b4713e924 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 28 Aug 2015 19:17:46 +0200
Subject: [PATCH] netfilter: nfnetlink: work around wrong endianess in res_id
 field

The convention in nfnetlink is to use network byte order in every header field
as well as in the attribute payload. The initial version of the batching
infrastructure assumes that res_id comes in host byte order though.

The only client of the batching infrastructure is nf_tables, so let's add a
workaround to address this inconsistency. We currently have 11 nfnetlink
subsystems according to NFNL_SUBSYS_COUNT, so we can assume that the subsystem
2560, ie. htons(10), will not be allocated anytime soon, so it can be an alias
of nf_tables from the nfnetlink batching path when interpreting the res_id
field.

Based on original patch from Florian Westphal.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 0c0e8ec..70277b1 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -444,6 +444,7 @@ done:
 static void nfnetlink_rcv(struct sk_buff *skb)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(skb);
+	u_int16_t res_id;
 	int msglen;
 
 	if (nlh->nlmsg_len < NLMSG_HDRLEN ||
@@ -468,7 +469,12 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 
 		nfgenmsg = nlmsg_data(nlh);
 		skb_pull(skb, msglen);
-		nfnetlink_rcv_batch(skb, nlh, nfgenmsg->res_id);
+		/* Work around old nft using host byte order */
+		if (nfgenmsg->res_id == NFNL_SUBSYS_NFTABLES)
+			res_id = NFNL_SUBSYS_NFTABLES;
+		else
+			res_id = ntohs(nfgenmsg->res_id);
+		nfnetlink_rcv_batch(skb, nlh, res_id);
 	} else {
 		netlink_rcv_skb(skb, &nfnetlink_rcv_msg);
 	}
-- 
1.7.10.4


--1yeeQ81UyVL57Vl7--
