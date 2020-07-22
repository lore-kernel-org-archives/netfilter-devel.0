Return-Path: <SRS0=uHYT=BB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8382BC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 11:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A1CA20849
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 11:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGVLM0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 07:12:26 -0400
Received: from correo.us.es ([193.147.175.20]:53176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgGVLMZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 07:12:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D7696E8622
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2020 13:12:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C714EDA801
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2020 13:12:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BBFC7DA7B6; Wed, 22 Jul 2020 13:12:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7FAF9DA789
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2020 13:12:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 Jul 2020 13:12:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 61E014265A32
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2020 13:12:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] extensions: libxt_conntrack: provide translation for DNAT and SNAT --ctstate
Date:   Wed, 22 Jul 2020 13:12:14 +0200
Message-Id: <20200722111214.21896-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables-translate -t filter -A INPUT -m conntrack --ctstate DNAT -j ACCEPT
nft add rule ip filter INPUT ct status dnat counter accept

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_conntrack.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 6f3503933e66..7734509c9af8 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1249,11 +1249,19 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_STATE) {
-		xt_xlate_add(xl, "%sct state %s", space,
-			     sinfo->invert_flags & XT_CONNTRACK_STATE ?
-			     "!= " : "");
-		state_xlate_print(xl, sinfo->state_mask);
-		space = " ";
+		if ((sinfo->state_mask & XT_CONNTRACK_STATE_SNAT) ||
+		    (sinfo->state_mask & XT_CONNTRACK_STATE_DNAT)) {
+			xt_xlate_add(xl, "%sct status %s%s", space,
+				     sinfo->invert_flags & XT_CONNTRACK_STATUS ? "!=" : "",
+				     sinfo->state_mask & XT_CONNTRACK_STATE_SNAT ? "snat" : "dnat");
+			space = " ";
+		} else {
+			xt_xlate_add(xl, "%sct state %s", space,
+				     sinfo->invert_flags & XT_CONNTRACK_STATE ?
+				     "!= " : "");
+			state_xlate_print(xl, sinfo->state_mask);
+			space = " ";
+		}
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_STATUS) {
-- 
2.20.1

