Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75248C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 20:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B6EB23C18
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 20:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393043AbgLJU0D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:26:03 -0500
Received: from correo.us.es ([193.147.175.20]:40094 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392628AbgLJUZz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 15:25:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DBE5DA7EA
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 21:24:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 789D6DA704
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 21:24:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6D8C1DA8FD; Thu, 10 Dec 2020 21:24:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEC94DA704;
        Thu, 10 Dec 2020 21:24:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 10 Dec 2020 21:24:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9C5D14265A5A;
        Thu, 10 Dec 2020 21:24:55 +0100 (CET)
Date:   Thu, 10 Dec 2020 21:25:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/1] netfilter: ctnetlink: add timeout and
 protoinfo to destroy events
Message-ID: <20201210202505.GA1621@salvia>
References: <20201210134323.23808-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20201210134323.23808-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Florian,

On Thu, Dec 10, 2020 at 02:43:23PM +0100, Florian Westphal wrote:
> DESTROY events do not include the remaining timeout.
> 
> Unconditionally add the timeout so one can see if the entry timed
> out or was removed explicitly.
> 
> The latter case can happen when a conntrack gets deleted prematurely,
> e.g. due to a tcp reset, module removal, netdev notifier (nat/masquerade
> device went down), ctnetlink and so on.
> 
> Pablo suggested to also add the tcp (or other l4 tracker) information
> to help with debugging.

Probably a bit more fine grain, only the _STATE attribute.

See attached patch, it's an extension of yours.

--BOKacYhQ+x31HxR3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-ctnetlink-add-timeout-and-protoinfo-to-des.patch"

From fa0b0008d2681f6ca088e1dbb09dfb9898463951 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 10 Dec 2020 14:43:23 +0100
Subject: [PATCH] netfilter: ctnetlink: add timeout and protoinfo to destroy
 events

DESTROY events do not include the remaining timeout.

Unconditionally add the timeout so one can see if the entry timed
out or was removed explicitly.

The latter case can happen when a conntrack gets deleted prematurely,
e.g. due to a tcp reset, module removal, netdev notifier (nat/masquerade
device went down), ctnetlink and so on.

Pablo suggested to also add the tcp (or other l4 tracker) information
to help with debugging.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  2 +-
 net/netfilter/nf_conntrack_netlink.c         | 20 +++++++++++---------
 net/netfilter/nf_conntrack_proto_dccp.c      | 13 ++++++++++---
 net/netfilter/nf_conntrack_proto_sctp.c      | 13 +++++++++----
 net/netfilter/nf_conntrack_proto_tcp.c       | 10 ++++++++--
 5 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 9be7320b994f..96f9cf81f46b 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -32,7 +32,7 @@ struct nf_conntrack_l4proto {
 
 	/* convert protoinfo to nfnetink attributes */
 	int (*to_nlattr)(struct sk_buff *skb, struct nlattr *nla,
-			 struct nf_conn *ct);
+			 struct nf_conn *ct, bool destroy);
 
 	/* convert nfnetlink attributes to protoinfo */
 	int (*from_nlattr)(struct nlattr *tb[], struct nf_conn *ct);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3d0fd33be018..69a0098b44a9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -179,7 +179,8 @@ static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 
-static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
+static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct,
+				    bool destroy)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	struct nlattr *nest_proto;
@@ -193,7 +194,7 @@ static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
 	if (!nest_proto)
 		goto nla_put_failure;
 
-	ret = l4proto->to_nlattr(skb, nest_proto, ct);
+	ret = l4proto->to_nlattr(skb, nest_proto, ct, destroy);
 
 	nla_nest_end(skb, nest_proto);
 
@@ -538,7 +539,7 @@ static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 
 	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
 	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
-	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+	     ctnetlink_dump_protoinfo(skb, ct, false) < 0))
 		return -1;
 
 	return 0;
@@ -779,16 +780,17 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	if (ctnetlink_dump_status(skb, ct) < 0)
 		goto nla_put_failure;
 
