Return-Path: <SRS0=+PCd=EI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EA7C55178
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Nov 2020 13:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA1CD208B6
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Nov 2020 13:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgKBNvr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Nov 2020 08:51:47 -0500
Received: from correo.us.es ([193.147.175.20]:56060 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKBNtq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Nov 2020 08:49:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37E60B60C0
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2020 14:49:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28EC8DA72F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2020 14:49:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1E7CCDA78F; Mon,  2 Nov 2020 14:49:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EABCCDA722
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2020 14:49:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Nov 2020 14:49:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id D664E41FF208
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2020 14:49:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack] conntrack: do not allow to update offload status bits
Date:   Mon,  2 Nov 2020 14:49:38 +0100
Message-Id: <20201102134938.15452-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libnetfilter_conntrack already prints these new offload status bits,
which is sufficient. Revert the status parser changes that allow to set
on these bits from ctnetlink since this is not supported.

Fixes: de12e29bf35b ("conntrack: support for IPS_OFFLOAD")
Fixes: 2317c0de6080 ("conntrack: add support for the IPS_HW_OFFLOAD flag")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index af54240dfa23..cf260423377f 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1119,8 +1119,8 @@ static struct parse_parameter {
 	size_t  size;
 	unsigned int value[8];
 } parse_array[PARSE_MAX] = {
-	{ {"ASSURED", "SEEN_REPLY", "UNSET", "FIXED_TIMEOUT", "EXPECTED", "OFFLOAD", "HW_OFFLOAD"}, 7,
-	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED, IPS_OFFLOAD, IPS_HW_OFFLOAD} },
+	{ {"ASSURED", "SEEN_REPLY", "UNSET", "FIXED_TIMEOUT", "EXPECTED"}, 5,
+	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED } },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
 	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
 	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace", "save"}, 8,
-- 
2.20.1

