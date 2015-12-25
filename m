From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_realm: Add translation to nft
Date: Fri, 25 Dec 2015 11:58:44 +0530
Message-ID: <20151225062844.GA9545@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34857 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbbLYG2v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 01:28:51 -0500
Received: by mail-pa0-f53.google.com with SMTP id jx14so130765002pad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Dec 2015 22:28:51 -0800 (PST)
Received: from gmail.com ([223.176.161.28])
        by smtp.gmail.com with ESMTPSA id q8sm60527068pap.45.2015.12.24.22.28.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 24 Dec 2015 22:28:50 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for routing realm to nftables.

Examples:

$ sudo iptables-translate -A PREROUTING -m realm --realm 4
nft add rule ip filter PREROUTING rtclassid 0x4 counter

$ sudo iptables-translate -A PREROUTING -m realm --realm 5/5
nft add rule ip filter PREROUTING rtclassid and 0x5 == 0x5 counter

$ sudo iptables-translate -A PREROUTING -m realm ! --realm 50
nft add rule ip filter PREROUTING rtclassid != 0x32 counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_realm.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index a8d9dda..d016040 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -34,6 +34,7 @@ static struct xtables_lmap *realms;
 static void realm_init(struct xt_entry_match *m)
 {
 	const char file[] = "/etc/iproute2/rt_realms";
+
 	realms = xtables_lmap_init(file);
 	if (realms == NULL && errno != ENOENT)
 		fprintf(stderr, "Warning: %s: %s\n", file, strerror(errno));
@@ -70,7 +71,7 @@ static void realm_parse(struct xt_option_call *cb)
 static void
 print_realm(unsigned long id, unsigned long mask, int numeric)
 {
-	const char* name = NULL;
+	const char *name = NULL;
 
 	if (mask != 0xffffffff)
 		printf(" 0x%lx/0x%lx", id, mask);
@@ -85,7 +86,7 @@ print_realm(unsigned long id, unsigned long mask, int numeric)
 }
 
 static void realm_print(const void *ip, const struct xt_entry_match *match,
-                        int numeric)
+			int numeric)
 {
 	const struct xt_realm_info *ri = (const void *)match->data;
 
@@ -107,6 +108,42 @@ static void realm_save(const void *ip, const struct xt_entry_match *match)
 	print_realm(ri->id, ri->mask, 0);
 }
 
+static void
+print_realm_xlate(unsigned long id, unsigned long mask,
+		  int numeric, struct xt_buf *buf, uint32_t op)
+{
+	const char *name = NULL;
+
+	if (mask != 0xffffffff)
+		xt_buf_add(buf, " and 0x%lx %s 0x%lx ", id,
+			   op == XT_OP_EQ ? "==" : "!=", mask);
+	else {
+		if (numeric == 0)
+			name = xtables_lmap_id2name(realms, id);
+		if (name)
+			xt_buf_add(buf, "%s%s ",
+				   op == XT_OP_EQ ? "" : "!= ", name);
+		else
+			xt_buf_add(buf, " %s0x%lx ",
+				   op == XT_OP_EQ ? "" : "!= ", id);
+	}
+}
+
+static int realm_xlate(const struct xt_entry_match *match,
+		       struct xt_buf *buf, int numeric)
+{
+	const struct xt_realm_info *ri = (const void *)match->data;
+	enum xt_op op = XT_OP_EQ;
+
+	if (ri->invert)
+		op = XT_OP_NEQ;
+
+	xt_buf_add(buf, "rtclassid");
+	print_realm_xlate(ri->id, ri->mask, 0, buf, op);
+
+	return 1;
+}
+
 static struct xtables_match realm_mt_reg = {
 	.name		= "realm",
 	.version	= XTABLES_VERSION,
@@ -119,6 +156,7 @@ static struct xtables_match realm_mt_reg = {
 	.save		= realm_save,
 	.x6_parse	= realm_parse,
 	.x6_options	= realm_opts,
+	.xlate		= realm_xlate,
 };
 
 void _init(void)
-- 
1.9.1

