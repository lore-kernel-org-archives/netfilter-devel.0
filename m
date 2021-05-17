Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B768C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 May 2021 12:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F2626100C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 May 2021 12:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhEQMoa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 May 2021 08:44:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40400 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237103AbhEQMoa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 May 2021 08:44:30 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 228696413B;
        Mon, 17 May 2021 14:42:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kadlec@netfilter.org
Subject: [PATCH nf-next] netfilter: use nfnetlink_unicast()
Date:   Mon, 17 May 2021 14:43:08 +0200
Message-Id: <20210517124308.14375-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace netlink_unicast() calls by nfnetlink_unicast() which already
deals with translating EAGAIN to ENOBUFS as the nfnetlink core expects.

nfnetlink_unicast() calls nlmsg_unicast() which also sets the return
value to zero in case of success, otherwise the netlink core function
netlink_rcv_skb() turns err > 0 into an acknowlegment.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Jozsef: I skipped ipset conversion to nfnetlink_unicast(),
ip_set_header(), ip_set_type() and ip_set_protocol() use  netlink_unicast()
which returns > 0 in case of success. I think this triggers an acknowlegment
message when netlink_rcv_skb() is called.

I can see lib/mnl.c in ipset userspace do not set NLM_F_ACK.

static const uint16_t cmdflags[] = {
        [IPSET_CMD_CREATE-1]    = NLM_F_REQUEST|NLM_F_ACK|
                                        NLM_F_CREATE|NLM_F_EXCL,
        [IPSET_CMD_DESTROY-1]   = NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL,
        [IPSET_CMD_FLUSH-1]     = NLM_F_REQUEST|NLM_F_ACK,
        [IPSET_CMD_RENAME-1]    = NLM_F_REQUEST|NLM_F_ACK,
        [IPSET_CMD_SWAP-1]      = NLM_F_REQUEST|NLM_F_ACK,
        [IPSET_CMD_LIST-1]      = NLM_F_REQUEST|NLM_F_ACK|NLM_F_DUMP,
        [IPSET_CMD_SAVE-1]      = NLM_F_REQUEST|NLM_F_ACK|NLM_F_DUMP,
        [IPSET_CMD_ADD-1]       = NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL,
        [IPSET_CMD_DEL-1]       = NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL,
        [IPSET_CMD_TEST-1]      = NLM_F_REQUEST|NLM_F_ACK,
        [IPSET_CMD_HEADER-1]    = NLM_F_REQUEST,
        [IPSET_CMD_TYPE-1]      = NLM_F_REQUEST,
        [IPSET_CMD_PROTOCOL-1]  = NLM_F_REQUEST,

I did not test but maybe userspace is expecting the NLM_F_ACK message
as reply to the IPSET_CMD_HEADER, IPSET_CMD_TYPE and IPSET_CMD_PROTOCOL
commands.

 net/netfilter/nf_conntrack_netlink.c | 41 ++++++++++------------------
 net/netfilter/nfnetlink_acct.c       |  9 ++----
 net/netfilter/nfnetlink_cthelper.c   | 10 ++-----
 net/netfilter/nfnetlink_cttimeout.c  | 34 +++++++----------------
 4 files changed, 31 insertions(+), 63 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8690fc07030f..3b2aacaa75d4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1643,18 +1643,15 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
 	if (err <= 0)
 		goto free;

-	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
+	err = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 	if (err < 0)
-		goto out;
+		return err;

 	return 0;
-
 free:
 	kfree_skb(skb2);
-out:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
+
+	return -ENOMEM;
 }

 static int ctnetlink_done_list(struct netlink_callback *cb)
@@ -2593,18 +2590,15 @@ static int ctnetlink_stat_ct(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err <= 0)
 		goto free;

-	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
+	err = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 	if (err < 0)
-		goto out;
+		return err;

 	return 0;
-
 free:
 	kfree_skb(skb2);
-out:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
+
+	return -ENOMEM;
 }

 static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
