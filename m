From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 05/34]  Add --info option which displays information about plugin.
Date: Sat,  2 Feb 2008 22:24:00 +0100
Message-ID: <12019874703998-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46053 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762339AbYBBWQi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:38 -0500
In-Reply-To: <12019874702005-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is difficult to find how to configure a plugin. This patch adds an info
option which can be used to display:
* Name
* Configuration variables
* Input keys
* Output keys

Output exemple:
/opt/ulogd2/sbin/ulogd --info /opt/ulogd2/lib/ulogd/ulogd_filter_IFINDEX.so
Name: IFINDEX
Input keys:
        Key: oob.ifindex_in (unsigned int 32)
        Key: oob.ifindex_out (unsigned int 32)
Output keys:
        Key: oob.in (string)
        Key: oob.out (string)

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 ca5fb06... e1eb951... M	src/ulogd.c
 src/ulogd.c |  141 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 133 insertions(+), 8 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index ca5fb06..e1eb951 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -78,6 +78,8 @@ static char *ulogd_configfile = ULOGD_CONFIGFILE;
 static char *ulogd_logfile = ULOGD_LOGFILE_DEFAULT;
 static FILE syslog_dummy;
 
+static int info_mode = 0;
+
 /* linked list for all registered plugins */
 static LLIST_HEAD(ulogd_plugins);
 static LLIST_HEAD(ulogd_pi_stacks);
@@ -231,21 +233,137 @@ static struct ulogd_plugin *find_plugin(const char *name)
 	return NULL;
 }
 
+char *type_to_string(int type)
+{
+	switch (type) {
+		case ULOGD_RET_INT8:
+			return strdup("int 8");
+			break;
+		case ULOGD_RET_INT16:
+			return strdup("int 16");
+			break;
+		case ULOGD_RET_INT32:
+			return strdup("int 32");
+			break;
+		case ULOGD_RET_INT64:
+			return strdup("int 64");
+			break;
+		case ULOGD_RET_UINT8:
+			return strdup("unsigned int 8");
+			break;
+		case ULOGD_RET_UINT16:
+			return strdup("unsigned int 16");
+			break;
+		case ULOGD_RET_UINT32:
+			return strdup("unsigned int 32");
+			break;
+		case ULOGD_RET_UINT64:
+			return strdup("unsigned int 64");
+			break;
+		case ULOGD_RET_BOOL:
+			return strdup("boolean");
+			break;
+		case ULOGD_RET_IPADDR:
+			return strdup("IPv4 addr");
+			break;
+		case ULOGD_RET_IP6ADDR:
+			return strdup("IPv6 addr");
+			break;
+		case ULOGD_RET_STRING:
+			return strdup("string");
+			break;
+		case ULOGD_RET_RAW:
+			return strdup("raw data");
+			break;
+		default:
+			return strdup("Unknown type");
+	}
+}
+
+
+void get_plugin_infos(struct ulogd_plugin *me)
+{
+	int i;
+	printf("Name: %s\n", me->name);
+	if (me->config_kset) {
+		printf("Config options:\n");
+		for(i = 0; i < me->config_kset->num_ces; i++) {
+			printf("\tVar: %s (", me->config_kset->ces[i].key);
+			switch (me->config_kset->ces[i].type) {
+				case CONFIG_TYPE_STRING:
+					printf("String");
+					printf(", Default: %s", me->config_kset->ces[i].u.value);
+					break;
+				case CONFIG_TYPE_INT:
+					printf("Integer");
+					printf(", Default: %d", me->config_kset->ces[i].u.value);
+					break;
+				case CONFIG_TYPE_CALLBACK:
+					printf("Callback");
+					break;
+				default:
+					printf("Unknown");
+					break;
+			}
+			if (me->config_kset->ces[i].options == CONFIG_OPT_MANDATORY) {
+				printf(", Mandatory");
+			}
+			printf(")\n");
+		}
+	}
+	printf("Input keys:\n");
+	if (me->input.type != ULOGD_DTYPE_SOURCE) {
+		if (me->input.num_keys == 0) {
+			printf("\tNo statically defined keys\n");
+		} else {
+			for(i = 0; i < me->input.num_keys; i++) {
+				char *tstring = type_to_string(me->input.keys[i].type);
+				printf("\tKey: %s (%s)\n",
+				       me->input.keys[i].name,
+				       tstring);
+				free(tstring);
+			}
+		}
+	} else {
+		printf("\tInput plugin, No keys\n");
+	}
+	printf("Output keys:\n");
+	if (me->output.type != ULOGD_DTYPE_SINK) {
+		if (me->output.num_keys == 0) {
+			printf("\tNo statically defined keys\n");
+		} else {
+			for(i = 0; i < me->output.num_keys; i++) {
+				char *tstring = type_to_string(me->output.keys[i].type);
+				printf("\tKey: %s (%s)\n",
+				       me->output.keys[i].name,
+				       tstring);
+				free(tstring);
+			}
+		}
+	} else {
+		printf("\tOutput plugin, No keys\n");
+	}
+}
+
 /* the function called by all plugins for registering themselves */
 void ulogd_register_plugin(struct ulogd_plugin *me)
 {
 	if (strcmp(me->version, ULOGD_VERSION)) { 
 		ulogd_log(ULOGD_NOTICE, "plugin `%s' has incompatible version %s\n",
-			  me->version);
+				me->version);
 		return;
 	}
-	if (find_plugin(me->name)) {
-		ulogd_log(ULOGD_NOTICE, "plugin `%s' already registered\n",
-				me->name);
-		exit(EXIT_FAILURE);
+	if (info_mode == 0) {
+		if (find_plugin(me->name)) {
+			ulogd_log(ULOGD_NOTICE, "plugin `%s' already registered\n",
+					me->name);
+			exit(EXIT_FAILURE);
+		}
+		ulogd_log(ULOGD_NOTICE, "registering plugin `%s'\n", me->name);
+		llist_add(&me->list, &ulogd_plugins);
+	} else {
+		get_plugin_infos(me);
 	}
-	ulogd_log(ULOGD_NOTICE, "registering plugin `%s'\n", me->name);
-	llist_add(&me->list, &ulogd_plugins);
 }
 
 /***********************************************************************
@@ -853,6 +971,7 @@ static void print_usage(void)
 	printf("\t-d --daemon\tDaemonize (fork into background)\n");
 	printf("\t-c --configfile\tUse alternative Configfile\n");
 	printf("\t-u --uid\tChange UID/GID\n");
+	printf("\t-i --info\tDisplay infos about plugin\n");
 }
 
 static struct option opts[] = {
@@ -861,6 +980,7 @@ static struct option opts[] = {
 	{ "help", 0, NULL, 'h' },
 	{ "configfile", 1, NULL, 'c'},
 	{ "uid", 1, NULL, 'u' },
+	{ "info", 1, NULL, 'i'},
 	{ 0 }
 };
 
@@ -875,7 +995,7 @@ int main(int argc, char* argv[])
 	gid_t gid = 0;
 
 
-	while ((argch = getopt_long(argc, argv, "c:dh::Vu:", opts, NULL)) != -1) {
+	while ((argch = getopt_long(argc, argv, "c:dh::Vu:i:", opts, NULL)) != -1) {
 		switch (argch) {
 		default:
 		case '?':
@@ -916,6 +1036,11 @@ int main(int argc, char* argv[])
 			uid = pw->pw_uid;
 			gid = pw->pw_gid;
 			break;
+		case 'i':
+			info_mode = 1;
+			load_plugin(optarg);
+			exit(0);
+			break;
 		}
 	}
 
-- 
1.5.2.5

