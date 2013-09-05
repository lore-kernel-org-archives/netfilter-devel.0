From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/3] conntrack: support multiple -l options
Date: Thu,  5 Sep 2013 11:27:48 +0200
Message-ID: <1378373270-6914-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59812 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763411Ab3IEJ2A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using -l foo -l bar caused the "foo" label to be lost.
Merge multiple -l options so "-l foo,bar" and "-l foo -l bar" have same
effect.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v1:
  retain old -l "foo,bar" syntax
  make of "-l foo -l bar,baz" work

 conntrack.8     |    7 ++++---
 src/conntrack.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 4 deletions(-)

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
index 8da94bf..fe68e42 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1828,6 +1828,31 @@ static void labelmap_init(void)
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
+	}
+
+	nfct_bitmask_destroy(src);
+}
+
 int main(int argc, char *argv[])
 {
 	int c, cmd;
@@ -2030,7 +2055,9 @@ int main(int argc, char *argv[])
 			struct nfct_bitmask * b = nfct_bitmask_new(max);
 
 			parse_label(b, optarg2);
-			tmpl.label = b;
+
+			/* join "-l foo -l bar" into single bitmask object */
+			merge_bitmasks(&tmpl.label, b);
 			free(optarg2);
 			break;
 		case 'a':
-- 
1.7.8.6

