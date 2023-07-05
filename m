Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C9DEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 23:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjGEXES (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 19:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjGEXER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 19:04:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDA7B102;
        Wed,  5 Jul 2023 16:04:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/6] netfilter: conntrack: gre: don't set assured flag for clash entries
Date:   Thu,  6 Jul 2023 01:04:02 +0200
Message-Id: <20230705230406.52201-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230705230406.52201-1-pablo@netfilter.org>
References: <20230705230406.52201-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Now that conntrack core is allowd to insert clashing entries, make sure
GRE won't set assured flag on NAT_CLASH entries, just like UDP.

Doing so prevents early_drop logic for these entries.

Fixes: d671fd82eaa9 ("netfilter: conntrack: allow insertion clash of gre protocol")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_gre.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index ad6f0ca40cd2..af369e686fc5 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -205,6 +205,8 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state)
 {
+	unsigned long status;
+
 	if (!nf_ct_is_confirmed(ct)) {
 		unsigned int *timeouts = nf_ct_timeout_lookup(ct);
 
@@ -217,11 +219,17 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 		ct->proto.gre.timeout = timeouts[GRE_CT_UNREPLIED];
 	}
 
+	status = READ_ONCE(ct->status);
 	/* If we've seen traffic both ways, this is a GRE connection.
 	 * Extend timeout. */
-	if (ct->status & IPS_SEEN_REPLY) {
+	if (status & IPS_SEEN_REPLY) {
 		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   ct->proto.gre.stream_timeout);
+
+		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
+		if (unlikely((status & IPS_NAT_CLASH)))
+			return NF_ACCEPT;
+
 		/* Also, more likely to be important, and not a probe. */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
-- 
2.30.2

