From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 1/5] netfilter: nfnetlink_queue: enable to specify
 nla type
Date: Tue, 1 Sep 2015 09:37:35 +0900
Message-ID: <20150901003735.GB2642@gmail.com>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
 <20150901003436.GA2642@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33528 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbIAAhk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 20:37:40 -0400
Received: by paczk9 with SMTP id zk9so7707042pac.0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 17:37:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150901003436.GA2642@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch updates nfqnl_ct_put() signature to put not only queue
related attributes.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/net/netfilter/nfnetlink_queue.h |    8 +++++---
 net/netfilter/nfnetlink_queue_core.c    |    2 +-
 net/netfilter/nfnetlink_queue_ct.c      |    9 +++++----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nfnetlink_queue.h b/include/net/netfilter/nfnetlink_queue.h
index aff88ba..f94942b 100644
--- a/include/net/netfilter/nfnetlink_queue.h
+++ b/include/net/netfilter/nfnetlink_queue.h
@@ -11,8 +11,9 @@ struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
 struct nf_conn *nfqnl_ct_parse(const struct sk_buff *skb,
 			       const struct nlattr *attr,
 			       enum ip_conntrack_info *ctinfo);
-int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
-		 enum ip_conntrack_info ctinfo);
+int nfqnl_ct_put(struct sk_buff *skb,
+		 struct nf_conn *ct, int type,
+		 enum ip_conntrack_info ctinfo, int info_type);
 void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo, int diff);
 int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
@@ -32,7 +33,8 @@ inline struct nf_conn *nfqnl_ct_parse(const struct sk_buff *skb,
 }
 
 inline int
-nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct, int type,
+	     enum ip_conntrack_info ctinfo, int info_type)
 {
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 685cc6a..283a189 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -507,7 +507,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
 		goto nla_put_failure;
 
-	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
+	if (ct && nfqnl_ct_put(skb, ct, NFQA_CT, ctinfo, NFQA_CT_INFO) < 0)
 		goto nla_put_failure;
 
 	if (cap_len > data_len &&
diff --git a/net/netfilter/nfnetlink_queue_ct.c b/net/netfilter/nfnetlink_queue_ct.c
index 96cac50..2a30618 100644
--- a/net/netfilter/nfnetlink_queue_ct.c
+++ b/net/netfilter/nfnetlink_queue_ct.c
@@ -54,8 +54,9 @@ nfqnl_ct_parse(const struct sk_buff *skb, const struct nlattr *attr,
 	return ct;
 }
 
-int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
-		 enum ip_conntrack_info ctinfo)
+int nfqnl_ct_put(struct sk_buff *skb,
+		 struct nf_conn *ct, int type,
+		 enum ip_conntrack_info ctinfo, int info_type)
 {
 	struct nfq_ct_hook *nfq_ct;
 	struct nlattr *nest_parms;
@@ -65,7 +66,7 @@ int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
 	if (nfq_ct == NULL)
 		return 0;
 
-	nest_parms = nla_nest_start(skb, NFQA_CT | NLA_F_NESTED);
+	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
 
@@ -75,7 +76,7 @@ int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
 	nla_nest_end(skb, nest_parms);
 
 	tmp = ctinfo;
-	if (nla_put_be32(skb, NFQA_CT_INFO, htonl(tmp)))
+	if (nla_put_be32(skb, info_type, htonl(tmp)))
 		goto nla_put_failure;
 
 	return 0;
-- 
1.7.10.4

