From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] examples: remove redundant casts
Date: Sat, 30 Oct 2010 22:35:38 +0200
Message-ID: <1288470939-7346-2-git-send-email-jengelh@medozas.de>
References: <1288470939-7346-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48493 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0J3Ufp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 16:35:45 -0400
In-Reply-To: <1288470939-7346-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 examples/genl/genl-family-get.c |    6 +++---
 examples/netfilter/nf-queue.c   |    2 +-
 examples/netfilter/nfct-event.c |    8 ++++----
 examples/rtnl/rtnl-link-dump.c  |    2 +-
 examples/rtnl/rtnl-link-event.c |    2 +-
 examples/rtnl/rtnl-route-dump.c |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
index be8da3c..ba8291e 100644
--- a/examples/genl/genl-family-get.c
+++ b/examples/genl/genl-family-get.c
@@ -14,7 +14,7 @@
 
 static int parse_mc_grps_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	/* skip unsupported attribute in user-space */
@@ -61,7 +61,7 @@ static void parse_genl_mc_grps(struct nlattr *nested)
 
 static int parse_family_ops_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, CTRL_ATTR_OP_MAX) < 0)
@@ -104,7 +104,7 @@ static void parse_genl_family_ops(struct nlattr *nested)
 
 static int data_attr_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, CTRL_ATTR_MAX) < 0)
diff --git a/examples/netfilter/nf-queue.c b/examples/netfilter/nf-queue.c
index 8b1a5e7..3658ba2 100644
--- a/examples/netfilter/nf-queue.c
+++ b/examples/netfilter/nf-queue.c
@@ -23,7 +23,7 @@
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
 {
-        const struct nlattr **tb = (const struct nlattr **)data;
+        const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	/* skip unsupported attribute in user-space */
diff --git a/examples/netfilter/nfct-event.c b/examples/netfilter/nfct-event.c
index 3a87071..660d443 100644
--- a/examples/netfilter/nfct-event.c
+++ b/examples/netfilter/nfct-event.c
@@ -15,7 +15,7 @@
 
 static int parse_ip_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, CTA_IP_MAX) < 0)
@@ -51,7 +51,7 @@ static void print_ip(const struct nlattr *nest)
 
 static int parse_proto_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, CTA_PROTO_MAX) < 0)
@@ -109,7 +109,7 @@ static void print_proto(const struct nlattr *nest)
 
 static int parse_tuple_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, CTA_TUPLE_MAX) < 0)
@@ -148,7 +148,7 @@ static void print_tuple(const struct nlattr *nest)
 
 static int data_attr_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, CTA_MAX) < 0)
diff --git a/examples/rtnl/rtnl-link-dump.c b/examples/rtnl/rtnl-link-dump.c
index 76e6c2c..3fe3d95 100644
--- a/examples/rtnl/rtnl-link-dump.c
+++ b/examples/rtnl/rtnl-link-dump.c
@@ -16,7 +16,7 @@
 
 static int data_attr_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	/* skip unsupported attribute in user-space */
diff --git a/examples/rtnl/rtnl-link-event.c b/examples/rtnl/rtnl-link-event.c
index 83c516c..9338e12 100644
--- a/examples/rtnl/rtnl-link-event.c
+++ b/examples/rtnl/rtnl-link-event.c
@@ -15,7 +15,7 @@
 
 static int data_attr_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	/* skip unsupported attribute in user-space */
diff --git a/examples/rtnl/rtnl-route-dump.c b/examples/rtnl/rtnl-route-dump.c
index 7e86017..3622c1b 100644
--- a/examples/rtnl/rtnl-route-dump.c
+++ b/examples/rtnl/rtnl-route-dump.c
@@ -73,7 +73,7 @@ static void attributes_show_ipv4(struct nlattr *tb[])
 
 static int data_attr_cb(const struct nlattr *attr, void *data)
 {
-	const struct nlattr **tb = (const struct nlattr **)data;
+	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
 	/* skip unsupported attribute in user-space */
-- 
1.7.1

