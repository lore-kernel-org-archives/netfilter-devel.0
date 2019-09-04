Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193DCC3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 12:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E54B022CED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 12:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfIDMQy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 08:16:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:43676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbfIDMQy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 08:16:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E63F1AE14;
        Wed,  4 Sep 2019 12:16:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 48221E0329; Wed,  4 Sep 2019 14:16:51 +0200 (CEST)
Date:   Wed, 4 Sep 2019 14:16:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: userspace conntrack helper and confirming the master conntrack
Message-ID: <20190904121651.GA25494@unicorn.suse.cz>
References: <20190718084943.GE24551@unicorn.suse.cz>
 <20190718092128.zbw4qappq6jsb4ja@breakpoint.cc>
 <20190718101806.GF24551@unicorn.suse.cz>
 <20190719164742.iasbyklx47sqpw7y@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719164742.iasbyklx47sqpw7y@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 19, 2019 at 06:47:42PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 18, 2019 at 12:18:06PM +0200, Michal Kubecek wrote:
> > On Thu, Jul 18, 2019 at 11:21:28AM +0200, Florian Westphal wrote:
> > > > I added some more tracing and this is what seems to happen:
> > > > 
> > > >   - ipv4_confirm() is called for the conntrack from ip_output() via hook
> > > >   - nf_confirm() calls attached helper and calls its help() function
> > > >     which is nfnl_userspace_cthelper(), that returns 0x78003
> > > >   - nf_confirm() returns that without calling nf_confirm_conntrack()
> > > >   - verdict 0x78003 is returned to nf_hook_slow() which therefore calls
> > > >     nf_queue() to pass this to userspace helper on queue 7
> > > >   - nf_queue() returns 0 which is also returned by nf_hook_slow()
> > > >   - the packet reappears in nf_reinject() where it passes through
> > > >     nf_reroute() and nf_iterate() to the main switch statement
> > > >   - it takes NF_ACCEPT branch to call okfn which is ip_finish_output()
> > > >   - unless I missed something, there is nothing that could confirm the
> > > >     conntrack after that
> > > 
> > > I broke this with
> > > commit 827318feb69cb07ed58bb9b9dd6c2eaa81a116ad
> > > ("netfilter: conntrack: remove helper hook again").
> > > 
> > > Seems we have to revert, i see no other solution at this time.
> > 
> > Thanks for the quick reply. I can confirm that with commit 827318feb69c
> > reverted, the helper works as expected.
> 
> I'll schedule a revert in the next net batch.

This seems to have fallen through the cracks. I tried to do the revert
but it's not completely straightforward as bridge conntrack has been
introduced in between and I'm not sure I got the bridge part right.
Could someone more familiar with the code take a look?

Michal

---
 include/net/netfilter/nf_conntrack_core.h  |   3 -
 net/bridge/netfilter/nf_conntrack_bridge.c |  89 ++++++++++---
 net/netfilter/nf_conntrack_proto.c         | 141 ++++++++++++++++-----
 3 files changed, 178 insertions(+), 55 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index de10faf2ce91..ae41e92251dd 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -64,9 +64,6 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	return ret;
 }
 
-unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
-			struct nf_conn *ct, enum ip_conntrack_info ctinfo);
-
 void print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_l4proto *proto);
 
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 4f5444d2a526..0c54a4e3ead9 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -15,6 +15,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_bridge.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
@@ -353,6 +354,26 @@ static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
 	return br_dev_queue_push_xmit(net, sk, skb);
 }
 
+static int nf_ct_bridge_skb_protoff(struct sk_buff *skb)
+{
+	if (skb->protocol == ETH_P_IP)
+		return skb_network_offset(skb) + ip_hdrlen(skb);
+
+	if (skb->protocol == ETH_P_IPV6) {
+		unsigned char pnum = ipv6_hdr(skb)->nexthdr;
+		__be16 frag_off;
+		int protoff;
+
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
+					   &frag_off);
+		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+			return -EINVAL;
+		return protoff;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static unsigned int nf_ct_bridge_confirm(struct sk_buff *skb)
 {
 	enum ip_conntrack_info ctinfo;
@@ -361,26 +382,25 @@ static unsigned int nf_ct_bridge_confirm(struct sk_buff *skb)
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
+		goto out;
 
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
-		break;
-	case htons(ETH_P_IPV6): {
-		 unsigned char pnum = ipv6_hdr(skb)->nexthdr;
-		__be16 frag_off;
-
-		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
-					   &frag_off);
-		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
-			return nf_conntrack_confirm(skb);
-		}
-		break;
-	default:
+	protoff = nf_ct_bridge_skb_protoff(skb);
+	if (protoff == -EOPNOTSUPP)
 		return NF_ACCEPT;
+	if (protoff < 0)
+		goto out;
+
+	/* adjust seqs for loopback traffic only in outgoing direction */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
 	}
