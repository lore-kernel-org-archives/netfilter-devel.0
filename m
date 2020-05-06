Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699C9C47256
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5192F208E4
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgEFRea (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRea (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3170C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:29 -0700 (PDT)
Received: from localhost ([::1]:58744 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNwC-0002m9-84; Wed, 06 May 2020 19:34:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 13/15] arptables: Fix leak in nft_arp_print_rule()
Date:   Wed,  6 May 2020 19:33:29 +0200
Message-Id: <20200506173331.9347-14-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function missed to clear struct iptables_command_state again after
use.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index e9a2d9de21560..9a831efd07a28 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -604,6 +604,8 @@ nft_arp_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
+
+	nft_clear_iptables_command_state(&cs);
 }
 
 static bool nft_arp_is_same(const void *data_a,
-- 
2.25.1

