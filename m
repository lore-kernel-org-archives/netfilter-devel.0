Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8BDC11D00
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 02:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05064206EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 02:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KMd8i4Q6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgBUCMN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 21:12:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729259AbgBUCMN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 21:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582251132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V7EddDL9NqWOkt5Pr0PfiCjDCd40Yi5dUfeWp5gYPAE=;
        b=KMd8i4Q6hRMH2jOaRKu5nFQY74WdPixaiQK2paQkfR2dV7cGocopmGE3ugdx8owlcdROf9
        XUBfq3Rk8lSjGUmGU3JjB8b45P3f9EX6r+XXxBkRmlMUZaOnqUHRMaVhYPxlWU95BQdQn8
        PJLEGeiR1YjAQIKeo3jvoyjiWoeCwTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-JChdJhd3PLeRjp02Dsqlzw-1; Thu, 20 Feb 2020 21:12:08 -0500
X-MC-Unique: JChdJhd3PLeRjp02Dsqlzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 917448017CC;
        Fri, 21 Feb 2020 02:12:07 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B6205C114;
        Fri, 21 Feb 2020 02:12:06 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Chen Yi <yiche@redhat.com>
Subject: [PATCH nf] selftests: nft_concat_range: Move option for 'list ruleset' before command
Date:   Fri, 21 Feb 2020 03:11:56 +0100
Message-Id: <4029c54d1524098df2cadcc3bae2c93de88f8fcd.1582251063.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before nftables commit fb9cea50e8b3 ("main: enforce options before
commands"), 'nft list ruleset -a' happened to work, but it's wrong
and won't work anymore. Replace it by 'nft -a list ruleset'.

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with=
 range concatenation")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testing/selftests/netfilter/nft_concat_range.sh  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tool=
s/testing/selftests/netfilter/nft_concat_range.sh
index dc810e32c59e..5a4938d6dcf2 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -1037,7 +1037,7 @@ format_noconcat() {
 add() {
 	if ! nft add element inet filter test "${1}"; then
 		err "Failed to add ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1057,7 +1057,7 @@ add_perf() {
 add_perf_norange() {
 	if ! nft add element netdev perf norange "${1}"; then
 		err "Failed to add ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1066,7 +1066,7 @@ add_perf_norange() {
 add_perf_noconcat() {
 	if ! nft add element netdev perf noconcat "${1}"; then
 		err "Failed to add ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1075,7 +1075,7 @@ add_perf_noconcat() {
 del() {
 	if ! nft delete element inet filter test "${1}"; then
 		err "Failed to delete ${1} given ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
@@ -1146,7 +1146,7 @@ send_match() {
 		err "  $(for f in ${src}; do
 			 eval format_\$f "${2}"; printf ' '; done)"
 		err "should have matched ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 	nft reset counter inet filter test >/dev/null
@@ -1172,7 +1172,7 @@ send_nomatch() {
 		err "  $(for f in ${src}; do
 			 eval format_\$f "${2}"; printf ' '; done)"
 		err "should not have matched ruleset:"
-		err "$(nft list ruleset -a)"
+		err "$(nft -a list ruleset)"
 		return 1
 	fi
 }
--=20
2.25.0

