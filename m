From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] src: remove redundant casts
Date: Tue,  9 Nov 2010 20:28:55 +0100
Message-ID: <1289330936-9939-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34781 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0KIT25 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:28:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/iftable.c      |    4 ++--
 src/libnfnetlink.c |   27 +++++++++++++--------------
 src/rtnl.c         |   12 ++++++------
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/src/iftable.c b/src/iftable.c
index c3a8448..959249a 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -55,7 +55,7 @@ static int iftable_add(struct nlmsghdr *n, void *arg)
 	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
 	struct ifindex_node *this;
 	struct rtattr *cb[IFLA_MAX+1];
-	struct nlif_handle *h = (struct nlif_handle *)arg;
+	struct nlif_handle *h = arg;
 
 	if (n->nlmsg_type != RTM_NEWLINK)
 		return -1;
@@ -115,7 +115,7 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
 {
 	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
 	struct rtattr *cb[IFLA_MAX+1];
-	struct nlif_handle *h = (struct nlif_handle *)arg;
+	struct nlif_handle *h = arg;
 	struct ifindex_node *this, *tmp;
 	unsigned int hash;
 
diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index b048d2b..6e7afc6 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -445,8 +445,7 @@ void nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
 	assert(ssh);
 	assert(nlh);
 
-	struct nfgenmsg *nfg = (struct nfgenmsg *) 
-					((void *)nlh + sizeof(*nlh));
+	struct nfgenmsg *nfg = (void *)nlh + sizeof(*nlh);
 
 	nlh->nlmsg_len = NLMSG_LENGTH(len+sizeof(*nfg));
 	nlh->nlmsg_type = (ssh->subsys_id<<8)|msg_type;
@@ -478,14 +477,14 @@ nfnl_parse_hdr(const struct nfnl_handle *nfnlh,
 
 	if (nlh->nlmsg_len == NLMSG_LENGTH(sizeof(struct nfgenmsg))) {
 		if (genmsg)
-			*genmsg = (struct nfgenmsg *)((void *)nlh+sizeof(nlh));
+			*genmsg = (void *)nlh + sizeof(nlh);
 		return NULL;
 	}
 
 	if (genmsg)
-		*genmsg = (struct nfgenmsg *)((void *)nlh + sizeof(nlh));
+		*genmsg = (void *)nlh + sizeof(nlh);
 
-	return ((void *)nlh + NLMSG_LENGTH(sizeof(struct nfgenmsg)));
+	return (void *)nlh + NLMSG_LENGTH(sizeof(struct nfgenmsg));
 }
 
 /**
@@ -575,10 +574,10 @@ int nfnl_listen(struct nfnl_handle *nfnlh,
 	int quit=0;
 
 	struct msghdr msg = {
-		(void *)&nladdr, sizeof(nladdr),
-		&iov, 1,
-		NULL, 0,
-		0
+		.msg_name    = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov     = &iov,
+		.msg_iovlen  = 1,
 	};
 
 	memset(&nladdr, 0, sizeof(nladdr));
@@ -682,13 +681,13 @@ int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,
 	unsigned int seq;
 	int status;
 	struct iovec iov = {
-		(void *)n, n->nlmsg_len
+		n, n->nlmsg_len
 	};
 	struct msghdr msg = {
-		(void *)&nladdr, sizeof(nladdr),
-		&iov, 1,
-		NULL, 0,
-		0
+		.msg_name    = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov     = &iov,
+		.msg_iovlen  = 1,
 	};
 
 	memset(&nladdr, 0, sizeof(nladdr));
diff --git a/src/rtnl.c b/src/rtnl.c
index 548dc09..1092c81 100644
--- a/src/rtnl.c
+++ b/src/rtnl.c
@@ -127,7 +127,7 @@ int rtnl_dump_type(struct rtnl_handle *rtnl_handle, unsigned int type)
 	req.nlh.nlmsg_seq = rtnl_handle->rtnl_dump = ++(rtnl_handle->rtnl_seq);
 	req.g.rtgen_family = AF_INET;
 
-	return sendto(rtnl_handle->rtnl_fd, (void*)&req, sizeof(req), 0, 
+	return sendto(rtnl_handle->rtnl_fd, &req, sizeof(req), 0,
 		      (struct sockaddr*)&nladdr, sizeof(nladdr));
 }
 
@@ -141,10 +141,10 @@ int rtnl_receive(struct rtnl_handle *rtnl_handle)
 	struct nlmsghdr *h;
 
 	struct msghdr msg = {
-		(void *)&nladdr, sizeof(nladdr),
-		&iov, 1,
-		NULL, 0,
-		0
+		.msg_name    = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov     = &iov,
+		.msg_iovlen  = 1,
 	};
 
 	status = recvmsg(rtnl_handle->rtnl_fd, &msg, 0);
@@ -177,7 +177,7 @@ int rtnl_receive(struct rtnl_handle *rtnl_handle)
 			return 0;
 		}
 		if (h->nlmsg_type == NLMSG_ERROR) { 
-			struct nlmsgerr *err = (struct nlmsgerr *)NLMSG_DATA(h);
+			struct nlmsgerr *err = NLMSG_DATA(h);
 			if (h->nlmsg_len>=NLMSG_LENGTH(sizeof(struct nlmsgerr)))
 				errno = -err->error;
 			rtnl_log(LOG_ERROR, "NLMSG_ERROR, errnp=%d",
-- 
1.7.1

