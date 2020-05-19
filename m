Return-Path: <SRS0=LRg4=7B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6529AC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 23:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD1020823
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 23:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgESXIe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 May 2020 19:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgESXId (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 May 2020 19:08:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2095C08C5C3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2020 16:08:33 -0700 (PDT)
Received: from localhost ([::1]:34546 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jbBLb-00081U-HW; Wed, 20 May 2020 01:08:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] doc: libxt_MARK: OUTPUT chain is fine, too
Date:   Wed, 20 May 2020 01:08:22 +0200
Message-Id: <20200519230822.15290-1-phil@nwl.cc>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to route packets originating from the host itself based on
fwmark, mangle table's OUTPUT chain must be used. Mention this chain as
alternative to PREROUTING.

Fixes: c9be7f153f7bf ("doc: libxt_MARK: no longer restricted to mangle table")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_MARK.man | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_MARK.man b/extensions/libxt_MARK.man
index 712fb76f7340c..b2408597e98f1 100644
--- a/extensions/libxt_MARK.man
+++ b/extensions/libxt_MARK.man
@@ -1,7 +1,7 @@
 This target is used to set the Netfilter mark value associated with the packet.
 It can, for example, be used in conjunction with routing based on fwmark (needs
-iproute2). If you plan on doing so, note that the mark needs to be set in the
-PREROUTING chain of the mangle table to affect routing.
+iproute2). If you plan on doing so, note that the mark needs to be set in
+either the PREROUTING or the OUTPUT chain of the mangle table to affect routing.
 The mark field is 32 bits wide.
 .TP
 \fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
-- 
2.26.2

