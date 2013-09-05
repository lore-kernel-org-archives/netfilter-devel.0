From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3] conntrack: support add/delete of conntrack labels
Date: Thu,  5 Sep 2013 11:27:49 +0200
Message-ID: <1378373270-6914-2-git-send-email-fw@strlen.de>
References: <1378373270-6914-1-git-send-email-fw@strlen.de>
Cc: Clemence Faure <clemence.faure@sophos.com>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59815 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763411Ab3IEJ2F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:05 -0400
In-Reply-To: <1378373270-6914-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Clemence Faure <clemence.faure@sophos.com>

new options "--label-add" and "--label-delete" to alter connlabels
assigned to a connection.

Signed-off-by: Clemence Faure <clemence.faure@sophos.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v1:
  make "--create --add-label foo" work again

 conntrack.8         |   10 +++-
 include/conntrack.h |    2 +-
 src/conntrack.c     |  154 +++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 140 insertions(+), 26 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 6410e5b..45e8582 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -146,9 +146,17 @@ In "--create" mode, the mask is ignored.
 .TP
 .BI "-l, --label " "LABEL"
 Specify a conntrack label.
-This option is only available in conjunction with "-L, --dump" or "-E, --event".
+This option is only available in conjunction with "-L, --dump", "-E, --event", or "-U --update".
 Match entries whose labels match at least those specified.
 Use multiple -l commands to specify multiple labels that need to be set.
+Match entries whose labels matches at least those specified as arguments.
+.BI "--label-add " "LABEL"
+Specify the conntrack label to add to to the selected conntracks.
+This option is only available in conjunction with "-I, --create" or "-U, --update".
+.BI "--label-del " "[LABEL]"
+Specify the conntrack label to delete from the selected conntracks.
+If no label is given, all labels are deleted.
+This option is only available in conjunction with "-U, --update".
 .TP
 .BI "-c, --secmark " "SECMARK"
 Specify the conntrack selinux security mark.
diff --git a/include/conntrack.h b/include/conntrack.h
index 6cd9962..c2a0c8f 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -10,7 +10,7 @@
 #include <netinet/in.h>
 
 #define NUMBER_OF_CMD   19
