Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C60238C06
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 09:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750671005; cv=none; b=sLw9w/Eij3yhznJs8WK9Kr9HmJLAnL4v2WzBhzotYbAZXq4dPYlCfE+Wdw5Tu/cGaQgj94vYsM+harucXnQVWArtdjI6nJZAPe5mF1fXjR+C/llZqTBBjMzkocFj62rxXfAF7jHRBcMR2e8W/+bIETjq3qM8PK98n7ZDG/OnOXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750671005; c=relaxed/simple;
	bh=bWUpHv1os9sW9fRXA4gTbSJ0ri3yYdnChOW4k1GtQt4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1tWyExoyZiEc2uGJ+T8jBXnM0mGC9DEylwJgB+3JuIs2FaZwwu38Jw0ZBK+qfA8OP5dNf7uAO1A/r79QAErd4YrmDj0vTi02dFVbdEQZzTh912AkFboE1yhrEFQvaKZ48MTdDaN5BxL8zWuW+iU6QPu/qfszOM8N1TOr8MK4dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 0B805461B7
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 11:29:54 +0200 (CEST)
From: Christoph Heiss <c.heiss@proxmox.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools v3 1/2] conntrack: move label parsing to after argument parsing
Date: Mon, 23 Jun 2025 11:29:27 +0200
Message-ID: <20250623092948.200330-2-c.heiss@proxmox.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623092948.200330-1-c.heiss@proxmox.com>
References: <20250623092948.200330-1-c.heiss@proxmox.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of parsing them directly inline during argument parsing, put
them into a list and do it afterwards.

Preparation for introduction a new `--labelmap` option to specify the
path to the label mapping file.

Signed-off-by: Christoph Heiss <c.heiss@proxmox.com>
---
 src/conntrack.c | 62 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 2d4e864..96f19b5 100644
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
@@ -2963,6 +2969,32 @@ static int print_stats(const struct ct_cmd *cmd)
 	return 0;
 }
 
+static void parse_and_merge_labels(struct list_head *label_list, struct ct_tmpl *tmpl)
+{
+	struct ct_label *label, *next;
+	struct nfct_bitmask *bitmask;
+	unsigned int max;
+
+	list_for_each_entry_safe(label, next, label_list, list) {
+		max = parse_label_get_max(label->name);
+		bitmask = nfct_bitmask_new(max);
+		if (!bitmask)
+			exit_error(OTHER_PROBLEM, "out of memory");
+
+		parse_label(bitmask, label->name);
+
+		/* join "-l foo -l bar" into single bitmask object */
+		if (label->is_modify)
+			merge_bitmasks(&tmpl->label_modify, bitmask);
+		else
+			merge_bitmasks(&tmpl->label, bitmask);
+
+		list_del(&label->list);
+		free(label->name);
+		free(label);
+	}
+}
+
 static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 {
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
@@ -2973,6 +3005,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	struct ct_tmpl *tmpl;
 	int res = 0, partial;
 	union ct_address ad;
+	LIST_HEAD(labels);
 	uint32_t value;
 	int c, cmd;
 
@@ -3088,8 +3121,6 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'o':
 			options |= CT_OPT_OUTPUT;
 			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
-			if (output_mask & _O_CL)
-				labelmap_init();
 			if ((output_mask & _O_SAVE) &&
 			    (output_mask & (_O_EXT |_O_TMS |_O_ID | _O_KTMS | _O_CL | _O_XML)))
 				exit_error(OTHER_PROBLEM,
@@ -3162,8 +3193,6 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case '>':
 			options |= opt2type[c];
 
-			labelmap_init();
-
 			if ((options & (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL)) ==
 			    (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL))
 				exit_error(OTHER_PROBLEM, "cannot use --label-add and "
@@ -3176,22 +3205,13 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
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
@@ -3246,6 +3266,12 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
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


