Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3021FC352A1
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Dec 2022 14:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiLFOXm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Dec 2022 09:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiLFOXe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2022 09:23:34 -0500
X-Greylist: delayed 1134 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Dec 2022 06:23:29 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC69B65E4
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2022 06:23:29 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@osmocom.org>)
        id 1p2YYg-0089U4-IV; Tue, 06 Dec 2022 15:04:30 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.96)
        (envelope-from <laforge@osmocom.org>)
        id 1p2YY0-0055cj-18;
        Tue, 06 Dec 2022 15:03:48 +0100
From:   Harald Welte <laforge@osmocom.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Harald Welte <laforge@osmocom.org>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] doc/payload-expression.txt: Mention that 'ih' exists
Date:   Tue,  6 Dec 2022 15:03:33 +0100
Message-Id: <20221206140333.1213221-1-laforge@osmocom.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Back in commit b67abc51ba6f78be79f344dfda9c6d0753d79aea a new
payload expression 'ih' was added, but the documentation wasn't updated
accordingly.

Let's at least mention in the man page that it exists at all.

Signed-off-by: Harald Welte <laforge@gnumonks.org>
---
 doc/payload-expression.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 113f5bfc..9a761b71 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -556,6 +556,8 @@ Link layer, for example the Ethernet header
 Network header, for example IPv4 or IPv6
 |th|
 Transport Header, for example TCP
+|ih|
+Inner Header / Payload, i.e. after the L4 transport level header
 |==============================
 
 .Matching destination port of both UDP and TCP
-- 
2.38.1

