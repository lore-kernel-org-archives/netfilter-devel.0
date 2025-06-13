Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698879E1
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 10:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749810839; cv=none; b=LdY8tkNdUESbtx5I1Cr0S9ii/Xt7rEQIn3wWYuAeHcb6g+rEcuR4BUQuc87niBut556GaITNaL7KnBUcmnap/DTXiOHkIw9Bmv5KTAatuUrQEZtzy0lEHlqRV1s6978zBW2O8Dpez0HqmLKdWxscbWfiUNroy0jiXok3KXV9YtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749810839; c=relaxed/simple;
	bh=cJOst3i6IYAJF250rFlk2gmAxPeGgz8UgkR6+WDwu5c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=alwhrpC34YrcskL3umKNnSLRUeN5hHAu1zHA0heIPa8j2y4z+fqj6iQw0URVDCjD7k3W0345zhlaUbONQyCH6wdOnxU6ay0Wowd+ea0TDNFzGSEWD4zblv1hF9tpZOTvUtB1/8hiy+Nkp6ASU3OjTU+ABM7R6s0FifSsjJM73Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 9F6144526B
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 12:27:54 +0200 (CEST)
From: Christoph Heiss <c.heiss@proxmox.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] conntrack: introduce --labelmap option to specify connlabel.conf path
Date: Fri, 13 Jun 2025 12:27:40 +0200
Message-ID: <20250613102742.409820-1-c.heiss@proxmox.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enables specifying a path to a connlabel.conf to load instead of the
default one at /etc/xtables/connlabel.conf.

nfct_labelmap_new() already allows supplying a custom path to load
labels from, so it just needs to be passed in there.

Signed-off-by: Christoph Heiss <c.heiss@proxmox.com>
---
 conntrack.8         |  7 +++++
 include/conntrack.h |  2 +-
 src/conntrack.c     | 62 +++++++++++++++++++++++++++------------------
 3 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 3b6a15b..2b6da25 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -189,6 +189,13 @@ This option is only available in conjunction with "\-L, \-\-dump",
 Match entries whose labels include those specified as arguments.
 Use multiple \-l options to specify multiple labels that need to be set.
 .TP
+.BI "--labelmap " "PATH"
+Specify the path to a connlabel.conf file to load instead of the default one.
+This option is only available in conjunction with "\-L, \-\-dump", "\-E,
+\-\-event", "\-U \-\-update" or "\-D \-\-delete". Must come before any of
+"\-l, \-\-label", "\-\-label\-add" or "\-\-label\-del", otherwise the argument is
+ignored.
+.TP
 .BI "--label-add " "LABEL"
 Specify the conntrack label to add to the selected conntracks.
 This option is only available in conjunction with "\-I, \-\-create",
diff --git a/include/conntrack.h b/include/conntrack.h
index 6dad4a1..317cab6 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -78,7 +78,7 @@ enum ct_command {
 };
 
 #define NUMBER_OF_CMD   _CT_BIT_MAX
-#define NUMBER_OF_OPT   29
+#define NUMBER_OF_OPT   30
 
 struct nf_conntrack;
 
diff --git a/src/conntrack.c b/src/conntrack.c
index 2d4e864..9850825 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -249,6 +249,9 @@ enum ct_options {
 
 	CT_OPT_REPL_ZONE_BIT	= 28,
 	CT_OPT_REPL_ZONE	= (1 << CT_OPT_REPL_ZONE_BIT),
+
+	CT_OPT_LABELMAP_BIT	= 29,
+	CT_OPT_LABELMAP		= (1 << CT_OPT_LABELMAP_BIT),
 };
 /* If you add a new option, you have to update NUMBER_OF_OPT in conntrack.h */
 
