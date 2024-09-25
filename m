Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71CCE15B54A
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727261092; cv=none; b=tZPoPwyW2YcVtE4rL6kNAK7b1xpB4YBDOe9GLTnOOLWuFWXXomii3Ii5hu5aW+GMjXoBR5v+BvSFCyrAavKY+jFk8Cgqam4OSmGUEXzxupycO3fBCU8TIoGoHZZBAp9TnhjdNiYn0ZASNwlpFqJlyEgKmi0GlMmMXGOBeIfQG7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727261092; c=relaxed/simple;
	bh=yOP5PCRkVOlsMGpof4pTnaTzbbdwBWXENgGO1FDpKNI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=o2TIQTZEffmG/MmzC+NerJIIG/OAW5qdTuPXz73qQfY6PeAOfKv8wksfzz/KyJMNnSMFOqwTsbhYwa/1r4biMPgO8hPFZk6RbXzriRX97cJRQBKPtEqR8MHf1N0cyNb8dvWYre1aSyPz7F9cUwtbPP+oi3vC0/rFTs4xPBwsWnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] src: remove scaffolding around deprecated parser functions
Date: Wed, 25 Sep 2024 12:44:43 +0200
Message-Id: <20240925104443.37555-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nftnl_.*_do_parse() are of no use anymore, remove them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/object.c | 30 ++++++------------------------
 src/rule.c   | 29 ++++++-----------------------
 src/set.c    | 30 ++++++------------------------
 src/table.c  | 26 ++++++--------------------
 4 files changed, 24 insertions(+), 91 deletions(-)

diff --git a/src/object.c b/src/object.c
index 19cb7d0dbf73..9d150315d487 100644
--- a/src/object.c
+++ b/src/object.c
@@ -386,40 +386,22 @@ int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
 	return 0;
 }
 
-static int nftnl_obj_do_parse(struct nftnl_obj *obj, enum nftnl_parse_type type,
-			      const void *data, struct nftnl_parse_err *err,
-			      enum nftnl_parse_input input)
-{
-	struct nftnl_parse_err perr = {};
-	int ret;
-
-	switch (type) {
-	case NFTNL_PARSE_JSON:
-	case NFTNL_PARSE_XML:
-	default:
-		ret = -1;
-		errno = EOPNOTSUPP;
-		break;
-	}
-
-	if (err != NULL)
-		*err = perr;
-
-	return ret;
-}
-
 EXPORT_SYMBOL(nftnl_obj_parse);
 int nftnl_obj_parse(struct nftnl_obj *obj, enum nftnl_parse_type type,
 		      const char *data, struct nftnl_parse_err *err)
 {
-	return nftnl_obj_do_parse(obj, type, data, err, NFTNL_PARSE_BUFFER);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 EXPORT_SYMBOL(nftnl_obj_parse_file);
 int nftnl_obj_parse_file(struct nftnl_obj *obj, enum nftnl_parse_type type,
 			   FILE *fp, struct nftnl_parse_err *err)
 {
-	return nftnl_obj_do_parse(obj, type, fp, err, NFTNL_PARSE_FILE);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 static int nftnl_obj_snprintf_dflt(char *buf, size_t remain,
diff --git a/src/rule.c b/src/rule.c
index e16e2c1aa5bf..811d5a213f83 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -500,39 +500,22 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 	return 0;
 }
 
-static int nftnl_rule_do_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
-			     const void *data, struct nftnl_parse_err *err,
-			     enum nftnl_parse_input input)
-{
-	int ret;
-	struct nftnl_parse_err perr = {};
-
-	switch (type) {
-	case NFTNL_PARSE_JSON:
-	case NFTNL_PARSE_XML:
-	default:
-		ret = -1;
-		errno = EOPNOTSUPP;
-		break;
-	}
-	if (err != NULL)
-		*err = perr;
-
-	return ret;
-}
-
 EXPORT_SYMBOL(nftnl_rule_parse);
 int nftnl_rule_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 		   const char *data, struct nftnl_parse_err *err)
 {
-	return nftnl_rule_do_parse(r, type, data, err, NFTNL_PARSE_BUFFER);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 EXPORT_SYMBOL(nftnl_rule_parse_file);
 int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 			FILE *fp, struct nftnl_parse_err *err)
 {
-	return nftnl_rule_do_parse(r, type, fp, err, NFTNL_PARSE_FILE);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 static int nftnl_rule_snprintf_default(char *buf, size_t remain,
diff --git a/src/set.c b/src/set.c
index 07e332dcd673..75ad64e03850 100644
--- a/src/set.c
+++ b/src/set.c
@@ -753,40 +753,22 @@ out_set_expr:
 	return -1;
 }
 
-static int nftnl_set_do_parse(struct nftnl_set *s, enum nftnl_parse_type type,
-			    const void *data, struct nftnl_parse_err *err,
-			    enum nftnl_parse_input input)
-{
-	int ret;
-	struct nftnl_parse_err perr = {};
-
-	switch (type) {
-	case NFTNL_PARSE_JSON:
-	case NFTNL_PARSE_XML:
-	default:
-		ret = -1;
-		errno = EOPNOTSUPP;
-		break;
-	}
-
-	if (err != NULL)
-		*err = perr;
-
-	return ret;
-}
-
 EXPORT_SYMBOL(nftnl_set_parse);
 int nftnl_set_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 		  const char *data, struct nftnl_parse_err *err)
 {
-	return nftnl_set_do_parse(s, type, data, err, NFTNL_PARSE_BUFFER);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 EXPORT_SYMBOL(nftnl_set_parse_file);
 int nftnl_set_parse_file(struct nftnl_set *s, enum nftnl_parse_type type,
 		       FILE *fp, struct nftnl_parse_err *err)
 {
-	return nftnl_set_do_parse(s, type, fp, err, NFTNL_PARSE_FILE);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 static int nftnl_set_snprintf_default(char *buf, size_t remain,
diff --git a/src/table.c b/src/table.c
index 1a5f6f3bcc50..b1b164cbbced 100644
--- a/src/table.c
+++ b/src/table.c
@@ -327,36 +327,22 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 	return 0;
 }
 
-static int nftnl_table_do_parse(struct nftnl_table *t, enum nftnl_parse_type type,
-			      const void *data, struct nftnl_parse_err *err,
-			      enum nftnl_parse_input input)
-{
-	int ret;
-
-	switch (type) {
-	case NFTNL_PARSE_JSON:
-	case NFTNL_PARSE_XML:
-	default:
-		ret = -1;
-		errno = EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-}
-
 EXPORT_SYMBOL(nftnl_table_parse);
 int nftnl_table_parse(struct nftnl_table *t, enum nftnl_parse_type type,
 		    const char *data, struct nftnl_parse_err *err)
 {
-	return nftnl_table_do_parse(t, type, data, err, NFTNL_PARSE_BUFFER);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 EXPORT_SYMBOL(nftnl_table_parse_file);
 int nftnl_table_parse_file(struct nftnl_table *t, enum nftnl_parse_type type,
 			 FILE *fp, struct nftnl_parse_err *err)
 {
-	return nftnl_table_do_parse(t, type, fp, err, NFTNL_PARSE_FILE);
+	errno = EOPNOTSUPP;
+
+	return -1;
 }
 
 static int nftnl_table_snprintf_default(char *buf, size_t size,
-- 
2.30.2

