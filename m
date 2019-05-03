Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4CFC43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 16:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA0682075C
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 16:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfECQpa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 12:45:30 -0400
Received: from mail.us.es ([193.147.175.20]:41024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbfECQpa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 12:45:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19D0EE3A07
        for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2019 18:45:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B936DA706
        for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2019 18:45:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 01312DA701; Fri,  3 May 2019 18:45:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0D63DA701;
        Fri,  3 May 2019 18:45:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 May 2019 18:45:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BEBEA4265A31;
        Fri,  3 May 2019 18:45:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kristian.evensen@gmail.com
Subject: [PATCH libnetfilter_conntrack] conntrack: api: use libmnl API to build the netlink headers
Date:   Fri,  3 May 2019 18:45:22 +0200
Message-Id: <20190503164522.28225-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace libnfnetlink's nfnl_fill_hdr() by more modern libmnl code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Kristian: Before you keep looking at this code, git pull to refresh your
           libnetfilter_conntrack clone. This is leaving you room to bump
	   the version number.

 src/conntrack/api.c | 33 ++++++++++++++++++++++++++++-----
 src/expect/api.c    | 25 +++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 3a1746e4c050..ffa5216ce8de 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -782,6 +782,24 @@ int nfct_build_conntrack(struct nfnl_subsys_handle *ssh,
 	return __build_conntrack(ssh, req, size, type, flags, ct);
 }
 
+static void nfct_fill_hdr(struct nfnlhdr *req, uint16_t type, uint16_t flags,
+			  uint8_t l3num, uint8_t version)
+{
+	char *buf = (char *)&req->nlh;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | type;
+	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
+	nlh->nlmsg_seq = 0;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = l3num;
+	nfh->version = version;
+	nfh->res_id = 0;
+}
+
 static int
 __build_query_ct(struct nfnl_subsys_handle *ssh,
 		 const enum nf_conntrack_query qt,
@@ -810,23 +828,28 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 		__build_conntrack(ssh, req, size, IPCTNL_MSG_CT_GET, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_FLUSH:
-		nfnl_fill_hdr(ssh, &req->nlh, 0, *family, 0, IPCTNL_MSG_CT_DELETE, NLM_F_REQUEST|NLM_F_ACK);
+		nfct_fill_hdr(req, IPCTNL_MSG_CT_DELETE, NLM_F_ACK, *family,
+			      NFNETLINK_V0);
 		break;
 	case NFCT_Q_DUMP:
-		nfnl_fill_hdr(ssh, &req->nlh, 0, *family, 0, IPCTNL_MSG_CT_GET, NLM_F_REQUEST|NLM_F_DUMP);
+		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET, NLM_F_DUMP, *family,
+			      NFNETLINK_V0);
 		break;
 	case NFCT_Q_DUMP_RESET:
-		nfnl_fill_hdr(ssh, &req->nlh, 0, *family, 0, IPCTNL_MSG_CT_GET_CTRZERO, NLM_F_REQUEST|NLM_F_DUMP);
+		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET_CTRZERO, NLM_F_DUMP,
+			      *family, NFNETLINK_V0);
 		break;
 	case NFCT_Q_CREATE_UPDATE:
 		__build_conntrack(ssh, req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_DUMP_FILTER:
-		nfnl_fill_hdr(ssh, &req->nlh, 0, AF_UNSPEC, 0, IPCTNL_MSG_CT_GET, NLM_F_REQUEST|NLM_F_DUMP);
+		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET, NLM_F_DUMP, AF_UNSPEC,
+			      NFNETLINK_V0);
 		__build_filter_dump(req, size, data);
 		break;
 	case NFCT_Q_DUMP_FILTER_RESET:
-		nfnl_fill_hdr(ssh, &req->nlh, 0, AF_UNSPEC, 0, IPCTNL_MSG_CT_GET_CTRZERO, NLM_F_REQUEST|NLM_F_DUMP);
+		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET_CTRZERO, NLM_F_DUMP,
+			      AF_UNSPEC, NFNETLINK_V0);
 		__build_filter_dump(req, size, data);
 		break;
 	default:
diff --git a/src/expect/api.c b/src/expect/api.c
index b50a47f171c1..33099d8ed0ce 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -11,6 +11,7 @@
 #include <string.h> /* for memset */
 #include <errno.h>
 #include <assert.h>
+#include <libmnl/libmnl.h>
 
 #include "internal/internal.h"
 
@@ -515,6 +516,24 @@ int nfexp_build_expect(struct nfnl_subsys_handle *ssh,
 	return __build_expect(ssh, req, size, type, flags, exp);
 }
 
+static void nfexp_fill_hdr(struct nfnlhdr *req, uint16_t type, uint16_t flags,
+			   uint8_t l3num, uint8_t version)
+{
+	char *buf = (char *)&req->nlh;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK_EXP << 8) | type;
+	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
+	nlh->nlmsg_seq = 0;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = l3num;
+	nfh->version = version;
+	nfh->res_id = 0;
+}
+
 static int
 __build_query_exp(struct nfnl_subsys_handle *ssh,
 		  const enum nf_conntrack_query qt,
@@ -543,10 +562,12 @@ __build_query_exp(struct nfnl_subsys_handle *ssh,
 		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_DELETE, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_FLUSH:
-		nfnl_fill_hdr(ssh, &req->nlh, 0, *family, 0, IPCTNL_MSG_EXP_DELETE, NLM_F_REQUEST|NLM_F_ACK);
+		nfexp_fill_hdr(req, IPCTNL_MSG_EXP_DELETE, NLM_F_ACK, *family,
+			       NFNETLINK_V0);
 		break;
 	case NFCT_Q_DUMP:
-		nfnl_fill_hdr(ssh, &req->nlh, 0, *family, 0, IPCTNL_MSG_EXP_GET, NLM_F_REQUEST|NLM_F_DUMP);
+		nfexp_fill_hdr(req, IPCTNL_MSG_EXP_GET, NLM_F_DUMP, *family,
+			       NFNETLINK_V0);
 		break;
 	default:
 		errno = ENOTSUP;
-- 
2.11.0

