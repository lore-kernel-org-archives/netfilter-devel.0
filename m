Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BD8C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB4982071B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgGPRnM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 13:43:12 -0400
Received: from correo.us.es ([193.147.175.20]:39066 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgGPRnM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 13:43:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5B5A2DA70A
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D759DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 42FB6DA73F; Thu, 16 Jul 2020 19:43:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B6F8DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jul 2020 19:43:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0BD674265A2F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] tests: shell: chmod 755 testcases/chains/0030create_0
Date:   Thu, 16 Jul 2020 19:43:02 +0200
Message-Id: <20200716174305.4114-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update permissions in this test script.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/chains/0030create_0 | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tests/shell/testcases/chains/0030create_0

diff --git a/tests/shell/testcases/chains/0030create_0 b/tests/shell/testcases/chains/0030create_0
old mode 100644
new mode 100755
-- 
2.20.1

