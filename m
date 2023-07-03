Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296F6C0015E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 11:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjGCLni (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 07:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjGCLnh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 07:43:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5F8E5A
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jul 2023 04:43:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qGHxm-0007sG-Dh; Mon, 03 Jul 2023 13:43:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     faicker.mo@ucloud.cn, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: gre: don't set assured flag for clash entries
Date:   Mon,  3 Jul 2023 13:43:18 +0200
Message-Id: <20230703114318.20997-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that conntrack core is allowd to insert clashing entries, make sure
GRE won't set assured flag on NAT_CLASH entries, just like UDP.

Doing so prevents early_drop logic for these entries.

Fixes: d671fd82eaa9 ("netfilter: conntrack: allow insertion clash of gre protocol")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
Not a big deal, Fixes tag added for tracking purposes.

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
2.39.3

