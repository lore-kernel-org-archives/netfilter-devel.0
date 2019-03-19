Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1352C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 14:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99D462075E
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 14:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfCSODl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 10:03:41 -0400
Received: from mail.us.es ([193.147.175.20]:55926 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfCSODl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 10:03:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D122C210561
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 15:03:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF2A1FC5E3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 15:03:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AB427FC5F2; Tue, 19 Mar 2019 15:03:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAD3FFC5E3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 15:03:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Mar 2019 15:03:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [195.39.71.253])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 73A164265A4E
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 15:03:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_flowtable: remove duplicated transition in diagram
Date:   Tue, 19 Mar 2019 15:03:31 +0100
Message-Id: <20190319140331.31977-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
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

