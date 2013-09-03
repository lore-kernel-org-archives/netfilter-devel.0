From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3] conntrack: favor multiple -l options over -l foo,bar
Date: Tue,  3 Sep 2013 17:28:41 +0200
Message-ID: <1378222122-29415-2-git-send-email-fw@strlen.de>
References: <1378222122-29415-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54100 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756481Ab3ICP2x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:28:53 -0400
In-Reply-To: <1378222122-29415-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Its more straightforward to use -l foo -l bar when only wanting
to see conntracks that have both labels set.

It also simplifies things a lot.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 conntrack.8     |    7 ++--
 src/conntrack.c |  106 ++++++++++++++++++++++++------------------------------
 2 files changed, 51 insertions(+), 62 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index f273434..6410e5b 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -144,10 +144,11 @@ the MARK value into the ctmark.
 Otherwise, the mask is logically ANDed with the existing mark before the comparision.
 In "--create" mode, the mask is ignored.
 .TP
-.BI "-l, --label " "LABEL,..."
-Specify the conntrack labels.
+.BI "-l, --label " "LABEL"
+Specify a conntrack label.
 This option is only available in conjunction with "-L, --dump" or "-E, --event".
-Match entries whose labels matches at least those specified as arguments.
+Match entries whose labels match at least those specified.
+Use multiple -l commands to specify multiple labels that need to be set.
 .TP
 .BI "-c, --secmark " "SECMARK"
 Specify the conntrack selinux security mark.
diff --git a/src/conntrack.c b/src/conntrack.c
index 2567c08..4548169 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -829,59 +829,6 @@ parse_u32_mask(const char *arg, struct u32_mask *m)
 		m->mask = ~0;
 }
 
-static int
-get_label(char *name)
-{
-	int bit = nfct_labelmap_get_bit(labelmap, name);
-	if (bit < 0)
-		exit_error(PARAMETER_PROBLEM, "unknown label '%s'", name);
-	return bit;
-}
-
-static void
-set_label(struct nfct_bitmask *b, char *name)
-{
-	int bit = get_label(name);
-	nfct_bitmask_set_bit(b, bit);
-}
-
-static unsigned int
-set_max_label(char *name, unsigned int current_max)
-{
-	int bit = get_label(name);
-	if ((unsigned int) bit > current_max)
-		return (unsigned int) bit;
-	return current_max;
-}
-
-static unsigned int
-parse_label_get_max(char *arg)
-{
-	unsigned int max = 0;
-	char *parse;
-
-	while ((parse = strchr(arg, ',')) != NULL) {
-		parse[0] = '\0';
-		max = set_max_label(arg, max);
-		arg = &parse[1];
-	}
-
-	max = set_max_label(arg, max);
-	return max;
-}
-
-static void
-parse_label(struct nfct_bitmask *b, char *arg)
-{
-	char * parse;
-	while ((parse = strchr(arg, ',')) != NULL) {
-		parse[0] = '\0';
-		set_label(b, arg);
-		arg = &parse[1];
-	}
-	set_label(b, arg);
-}
-
 static void
 add_command(unsigned int *cmd, const int newcmd)
 {
@@ -1827,6 +1774,49 @@ static void labelmap_init(void)
 		perror("nfct_labelmap_new");
 }
 
+static void merge_bitmasks(struct nfct_bitmask **current,
+			  struct nfct_bitmask *src)
+{
+	unsigned int i;
+
+	if (*current == NULL) {
+		*current = src;
+		return;
+	}
+
+	/* "current" must be the larger bitmask object */
+	if (nfct_bitmask_maxbit(src) > nfct_bitmask_maxbit(*current)) {
+		struct nfct_bitmask *tmp = *current;
+		*current = src;
+		src = tmp;
+	}
+
+	for (i = 0; i <= nfct_bitmask_maxbit(src); i++) {
+		if (nfct_bitmask_test_bit(src, i))
+			nfct_bitmask_set_bit(*current, i);
+		nfct_bitmask_destroy(src);
+		return;
+	}
+
+	nfct_bitmask_destroy(src);
+}
+
+static struct nfct_bitmask *name_to_bitmask(const char *name)
+{
+	int bit;
+	struct nfct_bitmask *b;
+
+	bit = nfct_labelmap_get_bit(labelmap, name);
+	if (bit < 0)
+		exit_error(PARAMETER_PROBLEM, "unknown label '%s'", name);
+
+	b = nfct_bitmask_new(bit);
+	if (!b)
+		exit_error(OTHER_PROBLEM, "out of memory");
+	nfct_bitmask_set_bit(b, bit);
+	return b;
+}
+
 int main(int argc, char *argv[])
 {
 	int c, cmd;
@@ -2021,16 +2011,14 @@ int main(int argc, char *argv[])
 			break;
 		case 'l':
 			options |= opt2type[c];
-			char *optarg2 = strdup(optarg);
 
 			labelmap_init();
 
-			unsigned int max = parse_label_get_max(optarg);
-			struct nfct_bitmask * b = nfct_bitmask_new(max);
+			struct nfct_bitmask *b;
+			b = name_to_bitmask(optarg);
+			/* join "-l foo -l bar" into single bitmask object */
+			merge_bitmasks(&tmpl.label, b);
 
-			parse_label(b, optarg2);
-			tmpl.label = b;
-			free(optarg2);
 			break;
 		case 'a':
 			fprintf(stderr, "WARNING: ignoring -%c, "
-- 
1.7.8.6