+	if (ctnetlink_dump_timeout(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (events & (1 << IPCT_DESTROY)) {
 		if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
-		    ctnetlink_dump_timestamp(skb, ct) < 0)
+		    ctnetlink_dump_timestamp(skb, ct) < 0 ||
+		    ctnetlink_dump_protoinfo(skb, ct, true) < 0)
 			goto nla_put_failure;
 	} else {
-		if (ctnetlink_dump_timeout(skb, ct) < 0)
-			goto nla_put_failure;
-
 		if (events & (1 << IPCT_PROTOINFO)
-		    && ctnetlink_dump_protoinfo(skb, ct) < 0)
+		    && ctnetlink_dump_protoinfo(skb, ct, false) < 0)
 			goto nla_put_failure;
 
 		if ((events & (1 << IPCT_HELPER) || nfct_help(ct))
@@ -2723,7 +2725,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 	if (ctnetlink_dump_timeout(skb, ct) < 0)
 		goto nla_put_failure;
 
-	if (ctnetlink_dump_protoinfo(skb, ct) < 0)
+	if (ctnetlink_dump_protoinfo(skb, ct, false) < 0)
 		goto nla_put_failure;
 
 	if (ctnetlink_dump_helpinfo(skb, ct) < 0)
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b3f4a334f9d7..db7479db8512 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -589,7 +589,7 @@ static void dccp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
-			  struct nf_conn *ct)
+			  struct nf_conn *ct, bool destroy)
 {
 	struct nlattr *nest_parms;
 
@@ -597,15 +597,22 @@ static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_DCCP);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (nla_put_u8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state) ||
-	    nla_put_u8(skb, CTA_PROTOINFO_DCCP_ROLE,
+	if (nla_put_u8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state))
+		goto nla_put_failure;
+
+	if (destroy)
+		goto skip_state;
+
+	if (nla_put_u8(skb, CTA_PROTOINFO_DCCP_ROLE,
 		       ct->proto.dccp.role[IP_CT_DIR_ORIGINAL]) ||
 	    nla_put_be64(skb, CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
 			 cpu_to_be64(ct->proto.dccp.handshake_seq),
 			 CTA_PROTOINFO_DCCP_PAD))
 		goto nla_put_failure;
+skip_state:
 	nla_nest_end(skb, nest_parms);
 	spin_unlock_bh(&ct->lock);
+
 	return 0;
 
 nla_put_failure:
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 810cca24b399..fb8dc02e502f 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -543,7 +543,7 @@ static bool sctp_can_early_drop(const struct nf_conn *ct)
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
-			  struct nf_conn *ct)
+			  struct nf_conn *ct, bool destroy)
 {
 	struct nlattr *nest_parms;
 
@@ -552,15 +552,20 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, CTA_PROTOINFO_SCTP_STATE, ct->proto.sctp.state) ||
-	    nla_put_be32(skb, CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
+	if (nla_put_u8(skb, CTA_PROTOINFO_SCTP_STATE, ct->proto.sctp.state))
+		goto nla_put_failure;
+
+	if (destroy)
+		goto skip_state;
+
+	if (nla_put_be32(skb, CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
 			 ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL]) ||
 	    nla_put_be32(skb, CTA_PROTOINFO_SCTP_VTAG_REPLY,
 			 ct->proto.sctp.vtag[IP_CT_DIR_REPLY]))
 		goto nla_put_failure;
 
+skip_state:
 	spin_unlock_bh(&ct->lock);
-
 	nla_nest_end(skb, nest_parms);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 811c6c9b59e1..b168a7f7c704 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1186,7 +1186,7 @@ static bool tcp_can_early_drop(const struct nf_conn *ct)
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
-			 struct nf_conn *ct)
+			 struct nf_conn *ct, bool destroy)
 {
 	struct nlattr *nest_parms;
 	struct nf_ct_tcp_flags tmp = {};
@@ -1196,6 +1196,12 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (!nest_parms)
 		goto nla_put_failure;
 
+	if (nla_put_u8(skb, CTA_PROTOINFO_TCP_STATE, ct->proto.tcp.state))
+		goto nla_put_failure;
+
+	if (destroy)
+		goto skip_state;
+
 	if (nla_put_u8(skb, CTA_PROTOINFO_TCP_STATE, ct->proto.tcp.state) ||
 	    nla_put_u8(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
 		       ct->proto.tcp.seen[0].td_scale) ||
@@ -1212,8 +1218,8 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (nla_put(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY,
 		    sizeof(struct nf_ct_tcp_flags), &tmp))
 		goto nla_put_failure;
+skip_state:
 	spin_unlock_bh(&ct->lock);
-
 	nla_nest_end(skb, nest_parms);
 
 	return 0;
-- 
2.20.1


--BOKacYhQ+x31HxR3--
