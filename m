Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFABC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 12:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbhLOMUo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 07:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242338AbhLOMUo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 07:20:44 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0963EC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 04:20:43 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mxTGy-0001hB-QQ; Wed, 15 Dec 2021 13:20:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Garver <eric@garver.life>,
        Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v2 2/2] netfilter: nat: force port remap to prevent shadowing well-known ports
Date:   Wed, 15 Dec 2021 13:20:26 +0100
Message-Id: <20211215122026.20850-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211215122026.20850-1-fw@strlen.de>
References: <20211215122026.20850-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If destination port is above 32k and source port below 16k
assume this might cause 'port shadowing' where a 'new' inbound
connection matches an existing one, e.g.

inbound X:41234 -> Y:53 matches existing conntrack entry
        Z:53 -> X:4123, where Z got natted to X.

In this case, new packet is natted to Z:53 which is likely
unwanted.

We avoid the rewrite for connections that originate from local host:
port-shadowing is only possible with forwarded connections.

Also adjust test case.

Cc: Eric Garver <eric@garver.life>
Cc: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: skip remap if local_out is set.

 net/netfilter/nf_nat_core.c                  | 43 ++++++++++++++++++--
 tools/testing/selftests/netfilter/nft_nat.sh |  5 ++-
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ab9f6c75524d..e890b3086417 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -494,6 +494,38 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	goto another_round;
 }
 
+static bool tuple_force_port_remap(const struct nf_conntrack_tuple *tuple)
+{
+	u16 sp, dp;
+
+	switch (tuple->dst.protonum) {
+	case IPPROTO_TCP:
+		sp = ntohs(tuple->src.u.tcp.port);
+		dp = ntohs(tuple->dst.u.tcp.port);
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		sp = ntohs(tuple->src.u.udp.port);
+		dp = ntohs(tuple->dst.u.udp.port);
+		break;
+	default:
+		return false;
+	}
+
+	/* IANA: System port range: 1-1023,
+	 *         user port range: 1024-49151,
+	 *      private port range: 49152-65535.
+	 *
+	 * Linux default ephemeral port range is 32768-60999.
+	 *
+	 * Enforce port remapping if sport is significantly lower
+	 * than dport to prevent NAT port shadowing, i.e.
+	 * accidental match of 'new' inbound connection vs.
+	 * existing outbound one.
+	 */
+	return sp < 16384 && dp >= 32768;
+}
+
 /* Manipulate the tuple into the range given. For NF_INET_POST_ROUTING,
  * we change the source to map into the range. For NF_INET_PRE_ROUTING
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
@@ -507,11 +539,17 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 struct nf_conn *ct,
 		 enum nf_nat_manip_type maniptype)
 {
+	bool random_port = range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL;
 	const struct nf_conntrack_zone *zone;
 	struct net *net = nf_ct_net(ct);
 
 	zone = nf_ct_zone(ct);
 
+	if (maniptype == NF_NAT_MANIP_SRC &&
+	    !ct->local_origin &&
+	    tuple_force_port_remap(orig_tuple))
+		random_port = true;
+
 	/* 1) If this srcip/proto/src-proto-part is currently mapped,
 	 * and that same mapping gives a unique tuple within the given
 	 * range, use that.
@@ -520,8 +558,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	 * So far, we don't do local source mappings, so multiple
 	 * manips not an issue.
 	 */
-	if (maniptype == NF_NAT_MANIP_SRC &&
-	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
+	if (maniptype == NF_NAT_MANIP_SRC && !random_port) {
 		/* try the original tuple first */
 		if (in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
@@ -545,7 +582,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	 */
 
 	/* Only bother mapping if it's not already in range and unique */
-	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
+	if (!random_port) {
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
 			    l4proto_in_range(tuple, maniptype,
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index d88867d2fed7..349a319a9e51 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -880,8 +880,9 @@ EOF
 		return $ksft_skip
 	fi
 
-	# test default behaviour. Packet from ns1 to ns0 is redirected to ns2.
-	test_port_shadow "default" "CLIENT"
+	# test default behaviour. Packet from ns1 to ns0 is not redirected
+	# due to automatic port translation.
+	test_port_shadow "default" "ROUTER"
 
 	# test packet filter based mitigation: prevent forwarding of
 	# packets claiming to come from the service port.
-- 
2.32.0

