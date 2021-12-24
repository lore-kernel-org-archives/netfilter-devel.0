Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBAFC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 15:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353094AbhLXPoD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 10:44:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44500 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353091AbhLXPoC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 10:44:02 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3D32C625C5
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 16:41:25 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 2/4] conntrack: add netlink flags to nfct_mnl_nlmsghdr_put()
Date:   Fri, 24 Dec 2021 16:43:49 +0100
Message-Id: <20211224154351.360124-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211224154351.360124-1-pablo@netfilter.org>
References: <20211224154351.360124-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Moreover, remove NLM_F_DUMP for IPCTNL_MSG_CT_GET_STATS since ctnetlink
ignores this flag, this is simple netlink get command, not a dump.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 067ae4156676..3f74fa12fba2 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2417,14 +2417,14 @@ static int nfct_mnl_socket_open(unsigned int events)
 
 static struct nlmsghdr *
 nfct_mnl_nlmsghdr_put(char *buf, uint16_t subsys, uint16_t type,
-		      uint8_t family)
+		      uint16_t flags, uint8_t family)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfh;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = (subsys << 8) | type;
-	nlh->nlmsg_flags = NLM_F_REQUEST|NLM_F_DUMP;
+	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
 	nlh->nlmsg_seq = time(NULL);
 
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
@@ -2470,7 +2470,7 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, NLM_F_DUMP, family);
 
 	if (filter_dump)
 		nfct_nlmsg_build_filter(nlh, filter_dump);
@@ -2500,7 +2500,7 @@ nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, 0, family);
 
 	return nfct_mnl_talk(nlh, cb);
 }
-- 
2.30.2

