Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CB4C49ED9
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 23:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC38B21A4C
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 23:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfIJXYi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 19:24:38 -0400
Received: from correo.us.es ([193.147.175.20]:40068 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfIJXYi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 19:24:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C3EA2EFEA1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2019 01:24:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AF6DDA4CA
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2019 01:24:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 508F0DA840; Wed, 11 Sep 2019 01:24:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA3BBDA72F;
        Wed, 11 Sep 2019 01:24:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Sep 2019 01:24:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.177.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8EF894265A5A;
        Wed, 11 Sep 2019 01:24:28 +0200 (CEST)
Date:   Wed, 11 Sep 2019 01:24:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: userspace conntrack helper and confirming the master conntrack
Message-ID: <20190910232426.4ccs7jo7jwhni7az@salvia>
References: <20190718084943.GE24551@unicorn.suse.cz>
 <20190718092128.zbw4qappq6jsb4ja@breakpoint.cc>
 <20190718101806.GF24551@unicorn.suse.cz>
 <20190719164742.iasbyklx47sqpw7y@salvia>
 <20190904121651.GA25494@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="irt7hrvyk4qsto3g"
Content-Disposition: inline
In-Reply-To: <20190904121651.GA25494@unicorn.suse.cz>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--irt7hrvyk4qsto3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Michal,

On Wed, Sep 04, 2019 at 02:16:51PM +0200, Michal Kubecek wrote:
> This seems to have fallen through the cracks. I tried to do the revert
> but it's not completely straightforward as bridge conntrack has been
> introduced in between and I'm not sure I got the bridge part right.
> Could someone more familiar with the code take a look?

I'm exploring a different path, see attached patch (still untested).

I'm trying to avoid this large revert from Florian. The idea with this
patch is to invoke the conntrack confirmation path from the
nf_reinject() path, which is what it is missing.

I'm at a conference right now, I'll try scratch time to sort out this
asap. Most likely we'll have to request a patch to be included in
-stable in the next release I'm afraid.

I'm very sorry this has taken a bit to be sorted out.

--irt7hrvyk4qsto3g
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 049aeb40fa35..e4047aae0da7 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -448,6 +448,7 @@ struct nf_ct_hook {
 	void (*destroy)(struct nf_conntrack *);
 	bool (*get_tuple_skb)(struct nf_conntrack_tuple *,
 			      const struct sk_buff *);
+	unsigned int (*confirm)(struct sk_buff *);
 };
 extern struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index de10faf2ce91..42407086484f 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -66,6 +66,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 
 unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
 			struct nf_conn *ct, enum ip_conntrack_info ctinfo);
+unsigned int nf_confirm_queue(struct sk_buff *skb);
 
 void print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_l4proto *proto);
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 3cb6dcf53a4e..46bbd2389ffc 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -6,12 +6,16 @@
 #include <linux/ipv6.h>
 #include <linux/jhash.h>
 
+/* extra verdict flags have mask 0x0000ff00, see uapi/linux/netfilter.h */
+#define __NF_VERDICT_FLAG_USERSPACE_CT_HELPER	0x00004000
+
 /* Each queued (to userspace) skbuff has one of these. */
 struct nf_queue_entry {
 	struct list_head	list;
 	struct sk_buff		*skb;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
+	unsigned int		queue_flags;
 
 	struct nf_hook_state	state;
 	u16			size; /* sizeof(entry) + saved route keys */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 81a8ef42b88d..5238dc014156 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2487,6 +2487,7 @@ static struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
 	.destroy	= destroy_conntrack,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
+	.confirm	= nf_confirm_queue,
 };
 
 void nf_conntrack_init_end(void)
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index a0560d175a7f..493c2e12434a 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -121,6 +121,53 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto)
 };
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_find);
 
+static unsigned int __nf_confirm(struct sk_buff *skb, unsigned int protoff,
+				 struct nf_conn *ct,
+				 enum ip_conntrack_info ctinfo)
+{
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
+	}
+
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
+}
+
+unsigned int nf_confirm_queue(struct sk_buff *skb)
+{
+	enum ip_conntrack_info ctinfo;
+	unsigned int protoff;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return NF_ACCEPT;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		break;
+	case htons(ETH_P_IPV6): {
+		 unsigned char pnum = ipv6_hdr(skb)->nexthdr;
+		__be16 frag_off;
+
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
+					   &frag_off);
+		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+			return nf_conntrack_confirm(skb);
+		}
+		break;
+	default:
+		return NF_ACCEPT;
+	}
+
+	return __nf_confirm(skb, protoff, ct, ctinfo);
+}
+
 unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
 			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
@@ -142,16 +189,7 @@ unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
 		}
 	}
 
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return NF_DROP;
-		}
-	}
-
-	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
+	return __nf_confirm(skb, protoff, ct, ctinfo);
 }
 EXPORT_SYMBOL_GPL(nf_confirm);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a2b58de82600..85ff51cadd2a 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -156,7 +156,8 @@ static void nf_ip6_saveroute(const struct sk_buff *skb,
 }
 
 static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
-		      unsigned int index, unsigned int queuenum)
+		      unsigned int index, unsigned int queuenum,
+		      unsigned int queue_flags)
 {
 	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
@@ -198,6 +199,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.skb	= skb,
 		.state	= *state,
 		.hook_index = index,
+		.queue_flags = queue_flags,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
@@ -232,7 +234,8 @@ int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 {
 	int ret;
 
-	ret = __nf_queue(skb, state, index, verdict >> NF_VERDICT_QBITS);
+	ret = __nf_queue(skb, state, index, verdict >> NF_VERDICT_QBITS,
+			 verdict & __NF_VERDICT_FLAG_USERSPACE_CT_HELPER);
 	if (ret < 0) {
 		if (ret == -ESRCH &&
 		    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
@@ -324,6 +327,14 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 			verdict = NF_DROP;
 	}
 
+	if (verdict == NF_ACCEPT &&
+	    entry->queue_flags & __NF_VERDICT_FLAG_USERSPACE_CT_HELPER) {
+		struct nf_ct_hook *ct_hook = rcu_dereference(nf_ct_hook);
+
+		if (ct_hook)
+			verdict = nf_ct_hook->confirm(skb);
+	}
+
 	if (verdict == NF_ACCEPT) {
 next_hook:
 		++i;
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 7525063c25f5..2bf3b7c3ab9e 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -21,7 +21,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
-
+#include <net/netfilter/nf_queue.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <linux/netfilter/nfnetlink_cthelper.h>
@@ -60,7 +60,8 @@ nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 		return NF_ACCEPT;
 
 	/* If the user-space helper is not available, don't block traffic. */
-	return NF_QUEUE_NR(helper->queue_num) | NF_VERDICT_FLAG_QUEUE_BYPASS;
+	return NF_QUEUE_NR(helper->queue_num) | NF_VERDICT_FLAG_QUEUE_BYPASS |
+		__NF_VERDICT_FLAG_USERSPACE_CT_HELPER;
 }
 
 static const struct nla_policy nfnl_cthelper_tuple_pol[NFCTH_TUPLE_MAX+1] = {

--irt7hrvyk4qsto3g--
