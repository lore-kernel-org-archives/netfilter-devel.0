Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9B1C82E44
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38E32072D
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgD0XM3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 19:12:29 -0400
Received: from correo.us.es ([193.147.175.20]:44780 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgD0XM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 19:12:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DAB6D2DA26
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B846BAC2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 81308615D2; Tue, 28 Apr 2020 01:12:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96A76DA7B2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 01:12:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 841E742EF9E1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:24 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 6/9] tests: py: concatenation, netmap and nat mappings
Date:   Tue, 28 Apr 2020 01:12:14 +0200
Message-Id: <20200427231217.20274-7-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/snat.t         |  4 ++++
 tests/py/ip/snat.t.payload | 27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index 7281bf5fa7e0..c6e8a8e68f9d 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -8,3 +8,7 @@ iifname "eth0" tcp dport {80, 90, 23} snat to 192.168.3.2;ok
 iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2;ok
 
 iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
+
+snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };ok
+snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 };ok
+snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 };ok
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 789933ffd650..22befe155dde 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -60,3 +60,30 @@ ip test-ip4 postrouting
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
+# snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
+__map%d test-ip4 b size 1
+__map%d test-ip4 0
+	element 040b8d0a  : 0302a8c0 00005000 0 [end]
+ip 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 0 proto_min reg 9 proto_max reg 0 ]
+
+# snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
+__map%d test-ip4 b size 1
+__map%d test-ip4 0
+	element 040b8d0a  : 0202a8c0 0402a8c0 0 [end]
+ip 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 9 ]
+
+# snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
+__map%d test-ip4 f size 3
+__map%d test-ip4 0
+	element 00000000  : 1 [end]	element 000b8d0a  : 0002a8c0 ff02a8c0 0 [end]	element 000c8d0a  : 1 [end]
+ip 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 9 flags 0x40 ]
+
-- 
2.20.1

