Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8CDC2D0A3
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1059206BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgJ2KO6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:58 -0400
Received: from correo.us.es ([193.147.175.20]:33400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgJ2KM7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 06:12:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F2F71EBAD4
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:12:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3A01DA858
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:12:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D8F03DA730; Thu, 29 Oct 2020 11:12:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E4BADA861
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:12:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 29 Oct 2020 11:12:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7D58D42EF42D
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 11:12:55 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack] conntrack: add flush filter command
Date:   Thu, 29 Oct 2020 11:12:52 +0100
Message-Id: <20201029101252.8681-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The NFCT_Q_FLUSH command flushes both IPv4 and IPv6 conntrack tables.
Add new command NFCT_Q_FLUSH_FILTER that allows to flush based on the
family to retain backward compatibility on NFCT_Q_FLUSH.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_conntrack/libnetfilter_conntrack.h | 1 +
 src/conntrack/api.c                                     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index c5c6b615a3bf..f02d827761a8 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -452,6 +452,7 @@ enum nf_conntrack_query {
 	NFCT_Q_CREATE_UPDATE,
 	NFCT_Q_DUMP_FILTER,
 	NFCT_Q_DUMP_FILTER_RESET,
+	NFCT_Q_FLUSH_FILTER,
 };
 
 extern int nfct_query(struct nfct_handle *h,
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 78d7d613d925..b7f64fb43ce8 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -831,6 +831,9 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_DELETE, NLM_F_ACK, *family,
 			      NFNETLINK_V0);
 		break;
+	case NFCT_Q_FLUSH_FILTER:
+		nfct_fill_hdr(req, IPCTNL_MSG_CT_DELETE, NLM_F_ACK, *family, 1);
+		break;
 	case NFCT_Q_DUMP:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET, NLM_F_DUMP, *family,
 			      NFNETLINK_V0);
-- 
2.20.1

