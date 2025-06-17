Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9389A28FFE6
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2025 10:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157363; cv=none; b=SMzQAN5Cm8gQU9fjMgiHCfhDPJPHJYquobhcoorJZrbYI5tRx1yTVZOCCuzilRPatkEEvCKMPVRm0QEIdkLk74r38y9VAZ4p8hBjIUUrck0UpxODERSgDsNAloUuB0eMz8TZrP7jcndXXBOH6l5pvzwbWo7RV1u1l/P4NcIfweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157363; c=relaxed/simple;
	bh=PoBO5uXxt5r866iKV/X8Xvw8ObcFs+4E4q9IOf/Fa8g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2Ua+Ntn6TmEJXzcdIWhY2u4SRZOqB4Q7DGXangyhxMfbvrla56jdKpIF7YfpQYCqyFr1pJWHg17inAfkLdFfAAIo7SgJ+Uac0hU+mpcoygWty0K3j3q1bFRir3TwnF6kmrcFK+9v/kwsrPewnpVgVlnu8ThhsNjpnk7L7+NMJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 0E13D4605A
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2025 12:49:13 +0200 (CEST)
From: Christoph Heiss <c.heiss@proxmox.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools v2 1/2] conntrack: move label parsing after argument parsing
Date: Tue, 17 Jun 2025 12:48:33 +0200
Message-ID: <20250617104837.939280-2-c.heiss@proxmox.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617104837.939280-1-c.heiss@proxmox.com>
References: <20250617104837.939280-1-c.heiss@proxmox.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of parsing directly inline while parsing, put them into a list
and do it afterwards.

Preparation for introduction a new `--labelmap` option to specify the
path to the label mapping file.

Signed-off-by: Christoph Heiss <c.heiss@proxmox.com>
---
 src/conntrack.c | 60 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 2d4e864..b9afd2f 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -122,6 +122,12 @@ struct ct_cmd {
 	struct ct_tmpl	tmpl;
 };
 
+struct ct_label {
+	struct list_head list;
+	char *name;
+	bool is_modify;
+};
+
 static int alloc_tmpl_objects(struct ct_tmpl *tmpl)
 {
 	tmpl->ct = nfct_new();
@@ -2963,6 +2969,30 @@ static int print_stats(const struct ct_cmd *cmd)
 	return 0;
 }
 
+static void parse_and_merge_labels(struct list_head *labels, struct ct_tmpl *tmpl)
+{
+	struct ct_label *l, *next;
+	list_for_each_entry_safe(l, next, labels, list) {
+		unsigned int max = parse_label_get_max(l->name);
+		struct nfct_bitmask *b = nfct_bitmask_new(max);
+		if (!b)
+			exit_error(OTHER_PROBLEM, "out of memory");
+
+		parse_label(b, l->name);
+
+		/* join "-l foo -l bar" into single bitmask object */
+		if (l->is_modify) {
+			merge_bitmasks(&tmpl->label_modify, b);
+		} else {
+			merge_bitmasks(&tmpl->label, b);
+		}
+
+		list_del(&l->list);
+		free(l->name);
+		free(l);
+	}
+}
+
 static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 {
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
@@ -2973,6 +3003,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	struct ct_tmpl *tmpl;
 	int res = 0, partial;
 	union ct_address ad;
+	LIST_HEAD(labels);
 	uint32_t value;
 	int c, cmd;
 
@@ -3088,8 +3119,6 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'o':
 			options |= CT_OPT_OUTPUT;
 			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
-			if (output_mask & _O_CL)
-				labelmap_init();
 			if ((output_mask & _O_SAVE) &&
 			    (output_mask & (_O_EXT |_O_TMS |_O_ID | _O_KTMS | _O_CL | _O_XML)))
 				exit_error(OTHER_PROBLEM,
@@ -3162,8 +3191,6 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case '>':
 			options |= opt2type[c];
 
-			labelmap_init();
-
 			if ((options & (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL)) ==
 			    (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL))
 				exit_error(OTHER_PROBLEM, "cannot use --label-add and "
@@ -3176,22 +3203,13 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 				optarg = tmp;
 			}
 
-			char *optarg2 = strdup(optarg);
-			unsigned int max = parse_label_get_max(optarg);
-			struct nfct_bitmask * b = nfct_bitmask_new(max);
-			if (!b)
+			struct ct_label *l = calloc(1, sizeof(*l));
+			if (!l)
 				exit_error(OTHER_PROBLEM, "out of memory");
 
-			parse_label(b, optarg2);
-
-			/* join "-l foo -l bar" into single bitmask object */
-			if (c == 'l') {
-				merge_bitmasks(&tmpl->label, b);
-			} else {
-				merge_bitmasks(&tmpl->label_modify, b);
-			}
-
-			free(optarg2);
+			l->name = strdup(optarg);
+			l->is_modify = c == '<' || c == '>';
+			list_add_tail(&l->list, &labels);
 			break;
 		case 'a':
 			fprintf(stderr, "WARNING: ignoring -%c, "
@@ -3246,6 +3264,12 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		}
 	}
 
+	/* any of these options (might) use labels */
+	if ((options & (CT_OPT_LABEL | CT_OPT_ADD_LABEL | CT_OPT_DEL_LABEL)) ||
+	    ((options & CT_OPT_OUTPUT) && (output_mask & _O_CL))) {
+		labelmap_init();
+		parse_and_merge_labels(&labels, tmpl);
+	}
 
 	/* we cannot check this combination with generic_opt_check. */
 	if (options & CT_OPT_ANY_NAT &&
-- 
2.49.0


