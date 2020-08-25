Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7757C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE992075F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHYWxL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHYWxL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:53:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418C5C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:53:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAhoP-00065X-K5; Wed, 26 Aug 2020 00:53:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: conntrack: remove ignore stats
Date:   Wed, 26 Aug 2020 00:52:43 +0200
Message-Id: <20200825225245.8072-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825225245.8072-1-fw@strlen.de>
References: <20200825225245.8072-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This counter increments when nf_conntrack_in sees a packet that already
has a conntrack attached or when the packet is marked as UNTRACKED.
Neither is an error.

The former is normal for loopback traffic.  The second happens for
certain ICMPv6 packets or when nftables/ip(6)tables rules are in place.

In case someone needs to count UNTRACKED packets, or packets
that are marked as untracked before conntrack_in this can be done with
both nftables and ip(6)tables rules.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_common.h      | 1 -
 include/uapi/linux/netfilter/nfnetlink_conntrack.h | 2 +-
 net/netfilter/nf_conntrack_core.c                  | 4 +---
 net/netfilter/nf_conntrack_netlink.c               | 1 -
 net/netfilter/nf_conntrack_standalone.c            | 2 +-
 5 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 1db83c931d9c..96b90d7e361f 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -8,7 +8,6 @@
 struct ip_conntrack_stat {
 	unsigned int found;
 	unsigned int invalid;
-	unsigned int ignore;
 	unsigned int insert;
 	unsigned int insert_failed;
 	unsigned int drop;
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 262881792671..3e471558da82 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -247,7 +247,7 @@ enum ctattr_stats_cpu {
 	CTA_STATS_FOUND,
 	CTA_STATS_NEW,		/* no longer used */
 	CTA_STATS_INVALID,
-	CTA_STATS_IGNORE,
+	CTA_STATS_IGNORE,	/* no longer used */
 	CTA_STATS_DELETE,	/* no longer used */
 	CTA_STATS_DELETE_LIST,	/* no longer used */
 	CTA_STATS_INSERT,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3cfbafdff941..a111bcf1b93c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1800,10 +1800,8 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	if (tmpl || ctinfo == IP_CT_UNTRACKED) {
 		/* Previously seen (loopback or untracked)?  Ignore. */
 		if ((tmpl && !nf_ct_is_template(tmpl)) ||
-		     ctinfo == IP_CT_UNTRACKED) {
-			NF_CT_STAT_INC_ATOMIC(state->net, ignore);
+		     ctinfo == IP_CT_UNTRACKED)
 			return NF_ACCEPT;
-		}
 		skb->_nfct = 0;
 	}
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 832eabecfbdd..c64f23a8f373 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2509,7 +2509,6 @@ ctnetlink_ct_stat_cpu_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 
 	if (nla_put_be32(skb, CTA_STATS_FOUND, htonl(st->found)) ||
 	    nla_put_be32(skb, CTA_STATS_INVALID, htonl(st->invalid)) ||
-	    nla_put_be32(skb, CTA_STATS_IGNORE, htonl(st->ignore)) ||
 	    nla_put_be32(skb, CTA_STATS_INSERT, htonl(st->insert)) ||
 	    nla_put_be32(skb, CTA_STATS_INSERT_FAILED,
 				htonl(st->insert_failed)) ||
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index a604f43e3e6b..b673a03624d2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -439,7 +439,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 		   st->found,
 		   0,
 		   st->invalid,
-		   st->ignore,
+		   0,
 		   0,
 		   0,
 		   st->insert,
-- 
2.26.2

