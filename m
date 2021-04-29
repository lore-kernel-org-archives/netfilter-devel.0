Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A789BC433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 11:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FC3561445
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 11:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhD2LGy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 07:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhD2LGy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 07:06:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5CDC06138B
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Apr 2021 04:06:07 -0700 (PDT)
Received: from localhost ([::1]:36876 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lc4Ue-0007eD-TH; Thu, 29 Apr 2021 13:06:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: sctp: Explain match types in man page
Date:   Thu, 29 Apr 2021 13:05:58 +0200
Message-Id: <20210429110558.25487-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They weren't mentioned at all.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_sctp.man | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 3779d05a45bf0..3e5ffa09c9da7 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -8,6 +8,17 @@ This module matches Stream Control Transmission Protocol headers.
 The flag letter in upper case indicates that the flag is to match if set,
 in the lower case indicates to match if unset.
 
+Match types:
+.TP
+all
+Match if all given chunk types are present and flags match.
+.TP
+any
+Match if any of the given chunk types is present with given flags.
+.TP
+only
+Match if only the given chunk types are present with given flags and none are missing.
+
 Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK FORWARD_TSN
 
 chunk type            available flags      
-- 
2.31.0

