From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 2/3] netfilter: nf_conntrack_netlink: add const
 qualifier to nfnl_hook
Date: Fri, 11 Sep 2015 12:09:13 +0900
Message-ID: <20150911030913.GC7380@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34521 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbIKDJS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 23:09:18 -0400
Received: by padhy16 with SMTP id hy16so61136831pad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 20:09:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150911030530.GA7380@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

get_ct as is and will not update its skb argument, and users of
nfnl_ct_hook is now only nfqueue, so we can add const qualifier.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/linux/netfilter.h            |    2 +-
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 6df59f0..4c3bde9 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -380,7 +380,7 @@ enum ip_conntrack_info;
 struct nlattr;
 
 struct nfnl_ct_hook {
-	struct nf_conn *(*get_ct)(struct sk_buff *skb,
+	struct nf_conn *(*get_ct)(const struct sk_buff *skb,
 				  enum ip_conntrack_info *ctinfo);
 	size_t (*build_size)(const struct nf_conn *ct);
 	int (*build)(struct sk_buff *skb, struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d6a5514..155b2d0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2139,7 +2139,7 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *mask);
 
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-static struct nf_conn *ctnetlink_glue_get_ct(struct sk_buff *skb,
+static struct nf_conn *ctnetlink_glue_get_ct(const struct sk_buff *skb,
 					     enum ip_conntrack_info *ctinfo)
 {
 	struct nf_conn *ct;
-- 
1.7.10.4

