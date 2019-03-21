Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780CFC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A662083D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfCUL3C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:29:02 -0400
Received: from mail.us.es ([193.147.175.20]:42782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbfCUL3B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 07:29:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0E6AC230E
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:28:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86F94BAAB2
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:28:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 85C71BAAB1; Thu, 21 Mar 2019 12:28:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FB7DBAAAA;
        Thu, 21 Mar 2019 12:28:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Mar 2019 12:28:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [195.39.71.253])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0CE164265A4E;
        Thu, 21 Mar 2019 12:28:56 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 8/9] netfilter: nf_flowtable: remove duplicated transition in diagram
Date:   Thu, 21 Mar 2019 12:28:44 +0100
Message-Id: <20190321112845.10627-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190321112845.10627-1-pablo@netfilter.org>
References: <20190321112845.10627-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No direct transition from prerouting to forward hook, routing lookup
needs to happen first.

Fixes: 19b351f16fd9 ("netfilter: add flowtable documentation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_flowtable.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/nf_flowtable.txt b/Documentation/networking/nf_flowtable.txt
index 54128c50d508..ca2136c76042 100644
--- a/Documentation/networking/nf_flowtable.txt
+++ b/Documentation/networking/nf_flowtable.txt
@@ -44,10 +44,10 @@ including the Netfilter hooks and the flowtable fastpath bypass.
      /         \    /          \     |Routing |   /            \
   -->  ingress  ---> prerouting ---> |decision|   | postrouting |--> neigh_xmit
      \_________/    \__________/     ----------   \____________/          ^
-       |      ^          |               |               ^                |
-   flowtable  |          |          ____\/___            |                |
-       |      |          |         /         \           |                |
-    __\/___   |          --------->| forward |------------                |
+       |      ^                          |               ^                |
+   flowtable  |                     ____\/___            |                |
+       |      |                    /         \           |                |
+    __\/___   |                    | forward |------------                |
     |-----|   |                    \_________/                            |
     |-----|   |                 'flow offload' rule                       |
     |-----|   |                   adds entry to                           |
-- 
2.11.0

