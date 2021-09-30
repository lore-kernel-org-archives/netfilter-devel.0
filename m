Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AC4C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8A60619F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351734AbhI3OH0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351633AbhI3OHZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:07:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F66C06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:05:43 -0700 (PDT)
Received: from localhost ([::1]:51738 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwgv-0007SZ-M7; Thu, 30 Sep 2021 16:05:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 13/17] xtables: arptables doesn't warn about empty interface
Date:   Thu, 30 Sep 2021 16:04:15 +0200
Message-Id: <20210930140419.6170-14-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The empty string passed as interface name is simply ignored. Calling
xtables_parse_interface() with an empty string is safe.

Note that arptables-legacy seems not to ignore inverted empty
interfacess, they appear in '-L' output as such:

| -j ACCEPT -i * ! -o * , pcnt=0 -- bcnt=0

Yet they don't appear in arptables-save output. Given that inverted "any
interface" will never match, there's probably no point in sticking to
this inconsistency.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 23d7d29169ca0..5b5c875dc3a6c 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -533,7 +533,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'i':
-			if (*optarg == '\0')
+			if (*optarg == '\0' && h->family != NFPROTO_ARP)
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
@@ -545,7 +545,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'o':
-			if (*optarg == '\0')
+			if (*optarg == '\0' && h->family != NFPROTO_ARP)
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-- 
2.33.0

