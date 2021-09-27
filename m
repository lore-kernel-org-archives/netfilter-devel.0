Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CC2C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F3A160FF2
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhI0PFx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbhI0PFs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 11:05:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD23C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 08:04:10 -0700 (PDT)
Received: from localhost ([::1]:43538 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mUsAr-0005hl-Ch; Mon, 27 Sep 2021 17:04:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/12] nft-shared: Make nft_check_xt_legacy() family agnostic
Date:   Mon, 27 Sep 2021 17:03:14 +0200
Message-Id: <20210927150316.11516-11-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927150316.11516-1-phil@nwl.cc>
References: <20210927150316.11516-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Of course there is no such thing as *_tables_names for ebtables, so no
legacy tables checking for ebtables-nft.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 4253b08196d29..72727270026ee 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -992,6 +992,7 @@ void nft_check_xt_legacy(int family, bool is_ipt_save)
 {
 	static const char tables6[] = "/proc/net/ip6_tables_names";
 	static const char tables4[] = "/proc/net/ip_tables_names";
+	static const char tablesa[] = "/proc/net/arp_tables_names";
 	const char *prefix = "ip";
 	FILE *fp = NULL;
 	char buf[1024];
@@ -1004,6 +1005,10 @@ void nft_check_xt_legacy(int family, bool is_ipt_save)
 		fp = fopen(tables6, "r");
 		prefix = "ip6";
 		break;
+	case NFPROTO_ARP:
+		fp = fopen(tablesa, "r");
+		prefix = "arp";
+		break;
 	default:
 		break;
 	}
-- 
2.33.0

