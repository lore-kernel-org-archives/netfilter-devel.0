Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5A7C82E43
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC8D20775
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgD0XM2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 19:12:28 -0400
Received: from correo.us.es ([193.147.175.20]:44776 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgD0XM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 19:12:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 86FB7D2DA17
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78B4F615D2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6D857DA788; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 893FFBAAAF
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6CBED42EF9E1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 8/9] tests: py: remove range test with service names
Date:   Tue, 28 Apr 2020 01:12:16 +0200
Message-Id: <20200427231217.20274-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427231217.20274-1-pablo@netfilter.org>
References: <20200427231217.20274-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Service names printing are not default these days, using service names
with ranges is misleading.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/dccp.t | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index f0dd788b8b36..9a81bb2e60f3 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -12,7 +12,6 @@ dccp sport {23, 24, 25};ok
 dccp sport != {23, 24, 25};ok
 
 dccp sport { 20-50 };ok
-dccp sport ftp-data - re-mail-ck;ok;dccp sport 20-50
 dccp sport 20-50;ok
 dccp sport { 20-50};ok
 dccp sport != { 20-50};ok
-- 
2.20.1