@@ -288,6 +291,7 @@ static const char *optflags[NUMBER_OF_OPT] = {
 	[CT_OPT_DEL_LABEL_BIT]	= "label-del",
 	[CT_OPT_ORIG_ZONE_BIT]	= "orig-zone",
 	[CT_OPT_REPL_ZONE_BIT]	= "reply-zone",
+	[CT_OPT_LABELMAP_BIT]	= "labelmap",
 };
 
 static struct option original_opts[] = {
@@ -330,6 +334,7 @@ static struct option original_opts[] = {
 	{"any-nat", 2, 0, 'j'},
 	{"zone", 1, 0, 'w'},
 	{"label", 1, 0, 'l'},
+	{"labelmap", 1, 0, 'M'},
 	{"label-add", 1, 0, '<'},
 	{"label-del", 2, 0, '>'},
 	{"orig-zone", 1, 0, '('},
@@ -339,7 +344,7 @@ static struct option original_opts[] = {
 
 static const char *getopt_str = ":LIUDGEFAhVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
-				"g::c:b:C::Sj::w:l:<:>::(:):";
+				"g::c:b:C::Sj::w:l:<:>::(:):M:";
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -354,27 +359,27 @@ static const char *getopt_str = ":LIUDGEFAhVs:d:r:q:"
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-			/* s d r q p t u z e [ ] { } a m i f n g o c b j w l < > ( ) */
-	[CT_LIST_BIT]	= {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2,2},
-	[CT_CREATE_BIT]	= {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2},
-	[CT_UPDATE_BIT]	= {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0},
-	[CT_DELETE_BIT]	= {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2},
-	[CT_GET_BIT]	= {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0},
-	[CT_FLUSH_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0},
-	[CT_EVENT_BIT]	= {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2},
-	[CT_VERSION_BIT]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[CT_HELP_BIT]	= {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[EXP_LIST_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0},
-	[EXP_CREATE_BIT]= {1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[EXP_DELETE_BIT]= {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[EXP_GET_BIT]	= {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[EXP_FLUSH_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[EXP_EVENT_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0},
-	[CT_COUNT_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[EXP_COUNT_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[CT_STATS_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[EXP_STATS_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-	[CT_ADD_BIT]	= {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2},
+			/* s d r q p t u z e [ ] { } a m i f n g o c b j w l < > ( ) M */
+	[CT_LIST_BIT]	= {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2,2,2},
+	[CT_CREATE_BIT]	= {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2,0},
+	[CT_UPDATE_BIT]	= {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0,2},
+	[CT_DELETE_BIT]	= {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2,2},
+	[CT_GET_BIT]	= {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0,0},
+	[CT_FLUSH_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]	= {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2},
+	[CT_VERSION_BIT]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]	= {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]= {1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_DELETE_BIT]= {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_GET_BIT]	= {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_FLUSH_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0},
+	[CT_COUNT_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_COUNT_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_STATS_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_STATS_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]	= {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2,0},
 };
 
 static const int cmd2type[][2] = {
@@ -413,6 +418,7 @@ static const int opt2type[] = {
 	['>']	= CT_OPT_DEL_LABEL,
 	['(']	= CT_OPT_ORIG_ZONE,
 	[')']	= CT_OPT_REPL_ZONE,
+	['M']	= CT_OPT_LABELMAP,
 };
 
 static const int opt2maskopt[] = {
@@ -521,7 +527,8 @@ static const char usage_conntrack_parameters[] =
 	"  -e, --event-mask eventmask\t\tEvent mask, eg. NEW,DESTROY\n"
 	"  -z, --zero \t\t\t\tZero counters while listing\n"
 	"  -o, --output type[,...]\t\tOutput format, eg. xml\n"
-	"  -l, --label label[,...]\t\tconntrack labels\n";
+	"  -l, --label label[,...]\t\tconntrack labels\n"
+	"  --labelmap path\t\t\tconnlabel file to use instead of default\n";
 
 static const char usage_expectation_parameters[] =
 	"Expectation parameters and options:\n"
@@ -566,6 +573,7 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
 
 static LIST_HEAD(proto_list);
 
+static char *labelmap_path;
 static struct nfct_labelmap *labelmap;
 static int filter_family;
 
@@ -2756,7 +2764,7 @@ static void labelmap_init(void)
 {
 	if (labelmap)
 		return;
-	labelmap = nfct_labelmap_new(NULL);
+	labelmap = nfct_labelmap_new(labelmap_path);
 	if (!labelmap)
 		perror("nfct_labelmap_new");
 }
@@ -3212,6 +3220,10 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 			socketbuffersize = atol(optarg);
 			options |= CT_OPT_BUFFERSIZE;
 			break;
+		case 'M':
+			labelmap_path = strdup(optarg);
+			options |= CT_OPT_LABELMAP;
+			break;
 		case ':':
 			exit_error(PARAMETER_PROBLEM,
 				   "option `%s' requires an "
@@ -3676,6 +3688,8 @@ try_proc:
 	free_tmpl_objects(&cmd->tmpl);
 	if (labelmap)
 		nfct_labelmap_destroy(labelmap);
+	if (labelmap_path)
+		free(labelmap_path);
 
 	return EXIT_SUCCESS;
 }
-- 
2.49.0


