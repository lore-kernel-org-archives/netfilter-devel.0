From: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrack: introduce -l option to filter by labels
Date: Fri, 19 Jul 2013 16:32:43 +0200
Message-ID: <1374244363-5385-1-git-send-email-fw@strlen.de>
Cc: Clemence Faure <clemence.faure@sophos.com>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40870 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab3GSObI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:31:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Clemence Faure <clemence.faure@sophos.com>

Signed-off-by: Clemence Faure <clemence.faure@sophos.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I've tested this patch and will apply it soon if noone objects.

 conntrack.8         |    5 ++
 include/conntrack.h |    2 +-
 src/conntrack.c     |  156 ++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 137 insertions(+), 26 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index d80a778..87bf5c0 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -144,6 +144,11 @@ the MARK value into the ctmark.
 Otherwise, the mask is logically ANDed with the existing mark before the comparision.
 In "--create" mode, the mask is ignored.
 .TP
+.BI "-l, --label " "LABEL,..."
+Specify the conntrack labels.
+This option is only available in conjunctions with "-L, --dump" or "-E, --event".
+Match entries whose labels matches at least those specified as arguments.
+.TP
 .BI "-c, --secmark " "SECMARK"
 Specify the conntrack selinux security mark.
 .TP
diff --git a/include/conntrack.h b/include/conntrack.h
index fd6126b..6cd9962 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -10,7 +10,7 @@
 #include <netinet/in.h>
 
 #define NUMBER_OF_CMD   19