-#define NUMBER_OF_OPT   25
+#define NUMBER_OF_OPT   27
 
 struct ctproto_handler {
 	struct list_head 	head;
diff --git a/src/conntrack.c b/src/conntrack.c
index fe68e42..404ecc9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -82,6 +82,9 @@ static struct {
 
 	/* Allows filtering by ctlabels */
 	struct nfct_bitmask *label;
+
+	/* Allows setting/removing specific ctlabels */
+	struct nfct_bitmask *label_modify;
 } tmpl;
 
 static int alloc_tmpl_objects(void)
@@ -109,6 +112,8 @@ static void free_tmpl_objects(void)
 		nfexp_destroy(tmpl.exp);
 	if (tmpl.label)
 		nfct_bitmask_destroy(tmpl.label);
+	if (tmpl.label_modify)
+		nfct_bitmask_destroy(tmpl.label_modify);
 }
 
 enum ct_command {
@@ -255,6 +260,12 @@ enum ct_options {
 
 	CT_OPT_LABEL_BIT	= 24,
 	CT_OPT_LABEL		= (1 << CT_OPT_LABEL_BIT),
+
+	CT_OPT_ADD_LABEL_BIT	= 25,
+	CT_OPT_ADD_LABEL		= (1 << CT_OPT_ADD_LABEL_BIT),
+
+	CT_OPT_DEL_LABEL_BIT	= 26,
+	CT_OPT_DEL_LABEL		= (1 << CT_OPT_DEL_LABEL_BIT),
 };
 /* If you add a new option, you have to update NUMBER_OF_OPT in conntrack.h */
 
@@ -289,6 +300,8 @@ static const char *optflags[NUMBER_OF_OPT] = {
 	[CT_OPT_ANY_NAT_BIT]	= "any-nat",
 	[CT_OPT_ZONE_BIT]	= "zone",
 	[CT_OPT_LABEL_BIT]	= "label",
+	[CT_OPT_ADD_LABEL_BIT]	= "label-add",
+	[CT_OPT_DEL_LABEL_BIT]	= "label-del",
 };
 
 static struct option original_opts[] = {
@@ -330,12 +343,14 @@ static struct option original_opts[] = {
 	{"any-nat", 2, 0, 'j'},
 	{"zone", 1, 0, 'w'},
 	{"label", 1, 0, 'l'},
+	{"label-add", 1, 0, '<'},
+	{"label-del", 2, 0, '>'},
 	{0, 0, 0, 0}
 };
 
 static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
-				"g::c:b:C::Sj::w:l:";
+				"g::c:b:C::Sj::w:l:<:>::";
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -350,26 +365,26 @@ static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l*/
-/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2,2},
-/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0},
-/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0},
-/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,0},
-/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0},
-/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2,2},
-/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0},
-/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0},
-/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > */
+/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2,2,0,0},
+/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0},
+/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,2,2,2},
+/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,2,0,0},
+/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0},
+/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2,2,0,0},
+/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0},
+/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0},
+/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 };
 
 static const int cmd2type[][2] = {
@@ -402,6 +417,8 @@ static const int opt2type[] = {
 	['j']	= CT_OPT_ANY_NAT,
 	['w']	= CT_OPT_ZONE,
 	['l']	= CT_OPT_LABEL,
+	['<']	= CT_OPT_ADD_LABEL,
+	['>']	= CT_OPT_DEL_LABEL,
 };
 
 static const int opt2family_attr[][2] = {
@@ -425,6 +442,8 @@ static const int opt2attr[] = {
 	['i']	= ATTR_ID,
 	['w']	= ATTR_ZONE,
 	['l']	= ATTR_CONNLABELS,
+	['<']	= ATTR_CONNLABELS,
+	['>']	= ATTR_CONNLABELS,
 };
 
 static char exit_msg[NUMBER_OF_CMD][64] = {
@@ -472,6 +491,11 @@ static const char usage_expectation_parameters[] =
 	"  --mask-src ip\t\tSource mask address\n"
 	"  --mask-dst ip\t\tDestination mask address\n";
 
+static const char usage_update_parameters[] =
+	"Updating parameters and options:\n"
+	"  --label-add label\tAdd label\n"
+	"  --label-del label\tDelete label\n";
+
 static const char usage_parameters[] =
 	"Common parameters and options:\n"
 	"  -s, --orig-src ip\t\tSource address from original direction\n"
@@ -1045,6 +1069,7 @@ usage(char *prog)
 	fprintf(stdout, "\n%s", usage_tables);
 	fprintf(stdout, "\n%s", usage_conntrack_parameters);
 	fprintf(stdout, "\n%s", usage_expectation_parameters);
+	fprintf(stdout, "\n%s", usage_update_parameters);
 	fprintf(stdout, "\n%s\n", usage_parameters);
 }
 
@@ -1349,7 +1374,7 @@ static int print_cb(enum nf_conntrack_msg_type type,
 	if (output_mask & _O_ID)
 		op_flags |= NFCT_OF_ID;
 
-	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags);
+	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
 	printf("%s\n", buf);
 
 	return NFCT_CB_CONTINUE;
@@ -1376,6 +1401,58 @@ static void copy_status(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 	}
 }
 
+static struct nfct_bitmask *xnfct_bitmask_clone(const struct nfct_bitmask *a)
+{
+	struct nfct_bitmask *b = nfct_bitmask_clone(a);
+	if (!b)
+		exit_error(OTHER_PROBLEM, "out of memory");
+	return b;
+}
+
+static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
+{
+	struct nfct_bitmask *ctb, *newmask;
+	unsigned int i;
+
+	if ((options & (CT_OPT_ADD_LABEL|CT_OPT_DEL_LABEL)) == 0)
+		return;
+
+	nfct_copy_attr(tmp, ct, ATTR_CONNLABELS);
+	ctb = (void *) nfct_get_attr(tmp, ATTR_CONNLABELS);
+
+	if (options & CT_OPT_ADD_LABEL) {
+		if (ctb == NULL) {
+			newmask = xnfct_bitmask_clone(tmpl.label_modify);
+			nfct_set_attr(tmp, ATTR_CONNLABELS, newmask);
+			return;
+		}
+
+		for (i = 0; i <= nfct_bitmask_maxbit(ctb); i++) {
+			if (nfct_bitmask_test_bit(tmpl.label_modify, i))
+				nfct_bitmask_set_bit(ctb, i);
+		}
+
+		newmask = xnfct_bitmask_clone(tmpl.label_modify);
+		nfct_set_attr(tmp, ATTR_CONNLABELS_MASK, newmask);
+	} else if (ctb != NULL) {
+		/* CT_OPT_DEL_LABEL */
+		if (tmpl.label_modify == NULL) {
+			newmask = nfct_bitmask_new(0);
+			if (newmask)
+				nfct_set_attr(tmp, ATTR_CONNLABELS, newmask);
+			return;
+		}
+
+		for (i = 0; i <= nfct_bitmask_maxbit(ctb); i++) {
+			if (nfct_bitmask_test_bit(tmpl.label_modify, i))
+				nfct_bitmask_unset_bit(ctb, i);
+		}
+
+		newmask = xnfct_bitmask_clone(tmpl.label_modify);
+		nfct_set_attr(tmp, ATTR_CONNLABELS_MASK, newmask);
+	}
+}
+
 static int update_cb(enum nf_conntrack_msg_type type,
 		     struct nf_conntrack *ct,
 		     void *data)
@@ -1395,6 +1472,9 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	if (options & CT_OPT_TUPLE_REPL && !nfct_cmp(obj, ct, NFCT_CMP_REPL))
 		return NFCT_CB_CONTINUE;
 
+	if (filter_label(ct))
+		return NFCT_CB_CONTINUE;
+
 	tmp = nfct_new();
 	if (tmp == NULL)
 		exit_error(OTHER_PROBLEM, "out of memory");
@@ -1403,6 +1483,7 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	nfct_copy(tmp, obj, NFCT_CP_META);
 	copy_mark(tmp, ct, &tmpl.mark);
 	copy_status(tmp, ct);
+	copy_label(tmp, ct);
 
 	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
 	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK)) {
@@ -2046,18 +2127,39 @@ int main(int argc, char *argv[])
 			tmpl.filter_mark_kernel.mask = tmpl.mark.mask;
 			break;
 		case 'l':
+		case '<':
+		case '>':
 			options |= opt2type[c];
-			char *optarg2 = strdup(optarg);
 
 			labelmap_init();
 
+			if ((options & (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL)) ==
+			    (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL))
+				exit_error(OTHER_PROBLEM, "cannot use --label-add and "
+							"--label-del at the same time");
+
+			if (c == '>') { /* DELETE */
+				char *tmp = get_optional_arg(argc, argv);
+				if (tmp == NULL) /* delete all labels */
+					break;
+				optarg = tmp;
+			}
+
+			char *optarg2 = strdup(optarg);
 			unsigned int max = parse_label_get_max(optarg);
 			struct nfct_bitmask * b = nfct_bitmask_new(max);
+			if (!b)
+				exit_error(OTHER_PROBLEM, "out of memory");
 
 			parse_label(b, optarg2);
 
 			/* join "-l foo -l bar" into single bitmask object */
-			merge_bitmasks(&tmpl.label, b);
+			if (c == 'l') {
+				merge_bitmasks(&tmpl.label, b);
+			} else {
+				merge_bitmasks(&tmpl.label_modify, b);
+			}
+
 			free(optarg2);
 			break;
 		case 'a':
@@ -2216,6 +2318,10 @@ int main(int argc, char *argv[])
 		if (options & CT_OPT_MARK)
 			nfct_set_attr_u32(tmpl.ct, ATTR_MARK, tmpl.mark.value);
 
+		if (options & CT_OPT_ADD_LABEL)
+			nfct_set_attr(tmpl.ct, ATTR_CONNLABELS,
+					xnfct_bitmask_clone(tmpl.label_modify));
+
 		cth = nfct_open(CONNTRACK, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
-- 
1.7.8.6

