Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DA2C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 09:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6640B2070B
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 09:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgEFJqr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 05:46:47 -0400
Received: from smail.fem.tu-ilmenau.de ([141.24.220.41]:55480 "EHLO
        smail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgEFJqq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 05:46:46 -0400
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id 06F8E200DA;
        Wed,  6 May 2020 11:46:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id B1EB76219;
        Wed,  6 May 2020 11:46:42 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yvbV2uG5YD2W; Wed,  6 May 2020 11:46:42 +0200 (CEST)
Received: from mail-backup.fem.tu-ilmenau.de (mail-backup.net.fem.tu-ilmenau.de [10.42.40.22])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTPS;
        Wed,  6 May 2020 11:46:42 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail-backup.fem.tu-ilmenau.de (Postfix) with ESMTP id EAC4A56052;
        Wed,  6 May 2020 11:46:41 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id D36E8306A950; Wed,  6 May 2020 11:46:41 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH 1/3] nftables: add frag-needed (ipv4) to reject options
Date:   Wed,  6 May 2020 11:46:23 +0200
Message-Id: <3248042ddaddd431d5306bc3e1cc40b7954c667f.1588758255.git.michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1588758255.git.michael-dev@fami-braun.de>
References: <cover.1588758255.git.michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This enables to send icmp frag-needed messages using reject target.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 doc/data-types.txt | 2 ++
 src/datatype.c     | 1 +
 2 files changed, 3 insertions(+)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 90e19a8b..a42a55fa 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -254,6 +254,8 @@ The ICMP Code type is used to conveniently specify the ICMP header's code field.
 2
 |port-unreachable|
 3
+|frag-needed|
+4
 |net-prohibited|
 9
 |host-prohibited|
diff --git a/src/datatype.c b/src/datatype.c
index b305bf60..7d652ff2 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -825,6 +825,7 @@ static const struct symbol_table icmp_code_tbl = {
 		SYMBOL("net-prohibited",	ICMP_NET_ANO),
 		SYMBOL("host-prohibited",	ICMP_HOST_ANO),
 		SYMBOL("admin-prohibited",	ICMP_PKT_FILTERED),
+		SYMBOL("frag-needed",		ICMP_FRAG_NEEDED),
 		SYMBOL_LIST_END
 	},
 };
-- 
2.20.1

