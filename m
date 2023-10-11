Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C27CD6E7E
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 15:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjJKPHJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 11:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbjJKPHI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 11:07:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DA492;
        Wed, 11 Oct 2023 08:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qAhJPV2BPBzeLEQdVzl6nOEBmPdCMsT21a1DgtSFvxE=; b=cGdtaBcUZlSkr70St1oiyNWQtR
        1c0ES2/jcNazy7ZJIm7JdYMAdqLiZeL51Pl0wG6aq1+rCrDvnbkDSIA6gpVo/MZu4cRo3MnX2X6QW
        XHUNmEKvvkYGStONwrWSg2xxUgPq97mZrMH1APJKGmQZtiMGPvcvvW8CvJ8tlciENY0VTpueT6s+i
        pj6Fp0Ivw+hk0lR46K6Q9pAuai1Pgv6nR5yBvxg+DosC9Q6TMlfEGgsR7I5dmdWL8p5C7elAoNll/
        9JO0XJox2XlIh00g7LktapyElOtzZoD1TzvL4WDIbAvGHRIqKBvDRBEBg1/qrV33QtoMgKrLIU5nS
        yaU4dlaw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qqane-0005QU-So; Wed, 11 Oct 2023 17:07:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [nf PATCH v2] netfilter: nf_tables: audit log object reset once per table
Date:   Wed, 11 Oct 2023 17:06:59 +0200
Message-ID: <20231011150659.398-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When resetting multiple objects at once (via dump request), emit a log
message per table (or filled skb) and resurrect the 'entries' parameter
to contain the number of objects being logged for.

To test the skb exhaustion path, perform some bulk counter and quota
adds in the kselftest.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com> (Audit)
---
Changes since v1:
- Rebased onto nf/main, eliminated the dependency on reset locking
  series
- Dropped a leftover paragraph from the commit message talking about
  audit_logread adjustment which was avoided by patch reordering before
  v1 already
---
 net/netfilter/nf_tables_api.c                 | 50 +++++++++++--------
 .../testing/selftests/netfilter/nft_audit.sh  | 46 +++++++++++++++++
 2 files changed, 74 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a72b6aeefb1b5..adab5524bd901 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7615,6 +7615,16 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
+static void audit_log_obj_reset(const struct nft_table *table,
+				unsigned int base_seq, unsigned int nentries)
+{
+	char *buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, base_seq);
+
+	audit_log_nfcfg(buf, table->family, nentries,
+			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
+	kfree(buf);
+}
+
 struct nft_obj_filter {
 	char		*table;
 	u32		type;
@@ -7629,8 +7639,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
+	unsigned int entries = 0;
 	struct nft_object *obj;
 	bool reset = false;
+	int rc = 0;
 
 	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
@@ -7643,6 +7655,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
+		entries = 0;
 		list_for_each_entry_rcu(obj, &table->objects, list) {
 			if (!nft_is_active(net, obj))
 				goto cont;
@@ -7658,34 +7671,27 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 			    filter->type != NFT_OBJECT_UNSPEC &&
 			    obj->ops->type->type != filter->type)
 				goto cont;
-			if (reset) {
-				char *buf = kasprintf(GFP_ATOMIC,
-						      "%s:%u",
-						      table->name,
-						      nft_net->base_seq);
-
-				audit_log_nfcfg(buf,
-						family,
-						obj->handle,
-						AUDIT_NFT_OP_OBJ_RESET,
-						GFP_ATOMIC);
-				kfree(buf);
-			}
 
-			if (nf_tables_fill_obj_info(skb, net, NETLINK_CB(cb->skb).portid,
-						    cb->nlh->nlmsg_seq,
-						    NFT_MSG_NEWOBJ,
-						    NLM_F_MULTI | NLM_F_APPEND,
-						    table->family, table,
-						    obj, reset) < 0)
-				goto done;
+			rc = nf_tables_fill_obj_info(skb, net,
+						     NETLINK_CB(cb->skb).portid,
+						     cb->nlh->nlmsg_seq,
+						     NFT_MSG_NEWOBJ,
+						     NLM_F_MULTI | NLM_F_APPEND,
+						     table->family, table,
+						     obj, reset);
+			if (rc < 0)
+				break;
 
+			entries++;
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
 			idx++;
 		}
