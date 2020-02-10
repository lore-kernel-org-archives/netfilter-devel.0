Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD41DC352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 11:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CF582080C
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 11:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBJLO1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 06:14:27 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58798 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgBJLO1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 06:14:27 -0500
Received: from localhost ([::1]:43656 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j171E-00037r-V0; Mon, 10 Feb 2020 12:14:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 2/2] scanner: Extend asteriskstring definition
Date:   Mon, 10 Feb 2020 12:14:23 +0100
Message-Id: <20200210111423.18122-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200210111423.18122-1-phil@nwl.cc>
References: <20200210111423.18122-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept escaped asterisks also mid-string and as only character.
Especially the latter will help when translating from iptables where
asterisk has no special meaning.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Still reject unescaped asterisks mid-string.
---
 src/scanner.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 99ee83559d2eb..20a59de51d1ff 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -120,7 +120,7 @@ numberstring	({decstring}|{hexstring})
 letter		[a-zA-Z]
 string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
-asteriskstring	({string}\*|{string}\\\*)
+asteriskstring	({string}\*|{string}\\\*|\\\*|{string}\\\*{string})
 comment		#.*$
 slash		\/
 
-- 
2.24.1

