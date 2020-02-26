Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AD4C4BA2D
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 22:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B59462072D
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 22:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgBZWzM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:55:12 -0500
Received: from correo.us.es ([193.147.175.20]:36428 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgBZWzB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 17:55:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C36991C438F
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 23:54:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B64F4DA3A0
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 23:54:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AA7E7DA38F; Wed, 26 Feb 2020 23:54:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C65CFDA3C2;
        Wed, 26 Feb 2020 23:54:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 23:54:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9EAB142EF4E0;
        Wed, 26 Feb 2020 23:54:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/6] selftests: nft_concat_range: Move option for 'list ruleset' before command
Date:   Wed, 26 Feb 2020 23:54:39 +0100
Message-Id: <20200226225442.9598-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200226225442.9598-1-pablo@netfilter.org>
References: <20200226225442.9598-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Before nftables commit fb9cea50e8b3 ("main: enforce options before
commands"), 'nft list ruleset -a' happened to work, but it's wrong
and won't work anymore. Replace it by 'nft -a list ruleset'.

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_concat_range.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index aca21dde102a..5c1033ee1b39 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -1025,7 +1025,7 @@ format_noconcat() {
 add() {
 	if ! nft add element inet filter test "${1}"; then
 		err "Failed to add ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1045,7 +1045,7 @@ add_perf() {
 add_perf_norange() {
 	if ! nft add element netdev perf norange "${1}"; then
 		err "Failed to add ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1054,7 +1054,7 @@ add_perf_norange() {
 add_perf_noconcat() {
 	if ! nft add element netdev perf noconcat "${1}"; then
 		err "Failed to add ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1063,7 +1063,7 @@ add_perf_noconcat() {
 del() {
 	if ! nft delete element inet filter test "${1}"; then
 		err "Failed to delete ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1134,7 +1134,7 @@ send_match() {
 		err "  $(for f in ${src}; do
 			 eval format_\$f "${2}"; printf ' '; done)"
 		err "should have matched ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 	nft reset counter inet filter test >/dev/null
@@ -1160,7 +1160,7 @@ send_nomatch() {
 		err "  $(for f in ${src}; do
 			 eval format_\$f "${2}"; printf ' '; done)"
 		err "should not have matched ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
-- 
2.11.0

