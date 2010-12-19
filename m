From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/11] libipset: const annotations
Date: Sun, 19 Dec 2010 06:18:12 +0100
Message-ID: <1292735894-17534-11-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42684 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab0LSFS0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:26 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 lib/mnl.c     |    2 +-
 lib/parse.c   |    2 +-
 lib/print.c   |    2 +-
 lib/session.c |    8 ++++----
 lib/types.c   |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/mnl.c b/lib/mnl.c
index aa98a7c..683dba2 100644
--- a/lib/mnl.c
+++ b/lib/mnl.c
@@ -31,7 +31,7 @@ struct ipset_handle {
 };
 
 /* Netlink flags of the commands */
-static uint16_t cmdflags[] = {
+static const uint16_t cmdflags[] = {
 	[IPSET_CMD_CREATE-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_CREATE|NLM_F_EXCL,
 	[IPSET_CMD_DESTROY-1]	= NLM_F_REQUEST|NLM_F_ACK,
 	[IPSET_CMD_FLUSH-1]	= NLM_F_REQUEST|NLM_F_ACK,
diff --git a/lib/parse.c b/lib/parse.c
index 437ff61..169d2e0 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -345,7 +345,7 @@ int
 ipset_parse_proto(struct ipset_session *session,
 		  enum ipset_opt opt, const char *str)
 {
-	struct protoent *protoent;
+	const struct protoent *protoent;
 	uint8_t proto = 0;
 
 	assert(session);
diff --git a/lib/print.c b/lib/print.c
index 87a9f2b..767fd04 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -454,7 +454,7 @@ ipset_print_proto(char *buf, unsigned int len,
 		  const struct ipset_data *data, enum ipset_opt opt,
 		  uint8_t env UNUSED)
 {
-	struct protoent *protoent;
+	const struct protoent *protoent;
 	uint8_t proto;
 
 	assert(buf);
diff --git a/lib/session.c b/lib/session.c
index d043806..628c1b9 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -690,7 +690,7 @@ retry:
 static int
 list_adt(struct ipset_session *session, struct nlattr *nla[])
 {
-	struct ipset_data *data = session->data;
+	const struct ipset_data *data = session->data;
 	const struct ipset_type *type;
 	const struct ipset_arg *arg;
 	uint8_t family;
@@ -774,7 +774,7 @@ list_adt(struct ipset_session *session, struct nlattr *nla[])
 static int
 list_create(struct ipset_session *session, struct nlattr *nla[])
 {
-	struct ipset_data *data = session->data;
+	const struct ipset_data *data = session->data;
 	const struct ipset_type *type;
 	const struct ipset_arg *arg;
 	uint8_t family;
@@ -1016,7 +1016,7 @@ static int
 callback_header(struct ipset_session *session, struct nlattr *nla[])
 {
 	const char *setname;
-	struct ipset_data *data = session->data;
+	const struct ipset_data *data = session->data;
 	
 	if (!nla[IPSET_ATTR_SETNAME])
 		FAILURE("Broken HEADER kernel message: missing setname!");
@@ -1047,7 +1047,7 @@ callback_header(struct ipset_session *session, struct nlattr *nla[])
 static int
 callback_type(struct ipset_session *session, struct nlattr *nla[])
 {
-	struct ipset_data *data = session->data;
+	const struct ipset_data *data = session->data;
 	const char *typename, *orig;
 	
 	if (!(nla[IPSET_ATTR_TYPENAME]
diff --git a/lib/types.c b/lib/types.c
index d979c24..1bd4274 100644
--- a/lib/types.c
+++ b/lib/types.c
@@ -393,7 +393,7 @@ ipset_type_get(struct ipset_session *session, enum ipset_cmd cmd)
 const struct ipset_type *
 ipset_type_check(struct ipset_session *session)
 {
-	struct ipset_type *t, *match = NULL;
+	const struct ipset_type *t, *match = NULL;
 	struct ipset_data *data;
 	const char *typename;
 	uint8_t family, revision;
-- 
1.7.1