@@ -3333,7 +3327,7 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (skb2 == NULL) {
 		nf_ct_expect_put(exp);
-		goto out;
+		return -ENOMEM;
 	}

 	rcu_read_lock();
@@ -3342,21 +3336,16 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 				      exp);
 	rcu_read_unlock();
 	nf_ct_expect_put(exp);
-	if (err <= 0)
-		goto free;
+	if (err <= 0) {
+		kfree_skb(skb2);
+		return -ENOMEM;
+	}

-	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
+	err = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 	if (err < 0)
-		goto out;
+		return err;

 	return 0;
-
-free:
-	kfree_skb(skb2);
-out:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
 }

 static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 3c8cf8748cfb..505f46a32173 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -314,14 +314,11 @@ static int nfnl_acct_get(struct sk_buff *skb, const struct nfnl_info *info,
 			kfree_skb(skb2);
 			break;
 		}
-		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-				      MSG_DONTWAIT);
-		if (ret > 0)
-			ret = 0;

-		/* this avoids a loop in nfnetlink. */
-		return ret == -EAGAIN ? -ENOBUFS : ret;
+		ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+		break;
 	}
+
 	return ret;
 }

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 322ac5dd5402..df58cd534ff5 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -663,14 +663,10 @@ static int nfnl_cthelper_get(struct sk_buff *skb, const struct nfnl_info *info,
 			break;
 		}

-		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-				      MSG_DONTWAIT);
-		if (ret > 0)
-			ret = 0;
-
-		/* this avoids a loop in nfnetlink. */
-		return ret == -EAGAIN ? -ENOBUFS : ret;
+		ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+		break;
 	}
+
 	return ret;
 }

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 38848ad68899..5d72b3055378 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -287,14 +287,11 @@ static int cttimeout_get_timeout(struct sk_buff *skb,
 			kfree_skb(skb2);
 			break;
 		}
-		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-				      MSG_DONTWAIT);
-		if (ret > 0)
-			ret = 0;

-		/* this avoids a loop in nfnetlink. */
-		return ret == -EAGAIN ? -ENOBUFS : ret;
+		ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+		break;
 	}
+
 	return ret;
 }

@@ -427,9 +424,9 @@ static int cttimeout_default_get(struct sk_buff *skb,
 	const struct nf_conntrack_l4proto *l4proto;
 	unsigned int *timeouts = NULL;
 	struct sk_buff *skb2;
-	int ret, err;
 	__u16 l3num;
 	__u8 l4num;
+	int ret;

 	if (!cda[CTA_TIMEOUT_L3PROTO] || !cda[CTA_TIMEOUT_L4PROTO])
 		return -EINVAL;
@@ -438,9 +435,8 @@ static int cttimeout_default_get(struct sk_buff *skb,
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
 	l4proto = nf_ct_l4proto_find(l4num);

-	err = -EOPNOTSUPP;
 	if (l4proto->l4proto != l4num)
-		goto err;
+		return -EOPNOTSUPP;

 	switch (l4proto->l4proto) {
 	case IPPROTO_ICMP:
@@ -480,13 +476,11 @@ static int cttimeout_default_get(struct sk_buff *skb,
 	}

 	if (!timeouts)
-		goto err;
+		return -EOPNOTSUPP;

 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL) {
-		err = -ENOMEM;
-		goto err;
-	}
+	if (skb2 == NULL)
+		return -ENOMEM;

 	ret = cttimeout_default_fill_info(info->net, skb2,
 					  NETLINK_CB(skb).portid,
@@ -496,18 +490,10 @@ static int cttimeout_default_get(struct sk_buff *skb,
 					  l3num, l4proto, timeouts);
 	if (ret <= 0) {
 		kfree_skb(skb2);
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret > 0)
-		ret = 0;

-	/* this avoids a loop in nfnetlink. */
-	return ret == -EAGAIN ? -ENOBUFS : ret;
-err:
-	return err;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 }

 static struct nf_ct_timeout *ctnl_timeout_find_get(struct net *net,
--
2.20.1

