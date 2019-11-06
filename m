Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E40C5DF62
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 11:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D17E1217D7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 11:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbfKFLNB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 06:13:01 -0500
Received: from correo.us.es ([193.147.175.20]:44084 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbfKFLMt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 06:12:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA7953066B6
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 12:12:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADF7DB8007
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 12:12:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3271B8001; Wed,  6 Nov 2019 12:12:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D5CCDA72F;
        Wed,  6 Nov 2019 12:12:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 12:12:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5F9BC41E4802;
        Wed,  6 Nov 2019 12:12:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/9] netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT
Date:   Wed,  6 Nov 2019 12:12:32 +0100
Message-Id: <20191106111237.3183-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191106111237.3183-1-pablo@netfilter.org>
References: <20191106111237.3183-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Since v5.2 (commit "netlink: re-add parse/validate functions in strict
mode") NL_VALIDATE_STRICT is enabled. Fix the ipset nla_policies which did
not support strict mode and convert from deprecated parsings to verified ones.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c        | 41 ++++++++++++++++++++++----------
 net/netfilter/ipset/ip_set_hash_net.c    |  1 +
 net/netfilter/ipset/ip_set_hash_netnet.c |  1 +
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e7288eab7512..d73d1828216a 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -296,7 +296,8 @@ ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipaddr)
 
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
+			     ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV4)))
 		return -IPSET_ERR_PROTOCOL;
@@ -314,7 +315,8 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
+			     ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV6)))
 		return -IPSET_ERR_PROTOCOL;
@@ -934,7 +936,8 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 
 	/* Without holding any locks, create private part. */
 	if (attr[IPSET_ATTR_DATA] &&
-	    nla_parse_nested_deprecated(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA], set->type->create_policy, NULL)) {
+	    nla_parse_nested(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA],
+			     set->type->create_policy, NULL)) {
 		ret = -IPSET_ERR_PROTOCOL;
 		goto put_out;
 	}
@@ -1281,6 +1284,14 @@ dump_attrs(struct nlmsghdr *nlh)
 	}
 }
 
+static const struct nla_policy
+ip_set_dump_policy[IPSET_ATTR_CMD_MAX + 1] = {
+	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
+	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
+				    .len = IPSET_MAXNAMELEN - 1 },
+	[IPSET_ATTR_FLAGS]	= { .type = NLA_U32 },
+};
+
 static int
 dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 {
@@ -1292,9 +1303,9 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	ip_set_id_t index;
 	int ret;
 
-	ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
-				   nlh->nlmsg_len - min_len,
-				   ip_set_setname_policy, NULL);
+	ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, attr,
+			nlh->nlmsg_len - min_len,
+			ip_set_dump_policy, NULL);
 	if (ret)
 		return ret;
 
@@ -1543,9 +1554,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-					   nlh->nlmsg_len - min_len,
-					   ip_set_adt_policy, NULL);
+		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+				nlh->nlmsg_len - min_len, ip_set_adt_policy,
+				NULL);
 
 		if (ret) {
 			nlmsg_free(skb2);
@@ -1596,7 +1607,9 @@ static int ip_set_ad(struct net *net, struct sock *ctnl,
 
 	use_lineno = !!attr[IPSET_ATTR_LINENO];
 	if (attr[IPSET_ATTR_DATA]) {
-		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
+		if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX,
+				     attr[IPSET_ATTR_DATA],
+				     set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
 		ret = call_ad(ctnl, skb, set, tb, adt, flags,
 			      use_lineno);
@@ -1606,7 +1619,8 @@ static int ip_set_ad(struct net *net, struct sock *ctnl,
 		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
 			if (nla_type(nla) != IPSET_ATTR_DATA ||
 			    !flag_nested(nla) ||
-			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
+			    nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, nla,
+					     set->type->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
 			ret = call_ad(ctnl, skb, set, tb, adt,
 				      flags, use_lineno);
@@ -1655,7 +1669,8 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	if (!set)
 		return -ENOENT;
 
-	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
+	if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA],
+			     set->type->adt_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 
 	rcu_read_lock_bh();
@@ -1961,7 +1976,7 @@ static const struct nfnl_callback ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
 	[IPSET_CMD_LIST]	= {
 		.call		= ip_set_dump,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
-		.policy		= ip_set_setname_policy,
+		.policy		= ip_set_dump_policy,
 	},
 	[IPSET_CMD_SAVE]	= {
 		.call		= ip_set_dump,
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index c259cbc3ef45..3d932de0ad29 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -368,6 +368,7 @@ static struct ip_set_type hash_net_type __read_mostly = {
 		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index a3ae69bfee66..4398322fad59 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -476,6 +476,7 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
 		[IPSET_ATTR_CIDR2]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
+		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-- 
2.11.0

