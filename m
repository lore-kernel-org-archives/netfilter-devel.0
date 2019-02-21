Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FDDC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 19:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FD562081B
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 19:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfBUTJ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:09:27 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:60382 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfBUTJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 14:09:26 -0500
Received: from localhost ([::1]:45240 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gwtin-0007oM-2u; Thu, 21 Feb 2019 20:09:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] extensions: Fix ipvs vproto option printing
Date:   Thu, 21 Feb 2019 20:09:31 +0100
Message-Id: <20190221190932.16281-2-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221190932.16281-1-phil@nwl.cc>
References: <20190221190932.16281-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This was broken since day 1: vproto option was printed as 'proto' which
in turn iptables wouldn't accept anymore.

Fixes: c36d05e424069 ("libxt_ipvs: user-space lib for netfilter matcher xt_ipvs")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_ipvs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
index fe98fef951686..51952be4245b3 100644
--- a/extensions/libxt_ipvs.c
+++ b/extensions/libxt_ipvs.c
@@ -165,7 +165,7 @@ static void ipvs_mt_dump(const void *ip, const struct xt_ipvs_mtinfo *data,
 	if (data->bitmask & XT_IPVS_PROTO) {
 		if (data->invert & XT_IPVS_PROTO)
 			printf(" !");
-		printf(" %sproto %u", prefix, data->l4proto);
+		printf(" %svproto %u", prefix, data->l4proto);
 	}
 
 	if (data->bitmask & XT_IPVS_VADDR) {
-- 
2.20.1

