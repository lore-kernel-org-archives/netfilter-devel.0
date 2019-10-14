Return-Path: <SRS0=Oskt=YH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BB1ECE587
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 09:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE83207FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 09:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbfJNJOA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 05:14:00 -0400
Received: from correo.us.es ([193.147.175.20]:35830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730585AbfJNJOA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 05:14:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D40E5303D07
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 11:13:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4AF3B7FFE
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 11:13:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA537B7FFB; Mon, 14 Oct 2019 11:13:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E282B7FF9;
        Mon, 14 Oct 2019 11:13:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 14 Oct 2019 11:13:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 50D1642EE393;
        Mon, 14 Oct 2019 11:13:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, edumazet@google.com
Subject: [PATCH libmnl] include: add MNL_SOCKET_DUMP_SIZE definition
Date:   Mon, 14 Oct 2019 11:13:51 +0200
Message-Id: <20191014091351.5880-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add definition to recommend a new buffer size for netlink dumps.
Details are available here:

 commit d35c99ff77ecb2eb239731b799386f3b3637a31e
 Author: Eric Dumazet <edumazet@google.com>
 Date:   Thu Oct 6 04:13:18 2016 +0900

    netlink: do not enter direct reclaim from netlink_dump()

 iproute2 is using 32 KBytes buffer in netlink dumps to speed up netlink
 dumps for a while. Let's recommend this buffer size through this new
 definitions.

Update examples too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/netfilter/nfct-dump.c  | 2 +-
 examples/rtnl/rtnl-addr-dump.c  | 4 ++--
 examples/rtnl/rtnl-link-dump.c  | 4 ++--
 examples/rtnl/rtnl-link-dump2.c | 4 ++--
 examples/rtnl/rtnl-link-dump3.c | 4 ++--
 examples/rtnl/rtnl-neigh-dump.c | 4 ++--
 examples/rtnl/rtnl-route-dump.c | 4 ++--
 include/libmnl/libmnl.h         | 1 +
 8 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/examples/netfilter/nfct-dump.c b/examples/netfilter/nfct-dump.c
index 114af616977b..cb8e52ccad0e 100644
--- a/examples/netfilter/nfct-dump.c
+++ b/examples/netfilter/nfct-dump.c
@@ -263,8 +263,8 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(void)
 {
+	char buf[MNL_SOCKET_DUMP_SIZE];
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfh;
 	uint32_t seq, portid;
diff --git a/examples/rtnl/rtnl-addr-dump.c b/examples/rtnl/rtnl-addr-dump.c
index b92b75f6eef3..675e9b0b5256 100644
--- a/examples/rtnl/rtnl-addr-dump.c
+++ b/examples/rtnl/rtnl-addr-dump.c
@@ -76,12 +76,12 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(int argc, char *argv[])
 {
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	unsigned int seq, portid;
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
 	int ret;
-	unsigned int seq, portid;
 
 	if (argc != 2) {
 		fprintf(stderr, "Usage: %s <inet|inet6>\n", argv[0]);
diff --git a/examples/rtnl/rtnl-link-dump.c b/examples/rtnl/rtnl-link-dump.c
index f5d63125c60c..031346fbf61a 100644
--- a/examples/rtnl/rtnl-link-dump.c
+++ b/examples/rtnl/rtnl-link-dump.c
@@ -81,12 +81,12 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(void)
 {
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	unsigned int seq, portid;
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
 	int ret;
-	unsigned int seq, portid;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type	= RTM_GETLINK;
diff --git a/examples/rtnl/rtnl-link-dump2.c b/examples/rtnl/rtnl-link-dump2.c
index b3ca3fa6be4b..890e51ad43d0 100644
--- a/examples/rtnl/rtnl-link-dump2.c
+++ b/examples/rtnl/rtnl-link-dump2.c
@@ -54,12 +54,12 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(void)
 {
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	unsigned int seq, portid;
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
 	int ret;
-	unsigned int seq, portid;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type	= RTM_GETLINK;
diff --git a/examples/rtnl/rtnl-link-dump3.c b/examples/rtnl/rtnl-link-dump3.c
index 2521214ed597..a381da1bd697 100644
--- a/examples/rtnl/rtnl-link-dump3.c
+++ b/examples/rtnl/rtnl-link-dump3.c
@@ -54,12 +54,12 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(void)
 {
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	unsigned int seq, portid;
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
 	int ret;
-	unsigned int seq, portid;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type	= RTM_GETLINK;
diff --git a/examples/rtnl/rtnl-neigh-dump.c b/examples/rtnl/rtnl-neigh-dump.c
index f4d500078388..786e31d8ded3 100644
--- a/examples/rtnl/rtnl-neigh-dump.c
+++ b/examples/rtnl/rtnl-neigh-dump.c
@@ -99,12 +99,12 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(int argc, char *argv[])
 {
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	unsigned int seq, portid;
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
 	int ret;
-	unsigned int seq, portid;
 
 	if (argc != 2) {
 		fprintf(stderr, "Usage: %s <inet|inet6>\n", argv[0]);
diff --git a/examples/rtnl/rtnl-route-dump.c b/examples/rtnl/rtnl-route-dump.c
index 17da80b90d1d..02ac6b20c644 100644
--- a/examples/rtnl/rtnl-route-dump.c
+++ b/examples/rtnl/rtnl-route-dump.c
@@ -298,12 +298,12 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(int argc, char *argv[])
 {
+	char buf[MNL_SOCKET_DUMP_SIZE];
+	unsigned int seq, portid;
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct rtmsg *rtm;
 	int ret;
-	unsigned int seq, portid;
 
 	if (argc != 2) {
 		fprintf(stderr, "Usage: %s <inet|inet6>\n", argv[0]);
diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 0331da71775f..4bd0b92e8742 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -18,6 +18,7 @@ extern "C" {
 
 #define MNL_SOCKET_AUTOPID	0
 #define MNL_SOCKET_BUFFER_SIZE (sysconf(_SC_PAGESIZE) < 8192L ? sysconf(_SC_PAGESIZE) : 8192L)
+#define MNL_SOCKET_DUMP_SIZE	32768
 
 struct mnl_socket;
 
-- 
2.11.0

