Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9632C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 13:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B55BA2073B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 13:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfLDNJc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 08:09:32 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58444 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfLDNJc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 08:09:32 -0500
Received: from localhost ([::1]:43302 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1icUPK-0007nQ-8n; Wed, 04 Dec 2019 14:09:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: CLUSTERIP: Mark as deprecated in man page
Date:   Wed,  4 Dec 2019 14:09:21 +0100
Message-Id: <20191204130921.2914-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel even warns if being used, reflect its state in man page, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_CLUSTERIP.man | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/extensions/libipt_CLUSTERIP.man b/extensions/libipt_CLUSTERIP.man
index 8ec6d6b6e163d..768bb23e5a7ac 100644
--- a/extensions/libipt_CLUSTERIP.man
+++ b/extensions/libipt_CLUSTERIP.man
@@ -2,6 +2,9 @@ This module allows you to configure a simple cluster of nodes that share
 a certain IP and MAC address without an explicit load balancer in front of
 them.  Connections are statically distributed between the nodes in this
 cluster.
+.PP
+Please note that CLUSTERIP target is considered deprecated in favour of cluster
+match which is more flexible and not limited to IPv4.
 .TP
 \fB\-\-new\fP
 Create a new ClusterIP.  You always have to set this on the first rule
-- 
2.24.0