-	return nf_confirm(skb, protoff, ct, ctinfo);
+out:
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
 }
 
 static unsigned int nf_ct_bridge_post(void *priv, struct sk_buff *skb,
@@ -395,6 +415,35 @@ static unsigned int nf_ct_bridge_post(void *priv, struct sk_buff *skb,
 	return nf_ct_bridge_refrag(skb, state, nf_ct_bridge_refrag_post);
 }
 
+static unsigned int nf_ct_bridge_helper(void *priv, struct sk_buff *skb,
+					const struct nf_hook_state *state)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int protoff;
+
+	/* This is where we call the helper: as the packet goes out. */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+	/* rcu_read_lock()ed by nf_hook_thresh */
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	protoff = nf_ct_bridge_skb_protoff(skb);
+	if (protoff < 0)
+		return NF_ACCEPT;
+
+	return helper->help(skb, protoff, ct, ctinfo);
+}
+
 static struct nf_hook_ops nf_ct_bridge_hook_ops[] __read_mostly = {
 	{
 		.hook		= nf_ct_bridge_pre,
@@ -402,6 +451,12 @@ static struct nf_hook_ops nf_ct_bridge_hook_ops[] __read_mostly = {
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
+	{
+		.hook		= nf_ct_bridge_helper,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_BR_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
 	{
 		.hook		= nf_ct_bridge_post,
 		.pf		= NFPROTO_BRIDGE,
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index a0560d175a7f..a000725bb248 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -121,54 +121,55 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto)
 };
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_find);
 
-unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
-			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+static unsigned int ipv4_helper(void *priv,
+				struct sk_buff *skb,
+				const struct nf_hook_state *state)
 {
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
 	const struct nf_conn_help *help;
+	const struct nf_conntrack_helper *helper;
+
+	/* This is where we call the helper: as the packet goes out. */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
 
 	help = nfct_help(ct);
-	if (help) {
-		const struct nf_conntrack_helper *helper;
-		int ret;
-
-		/* rcu_read_lock()ed by nf_hook_thresh */
-		helper = rcu_dereference(help->helper);
-		if (helper) {
-			ret = helper->help(skb,
-					   protoff,
-					   ct, ctinfo);
-			if (ret != NF_ACCEPT)
-				return ret;
-		}
-	}
+	if (!help)
+		return NF_ACCEPT;
 
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return NF_DROP;
-		}
-	}
+	/* rcu_read_lock()ed by nf_hook_thresh */
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
 
-	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
+	return helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
+			    ct, ctinfo);
 }
-EXPORT_SYMBOL_GPL(nf_confirm);
 
 static unsigned int ipv4_confirm(void *priv,
 				 struct sk_buff *skb,
 				 const struct nf_hook_state *state)
 {
-	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
+		goto out;
 
-	return nf_confirm(skb,
-			  skb_network_offset(skb) + ip_hdrlen(skb),
-			  ct, ctinfo);
+	/* adjust seqs for loopback traffic only in outgoing direction */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, ip_hdrlen(skb))) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
+	}
+out:
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
 }
 
 static unsigned int ipv4_conntrack_in(void *priv,
@@ -216,12 +217,24 @@ static const struct nf_hook_ops ipv4_conntrack_ops[] = {
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
+	{
+		.hook		= ipv4_helper,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
 	{
 		.hook		= ipv4_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 	},
+	{
+		.hook		= ipv4_helper,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
 	{
 		.hook		= ipv4_confirm,
 		.pf		= NFPROTO_IPV4,
@@ -367,21 +380,31 @@ static unsigned int ipv6_confirm(void *priv,
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned char pnum = ipv6_hdr(skb)->nexthdr;
-	__be16 frag_off;
 	int protoff;
+	__be16 frag_off;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
+		goto out;
 
 	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
 				   &frag_off);
 	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
 		pr_debug("proto header not found\n");
-		return nf_conntrack_confirm(skb);
+		goto out;
 	}
 
-	return nf_confirm(skb, protoff, ct, ctinfo);
+	/* adjust seqs for loopback traffic only in outgoing direction */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
+	}
+out:
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
 }
 
 static unsigned int ipv6_conntrack_in(void *priv,
@@ -398,6 +421,42 @@ static unsigned int ipv6_conntrack_local(void *priv,
 	return nf_conntrack_in(skb, state);
 }
 
+static unsigned int ipv6_helper(void *priv,
+				struct sk_buff *skb,
+				const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	const struct nf_conn_help *help;
+	const struct nf_conntrack_helper *helper;
+	enum ip_conntrack_info ctinfo;
+	__be16 frag_off;
+	int protoff;
+	u8 nexthdr;
+
+	/* This is where we call the helper: as the packet goes out. */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+	/* rcu_read_lock()ed by nf_hook_thresh */
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	nexthdr = ipv6_hdr(skb)->nexthdr;
+	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+				   &frag_off);
+	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
+		pr_debug("proto header not found\n");
+		return NF_ACCEPT;
+	}
+
+	return helper->help(skb, protoff, ct, ctinfo);
+}
+
 static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 	{
 		.hook		= ipv6_conntrack_in,
@@ -411,12 +470,24 @@ static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_CONNTRACK,
 	},
+	{
+		.hook		= ipv6_helper,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
+	},
 	{
 		.hook		= ipv6_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_LAST,
 	},
+	{
+		.hook		= ipv6_helper,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
+	},
 	{
 		.hook		= ipv6_confirm,
 		.pf		= NFPROTO_IPV6,
-- 
2.23.0