+		if (reset && entries)
+			audit_log_obj_reset(table, nft_net->base_seq, entries);
+		if (rc < 0)
+			break;
 	}
-done:
 	rcu_read_unlock();
 
 	cb->args[0] = idx;
@@ -7790,7 +7796,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 
 		audit_log_nfcfg(buf,
 				family,
-				obj->handle,
+				1,
 				AUDIT_NFT_OP_OBJ_RESET,
 				GFP_ATOMIC);
 		kfree(buf);
diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index bb34329e02a7f..e94a80859bbdb 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -93,6 +93,12 @@ do_test 'nft add counter t1 c1' \
 do_test 'nft add counter t2 c1; add counter t2 c2' \
 'table=t2 family=2 entries=2 op=nft_register_obj'
 
+for ((i = 3; i <= 500; i++)); do
+	echo "add counter t2 c$i"
+done >$rulefile
+do_test "nft -f $rulefile" \
+'table=t2 family=2 entries=498 op=nft_register_obj'
+
 # adding/updating quotas
 
 do_test 'nft add quota t1 q1 { 10 bytes }' \
@@ -101,6 +107,12 @@ do_test 'nft add quota t1 q1 { 10 bytes }' \
 do_test 'nft add quota t2 q1 { 10 bytes }; add quota t2 q2 { 10 bytes }' \
 'table=t2 family=2 entries=2 op=nft_register_obj'
 
+for ((i = 3; i <= 500; i++)); do
+	echo "add quota t2 q$i { 10 bytes }"
+done >$rulefile
+do_test "nft -f $rulefile" \
+'table=t2 family=2 entries=498 op=nft_register_obj'
+
 # changing the quota value triggers obj update path
 do_test 'nft add quota t1 q1 { 20 bytes }' \
 'table=t1 family=2 entries=1 op=nft_register_obj'
@@ -150,6 +162,40 @@ done
 do_test 'nft reset set t1 s' \
 'table=t1 family=2 entries=3 op=nft_reset_setelem'
 
+# resetting counters
+
+do_test 'nft reset counter t1 c1' \
+'table=t1 family=2 entries=1 op=nft_reset_obj'
+
+do_test 'nft reset counters t1' \
+'table=t1 family=2 entries=1 op=nft_reset_obj'
+
+do_test 'nft reset counters t2' \
+'table=t2 family=2 entries=342 op=nft_reset_obj
+table=t2 family=2 entries=158 op=nft_reset_obj'
+
+do_test 'nft reset counters' \
+'table=t1 family=2 entries=1 op=nft_reset_obj
+table=t2 family=2 entries=341 op=nft_reset_obj
+table=t2 family=2 entries=159 op=nft_reset_obj'
+
+# resetting quotas
+
+do_test 'nft reset quota t1 q1' \
+'table=t1 family=2 entries=1 op=nft_reset_obj'
+
+do_test 'nft reset quotas t1' \
+'table=t1 family=2 entries=1 op=nft_reset_obj'
+
+do_test 'nft reset quotas t2' \
+'table=t2 family=2 entries=315 op=nft_reset_obj
+table=t2 family=2 entries=185 op=nft_reset_obj'
+
+do_test 'nft reset quotas' \
+'table=t1 family=2 entries=1 op=nft_reset_obj
+table=t2 family=2 entries=314 op=nft_reset_obj
+table=t2 family=2 entries=186 op=nft_reset_obj'
+
 # deleting rules
 
 readarray -t handles < <(nft -a list chain t1 c1 | \
-- 
2.41.0

