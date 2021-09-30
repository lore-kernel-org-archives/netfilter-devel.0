Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA68C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8C7619E7
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhI3OGY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351706AbhI3OGX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:06:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A085C06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:04:41 -0700 (PDT)
Received: from localhost ([::1]:51664 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwfv-0007OU-Gs; Thu, 30 Sep 2021 16:04:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 15/17] xtables: arptables ignores wrong -t values
Date:   Thu, 30 Sep 2021 16:04:17 +0200
Message-Id: <20210930140419.6170-16-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Legacy arptables allows arbitrary values passed after '-t' and just uses
table 'filter' instead. Mimick this behaviour by just ignoring the
parameter after invert flag checking (which legacy arptables indeed
does).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index b8c4e2737a96a..c77d76c89a543 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -589,6 +589,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
+			if (h->family == NFPROTO_ARP)
+				break;
 			if (p->restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
 					      "The -t option (seen in line %u) cannot be used in %s.\n",
-- 
2.33.0

