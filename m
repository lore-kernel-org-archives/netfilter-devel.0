Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B408C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 295342082E
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 19:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgAaTYh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 14:24:37 -0500
Received: from correo.us.es ([193.147.175.20]:36798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaTYg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 14:24:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C65DCFC5EC
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4C2DDA710
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 20:24:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9CECDA712; Fri, 31 Jan 2020 20:24:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94773DA70E;
        Fri, 31 Jan 2020 20:24:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 20:24:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 70AC042EFB80;
        Fri, 31 Jan 2020 20:24:33 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/6] netfilter: ipset: fix suspicious RCU usage in find_set_and_id
Date:   Fri, 31 Jan 2020 20:24:23 +0100
Message-Id: <20200131192428.167274-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200131192428.167274-1-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kadlecsik József <kadlec@blackhole.kfki.hu>

find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is held.
However, in the error path there can be a follow-up recvmsg() without
the mutex held. Use the start() function of struct netlink_dump_control
instead of dump() to verify and report if the specified set does not
exist.

Thanks to Pablo Neira Ayuso for helping me to understand the subleties
of the netlink protocol.

Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 41 ++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index cf895bc80871..69c107f9ba8d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1483,31 +1483,34 @@ ip_set_dump_policy[IPSET_ATTR_CMD_MAX + 1] = {
 };
 
 static int
-dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
+ip_set_dump_start(struct netlink_callback *cb)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(cb->skb);
 	int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 	struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 	struct nlattr *attr = (void *)nlh + min_len;
+	struct sk_buff *skb = cb->skb;
+	struct ip_set_net *inst = ip_set_pernet(sock_net(skb->sk));
 	u32 dump_type;
-	ip_set_id_t index;
 	int ret;
 
 	ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, attr,
 			nlh->nlmsg_len - min_len,
 			ip_set_dump_policy, NULL);
 	if (ret)
-		return ret;
+		goto error;
 
 	cb->args[IPSET_CB_PROTO] = nla_get_u8(cda[IPSET_ATTR_PROTOCOL]);
 	if (cda[IPSET_ATTR_SETNAME]) {
+		ip_set_id_t index;
 		struct ip_set *set;
 
 		set = find_set_and_id(inst, nla_data(cda[IPSET_ATTR_SETNAME]),
 				      &index);
-		if (!set)
-			return -ENOENT;
-
+		if (!set) {
+			ret = -ENOENT;
+			goto error;
+		}
 		dump_type = DUMP_ONE;
 		cb->args[IPSET_CB_INDEX] = index;
 	} else {
@@ -1523,10 +1526,17 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	cb->args[IPSET_CB_DUMP] = dump_type;
 
 	return 0;
+
+error:
+	/* We have to create and send the error message manually :-( */
+	if (nlh->nlmsg_flags & NLM_F_ACK) {
+		netlink_ack(cb->skb, nlh, ret, NULL);
+	}
+	return ret;
 }
 
 static int
-ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
+ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	ip_set_id_t index = IPSET_INVALID_ID, max;
 	struct ip_set *set = NULL;
@@ -1537,18 +1547,8 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 	bool is_destroyed;
 	int ret = 0;
 
-	if (!cb->args[IPSET_CB_DUMP]) {
-		ret = dump_init(cb, inst);
-		if (ret < 0) {
-			nlh = nlmsg_hdr(cb->skb);
-			/* We have to create and send the error message
-			 * manually :-(
-			 */
-			if (nlh->nlmsg_flags & NLM_F_ACK)
-				netlink_ack(cb->skb, nlh, ret, NULL);
-			return ret;
-		}
-	}
+	if (!cb->args[IPSET_CB_DUMP])
+		return -EINVAL;
 
 	if (cb->args[IPSET_CB_INDEX] >= inst->ip_set_max)
 		goto out;
@@ -1684,7 +1684,8 @@ static int ip_set_dump(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 	{
 		struct netlink_dump_control c = {
-			.dump = ip_set_dump_start,
+			.start = ip_set_dump_start,
+			.dump = ip_set_dump_do,
 			.done = ip_set_dump_done,
 		};
 		return netlink_dump_start(ctnl, skb, nlh, &c);
-- 
2.11.0