-#define NUMBER_OF_OPT   24
+#define NUMBER_OF_OPT   25
 
 struct ctproto_handler {
 	struct list_head 	head;
diff --git a/src/conntrack.c b/src/conntrack.c
index 61e2fce..ec3ef57 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -79,6 +79,9 @@ static struct {
 
 	/* Allow to filter by mark from kernel-space. */
 	struct nfct_filter_dump_mark filter_mark_kernel;
+
+	/* Allows filtering/setting specific bits in the ctlabel */
+	struct nfct_bitmask *label;
 } tmpl;
 
 static int alloc_tmpl_objects(void)
@@ -104,6 +107,8 @@ static void free_tmpl_objects(void)
 		nfct_destroy(tmpl.mask);
 	if (tmpl.exp)
 		nfexp_destroy(tmpl.exp);
+	if (tmpl.label)
+		nfct_bitmask_destroy(tmpl.label);
 }
 
 enum ct_command {
@@ -247,13 +252,16 @@ enum ct_options {
 
 	CT_OPT_ZONE_BIT		= 23,
 	CT_OPT_ZONE		= (1 << CT_OPT_ZONE_BIT),
+
+	CT_OPT_LABEL_BIT	= 24,
+	CT_OPT_LABEL		= (1 << CT_OPT_LABEL_BIT),
 };
 /* If you add a new option, you have to update NUMBER_OF_OPT in conntrack.h */
 
 /* Update this mask to allow to filter based on new options. */
 #define CT_COMPARISON (CT_OPT_PROTO | CT_OPT_ORIG | CT_OPT_REPL | \
 		       CT_OPT_MARK | CT_OPT_SECMARK |  CT_OPT_STATUS | \
-		       CT_OPT_ID | CT_OPT_ZONE)
+		       CT_OPT_ID | CT_OPT_ZONE | CT_OPT_LABEL)
 
 static const char *optflags[NUMBER_OF_OPT] = {
 	[CT_OPT_ORIG_SRC_BIT] 	= "src",
@@ -280,6 +288,7 @@ static const char *optflags[NUMBER_OF_OPT] = {
 	[CT_OPT_BUFFERSIZE_BIT]	= "buffer-size",
 	[CT_OPT_ANY_NAT_BIT]	= "any-nat",
 	[CT_OPT_ZONE_BIT]	= "zone",
+	[CT_OPT_LABEL_BIT]	= "label",
 };
 
 static struct option original_opts[] = {
@@ -320,12 +329,13 @@ static struct option original_opts[] = {
 	{"buffer-size", 1, 0, 'b'},
 	{"any-nat", 2, 0, 'j'},
 	{"zone", 1, 0, 'w'},
+	{"label", 1, 0, 'l'},
 	{0, 0, 0, 0}
 };
 
 static const char *getopt_str = "L::I::U::D::G::E::F::hVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
-				"g::c:b:C::Sj::w:";
+				"g::c:b:C::Sj::w:l:";
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -340,26 +350,26 @@ static const char *getopt_str = "L::I::U::D::G::E::F::hVs:d:r:q:"
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w*/
-/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2},
-/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2},
-/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0},
-/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2},
-/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0},
-/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2},
-/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0},
-/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0},
-/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l*/
+/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2,2},
+/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0},
+/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0},
+/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,0},
+/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0},
+/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2,2},
+/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0},
+/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0},
+/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 };
 
 static const int cmd2type[][2] = {
@@ -391,6 +401,7 @@ static const int opt2type[] = {
 	['i']	= CT_OPT_ID,
 	['j']	= CT_OPT_ANY_NAT,
 	['w']	= CT_OPT_ZONE,
+	['l']	= CT_OPT_LABEL,
 };
 
 static const int opt2family_attr[][2] = {
@@ -413,6 +424,7 @@ static const int opt2attr[] = {
 	['c']	= ATTR_SECMARK,
 	['i']	= ATTR_ID,
 	['w']	= ATTR_ZONE,
+	['l']	= ATTR_CONNLABELS,
 };
 
 static char exit_msg[NUMBER_OF_CMD][64] = {
@@ -450,7 +462,8 @@ static const char usage_conntrack_parameters[] =
 	"  -c, --secmark secmark\t\t\tSet selinux secmark\n"
 	"  -e, --event-mask eventmask\t\tEvent mask, eg. NEW,DESTROY\n"
 	"  -z, --zero \t\t\t\tZero counters while listing\n"
-	"  -o, --output type[,...]\t\tOutput format, eg. xml\n";
+	"  -o, --output type[,...]\t\tOutput format, eg. xml\n"
+	"  -l, --label label\t\tSet label\n";
 
 static const char usage_expectation_parameters[] =
 	"Expectation parameters and options:\n"
@@ -816,6 +829,59 @@ parse_u32_mask(const char *arg, struct u32_mask *m)
 		m->mask = ~0;
 }
 
+static int
+get_label(char *name)
+{
+	int bit = nfct_labelmap_get_bit(labelmap, name);
+	if (bit < 0)
+		exit_error(PARAMETER_PROBLEM, "unknown label '%s'", name);
+	return bit;
+}
+
+static void
+set_label(struct nfct_bitmask *b, char *name)
+{
+	int bit = get_label(name);
+	nfct_bitmask_set_bit(b, bit);
+}
+
+static unsigned int
+set_max_label(char *name, unsigned int current_max)
+{
+	int bit = get_label(name);
+	if ((unsigned int) bit > current_max)
+		return (unsigned int) bit;
+	return current_max;
+}
+
+static unsigned int
+parse_label_get_max(char *arg)
+{
+	unsigned int max = 0;
+	char *parse;
+
+	while ((parse = strchr(arg, ',')) != NULL) {
+		parse[0] = '\0';
+		max = set_max_label(arg, max);
+		arg = &parse[1];
+	}
+
+	max = set_max_label(arg, max);
+	return max;
+}
+
+static void
+parse_label(struct nfct_bitmask *b, char *arg)
+{
+	char * parse;
+	while ((parse = strchr(arg, ',')) != NULL) {
+		parse[0] = '\0';
+		set_label(b, arg);
+		arg = &parse[1];
+	}
+	set_label(b, arg);
+}
+
 static void
 add_command(unsigned int *cmd, const int newcmd)
 {
@@ -984,6 +1050,24 @@ usage(char *prog)
 
 static unsigned int output_mask;
 
+static int
+filter_label(const struct nf_conntrack *ct)
+{
+	if (tmpl.label == NULL)
+		return 0;
+
+	const struct nfct_bitmask *ctb = nfct_get_attr(ct, ATTR_CONNLABELS);
+	if (ctb == NULL)
+		return 1;
+
+	for(unsigned int i = 0; i <= nfct_bitmask_maxbit(tmpl.label); i++) {
+		if (nfct_bitmask_test_bit(tmpl.label, i)
+			  && !nfct_bitmask_test_bit(ctb, i))
+				return 1;
+	}
+
+	return 0;
+}
 
 static int
 filter_mark(const struct nf_conntrack *ct)
@@ -994,7 +1078,6 @@ filter_mark(const struct nf_conntrack *ct)
 	return 0;
 }
 
-
 static int 
 filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
 {
@@ -1125,6 +1208,9 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	if (filter_mark(ct))
 		return NFCT_CB_CONTINUE;
 
+	if (filter_label(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1177,6 +1263,9 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	if (filter_mark(ct))
 		return NFCT_CB_CONTINUE;
 
+	if (filter_label(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1882,7 +1971,8 @@ int main(int argc, char *argv[])
 			options |= CT_OPT_OUTPUT;
 			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
 			if (output_mask & _O_CL) {
-				labelmap = nfct_labelmap_new(NULL);
+				if (!labelmap)
+					labelmap = nfct_labelmap_new(NULL);
 				if (!labelmap)
 					perror("nfct_labelmap_new");
 			}
@@ -1929,6 +2019,22 @@ int main(int argc, char *argv[])
 			tmpl.filter_mark_kernel.val = tmpl.mark.value;
 			tmpl.filter_mark_kernel.mask = tmpl.mark.mask;
 			break;
+		case 'l':
+			options |= opt2type[c];
+			char *optarg2 = strdup(optarg);
+
+			if (!labelmap)
+				labelmap = nfct_labelmap_new(NULL);
+			if (!labelmap)
+				exit_error(OTHER_PROBLEM, "unable to open labelmap file");
+
+			unsigned int max = parse_label_get_max(optarg);
+			struct nfct_bitmask * b = nfct_bitmask_new(max);
+
+			parse_label(b, optarg2);
+			tmpl.label = b;
+			free(optarg2);
+			break;
 		case 'a':
 			fprintf(stderr, "WARNING: ignoring -%c, "
 					"deprecated option.\n", c);
-- 
1.7.8.6

