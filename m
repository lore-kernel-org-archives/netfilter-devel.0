Return-Path: <SRS0=HMuw=IE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83248C432C3
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D2264FE8
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhCFMMw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 07:12:52 -0500
Received: from correo.us.es ([193.147.175.20]:46332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230410AbhCFMMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1544DC5174
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3CF5DA78F
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E92B5DA78E; Sat,  6 Mar 2021 13:12:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54693DA72F;
        Sat,  6 Mar 2021 13:12:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 29AC242DC6E2;
        Sat,  6 Mar 2021 13:12:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/9] netfilter: nf_nat: undo erroneous tcp edemux lookup
Date:   Sat,  6 Mar 2021 13:12:17 +0100
Message-Id: <20210306121223.28711-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Under extremely rare conditions TCP early demux will retrieve the wrong
socket.

1. local machine establishes a connection to a remote server, S, on port
   p.

   This gives:
   laddr:lport -> S:p
   ... both in tcp and conntrack.

2. local machine establishes a connection to host H, on port p2.
   2a. TCP stack choses same laddr:lport, so we have
   laddr:lport -> H:p2 from TCP point of view.
   2b). There is a destination NAT rewrite in place, translating
        H:p2 to S:p.  This results in following conntrack entries:

   I)  laddr:lport -> S:p  (origin)  S:p -> laddr:lport (reply)
   II) laddr:lport -> H:p2 (origin)  S:p -> laddr:lport2 (reply)

   NAT engine has rewritten laddr:lport to laddr:lport2 to map
   the reply packet to the correct origin.

   When server sends SYN/ACK to laddr:lport2, the PREROUTING hook
   will undo-the SNAT transformation, rewriting IP header to
   S:p -> laddr:lport

   This causes TCP early demux to associate the skb with the TCP socket
   of the first connection.

   The INPUT hook will then reverse the DNAT transformation, rewriting
   the IP header to H:p2 -> laddr:lport.

Because packet ends up with the wrong socket, the new connection
never completes: originator stays in SYN_SENT and conntrack entry
remains in SYN_RECV until timeout, and responder retransmits SYN/ACK
until it gives up.

To resolve this, orphan the skb after the input rewrite:
Because the source IP address changed, the socket must be incorrect.
We can't move the DNAT undo to prerouting due to backwards
compatibility, doing so will make iptables/nftables rules to no longer
match the way they did.

After orphan, the packet will be handed to the next protocol layer
(tcp, udp, ...) and that will repeat the socket lookup just like as if
early demux was disabled.

Fixes: 41063e9dd1195 ("ipv4: Early TCP socket demux.")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1427
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index e87b6bd6b3cd..4731d21fc3ad 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -646,8 +646,8 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
+nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
+			const struct nf_hook_state *state)
 {
 	unsigned int ret;
 	__be32 daddr = ip_hdr(skb)->daddr;
@@ -659,6 +659,23 @@ nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
+static unsigned int
+nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
+{
+	__be32 saddr = ip_hdr(skb)->saddr;
+	struct sock *sk = skb->sk;
+	unsigned int ret;
+
+	ret = nf_nat_ipv4_fn(priv, skb, state);
+
+	if (ret == NF_ACCEPT && sk && saddr != ip_hdr(skb)->saddr &&
+	    !inet_sk_transparent(sk))
+		skb_orphan(skb); /* TCP edemux obtained wrong socket */
+
+	return ret;
+}
+
 static unsigned int
 nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 		const struct nf_hook_state *state)
@@ -736,7 +753,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	/* Before packet filtering, change destination */
 	{
-		.hook		= nf_nat_ipv4_in,
+		.hook		= nf_nat_ipv4_pre_routing,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
@@ -757,7 +774,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	},
 	/* After packet filtering, change source */
 	{
-		.hook		= nf_nat_ipv4_fn,
+		.hook		= nf_nat_ipv4_local_in,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,
-- 
2.20.1

