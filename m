From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 3/4] netfilter: nf_conntrack_netlink: add const
 qualifier to nfnl_hook.get_ct
Date: Mon, 5 Oct 2015 11:49:56 +0900
Message-ID: <20151005024956.GD14637@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36104 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbJECuB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Oct 2015 22:50:01 -0400
Received: by pablk4 with SMTP id lk4so160760660pab.3
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2015 19:50:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151005024454.GA14637@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

get_ct as is and will not update its skb argument, and users of
nfnl_ct_hook is currently only nfqueue, we can add const qualifier.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/linux/netfilter.h            |    2 +-
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 27747de..edb3dc3 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -378,7 +378,7 @@ enum ip_conntrack_info;
 struct nlattr;
 
 struct nfnl_ct_hook {
-	struct nf_conn *(*get_ct)(struct sk_buff *skb,
+	struct nf_conn *(*get_ct)(const struct sk_buff *skb,
 				  enum ip_conntrack_info *ctinfo);
 	size_t (*build_size)(const struct nf_conn *ct);
 	int (*build)(struct sk_buff *skb, struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 71d6ada..9f52729 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2162,7 +2162,7 @@ ctnetlink_glue_build_size(const struct nf_conn *ct)
 	       ;
 }
 
-static struct nf_conn *ctnetlink_glue_get_ct(struct sk_buff *skb,
+static struct nf_conn *ctnetlink_glue_get_ct(const struct sk_buff *skb,
 					     enum ip_conntrack_info *ctinfo)
 {
 	struct nf_conn *ct;
-- 
1.7.10.4

