Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE5DCE7A8E
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjIWByE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjIWByE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:54:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DF51AB;
        Fri, 22 Sep 2023 18:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lhntSk62DJ7jNzSQV7mXDoZt/eoKzXU7CqtO5wXv/8s=; b=qJ4UBlj6gxRzT0/czBu23fArFv
        GctlXHbhGITRzzW9aM4ql9hoFW7L/44gxXPujN3pdi46iqY8Iov3XzOfpBQPVqRMV6YjxgUeRThd5
        n3jM3xP1Ft1Mua/Jpyh23voenmfhOIalnw24Cb9amHDA6KbsK69sfQR8fFOluNs1XFzzFg8I3avoM
        OedMXZS3J7g/tjwdwSK0J3YIENHBAc3rnKrwqcP3UxrQ5etpRC5ch1NDUA19D6sQ5u5EUsNireX+l
        p/CSj4cYInKICK4BrW7rQ89bOXdeZe/Q68nFUK+jcFuTWl+uZXbfSCS1Tefr7eejb+cWVBoz9iIr4
        HH9KofGw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrqF-00028p-VH; Sat, 23 Sep 2023 03:53:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [nf PATCH 3/3] netfilter: nf_tables: Audit log object reset once per table
Date:   Sat, 23 Sep 2023 03:53:51 +0200
Message-ID: <20230923015351.15707-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923015351.15707-1-phil@nwl.cc>
References: <20230923015351.15707-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When resetting multiple objects at once (via dump request), emit a log
message per table (or filled skb) and resurrect the 'entries' parameter
to contain the number of objects being logged for.

With the above in place, all audit logs for op=nft_register_obj have a
predictable value in 'entries', so drop the value zeroing for them in
audit_logread.c.

To test the skb exhaustion path, perform some bulk counter and quota
adds in the kselftest.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c                 | 51 ++++++++++---------
 .../testing/selftests/netfilter/nft_audit.sh  | 46 +++++++++++++++++
 2 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 48d50df950a18..e04ef2c451be4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7733,6 +7733,16 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
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
 struct nft_obj_dump_ctx {
 	unsigned int	s_idx;
 	char		*table;
@@ -7748,8 +7758,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
 	const struct nft_table *table;
+	unsigned int entries = 0;
 	struct nft_object *obj;
 	unsigned int idx = 0;
+	int rc = 0;
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
@@ -7759,6 +7771,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
+		entries = 0;
 		list_for_each_entry_rcu(obj, &table->objects, list) {
 			if (!nft_is_active(net, obj))
 				goto cont;
@@ -7769,34 +7782,27 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 			if (ctx->type != NFT_OBJECT_UNSPEC &&
 			    obj->ops->type->type != ctx->type)
 				goto cont;
-			if (ctx->reset) {
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
-						    obj, ctx->reset) < 0)
-				goto done;
+			rc = nf_tables_fill_obj_info(skb, net,
+						     NETLINK_CB(cb->skb).portid,
+						     cb->nlh->nlmsg_seq,
+						     NFT_MSG_NEWOBJ,
+						     NLM_F_MULTI | NLM_F_APPEND,
+						     table->family, table,
+						     obj, ctx->reset);
+			if (rc < 0)
+				break;
 
+			entries++;
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
 			idx++;
 		}
+		if (ctx->reset && entries)
+			audit_log_obj_reset(table, nft_net->base_seq, entries);
+		if (rc < 0)
+			break;
 	}
-done:
 	rcu_read_unlock();
 
 	ctx->s_idx = idx;
@@ -7977,8 +7983,7 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 		return PTR_ERR(skb2);
 
 	buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
-	audit_log_nfcfg(buf, family, obj->handle,
-			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
+	audit_log_nfcfg(buf, family, 1, AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
 	kfree(buf);
 
 	return nfnetlink_unicast(skb2, net, portid);
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

