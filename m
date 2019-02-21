Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC14DC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 19:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88E782083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 19:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfBUTJi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:09:38 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:60392 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfBUTJh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 14:09:37 -0500
Received: from localhost ([::1]:45250 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gwtix-0007oe-Om; Thu, 21 Feb 2019 20:09:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] extensions: Fix ipvs vproto parsing
Date:   Thu, 21 Feb 2019 20:09:30 +0100
Message-Id: <20190221190932.16281-1-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This was broken by integration into guided option parser:

* Make 'vproto' option XTTYPE_PROTOCOL, otherwise its arguments are
  parsed as garbage only.

* Drop O_VPROTO case from ipvs_mt_parse(), due to XTOPT_POINTER() and
  above change there is nothing to do for it in there.

Fixes: 372203af4c70f ("libxt_ipvs: use guided option parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_ipvs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
index a6c57a030d2c6..fe98fef951686 100644
--- a/extensions/libxt_ipvs.c
+++ b/extensions/libxt_ipvs.c
@@ -27,7 +27,7 @@ enum {
 static const struct xt_option_entry ipvs_mt_opts[] = {
 	{.name = "ipvs", .id = O_IPVS, .type = XTTYPE_NONE,
 	 .flags = XTOPT_INVERT},
-	{.name = "vproto", .id = O_VPROTO, .type = XTTYPE_STRING,
+	{.name = "vproto", .id = O_VPROTO, .type = XTTYPE_PROTOCOL,
 	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, l4proto)},
 	{.name = "vaddr", .id = O_VADDR, .type = XTTYPE_HOSTMASK,
 	 .flags = XTOPT_INVERT},
@@ -69,9 +69,6 @@ static void ipvs_mt_parse(struct xt_option_call *cb)
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
-	case O_VPROTO:
-		data->l4proto = cb->val.protocol;
-		break;
 	case O_VADDR:
 		memcpy(&data->vaddr, &cb->val.haddr, sizeof(cb->val.haddr));
 		memcpy(&data->vmask, &cb->val.hmask, sizeof(cb->val.hmask));
-- 
2.20.1

