From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/11] libipset: remove redundant casts
Date: Sun, 19 Dec 2010 06:18:11 +0100
Message-ID: <1292735894-17534-10-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42680 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab0LSFSZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:25 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 lib/data.c    |    4 ++--
 lib/parse.c   |    8 ++++----
 lib/session.c |    8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/data.c b/lib/data.c
index 2719b84..022e4b4 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -79,9 +79,9 @@ static void
 copy_addr(uint8_t family, union nf_inet_addr *ip, const void *value)
 {
 	if (family == AF_INET)
-		in4cpy(&ip->in, (const struct in_addr *)value);
+		in4cpy(&ip->in, value);
 	else
-		in6cpy(&ip->in6, (const struct in6_addr *)value);
+		in6cpy(&ip->in6, value);
 }
 
 /**
diff --git a/lib/parse.c b/lib/parse.c
index 01b0ccf..437ff61 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -48,7 +48,7 @@ ipset_strchr(const char *str, const char *sep)
 	assert(sep);
 	
 	for (; *sep != '\0'; sep++)
-		if ((match = strchr(str, (int)sep[0])) != NULL
+		if ((match = strchr(str, sep[0])) != NULL
 		    && str[0] != sep[0]
 		    && str[strlen(str)-1] != sep[0])
 			return match;
@@ -103,7 +103,7 @@ string_to_u8(struct ipset_session *session,
 	unsigned long long num = 0;
 
 	err = string_to_number_ll(session, str, 0, 255, &num);
-	*ret = (uint8_t) num;
+	*ret = num;
 
 	return err;
 }
@@ -129,7 +129,7 @@ string_to_u16(struct ipset_session *session,
 	unsigned long long num = 0;
 
 	err = string_to_number_ll(session, str, 0, USHRT_MAX, &num);
-	*ret = (uint16_t) num;
+	*ret = num;
 
 	return err;
 }
@@ -142,7 +142,7 @@ string_to_u32(struct ipset_session *session,
 	unsigned long long num = 0;
 
 	err = string_to_number_ll(session, str, 0, UINT_MAX, &num);
-	*ret = (uint32_t) num;
+	*ret = num;
 
 	return err;
 }
diff --git a/lib/session.c b/lib/session.c
index babd881..d043806 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -468,7 +468,7 @@ static int
 generic_data_attr_cb(const struct nlattr *attr, void *data,
 		     int attr_max, const struct ipset_attr_policy *policy)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 	
 	D("attr type: %u, len %u", type, attr->nla_len);
@@ -1464,7 +1464,7 @@ static int
 build_send_private_msg(struct ipset_session *session, enum ipset_cmd cmd)
 {
 	char buffer[PRIVATE_MSG_BUFLEN] __attribute__ ((aligned));
-	struct nlmsghdr *nlh = (struct nlmsghdr *) (void *) buffer;
+	struct nlmsghdr *nlh = (void *)buffer;
 	struct ipset_data *data = session->data;
 	int len = PRIVATE_MSG_BUFLEN, ret;
 	enum ipset_cmd saved = session->cmd;
@@ -1521,7 +1521,7 @@ may_aggregate_ad(struct ipset_session *session, struct ipset_data *data,
 static int
 build_msg(struct ipset_session *session, bool aggregate)
 {
-	struct nlmsghdr *nlh = (struct nlmsghdr *) session->buffer;
+	struct nlmsghdr *nlh = session->buffer;
 	struct ipset_data *data = session->data;
 
 	/* Public commands */
@@ -1678,7 +1678,7 @@ ipset_commit(struct ipset_session *session)
 
 	assert(session);
 
-	nlh = (struct nlmsghdr *) session->buffer;
+	nlh = session->buffer;
 	D("send buffer: len %u, cmd %s", nlh->nlmsg_len, cmd2name[session->cmd]);
 	if (nlh->nlmsg_len == 0)
 		/* Nothing to do */
-- 
1.7.1

