Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A50C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Nov 2022 09:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiK1J67 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Nov 2022 04:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiK1J67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2022 04:58:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C44ED13DCC
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2022 01:58:57 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark
Date:   Mon, 28 Nov 2022 10:58:53 +0100
Message-Id: <20221128095853.10589-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All warnings (new ones prefixed by >>):

   net/netfilter/nf_conntrack_netlink.c: In function '__ctnetlink_glue_build':
>> net/netfilter/nf_conntrack_netlink.c:2674:13: warning: unused variable 'mark' [-Wunused-variable]
    2674 |         u32 mark;
         |             ^~~~

Fixes: 52d1aa8b8249 ("netfilter: conntrack: Fix data-races around ct mark")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d71150a40fb0..1286ae7d4609 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -328,8 +328,13 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
+	u32 mark = READ_ONCE(ct->mark);
+
+	if (!mark)
+		return 0;
+
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
@@ -543,7 +548,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -722,7 +727,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
-	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -827,9 +831,8 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if ((events & (1 << IPCT_MARK) || mark) &&
-	    ctnetlink_dump_mark(skb, mark) < 0)
+	if (events & (1 << IPCT_MARK) &&
+	    ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2671,7 +2674,6 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
-	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2733,8 +2735,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
+	if (ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
-- 
2.30.2

