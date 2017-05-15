From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/2] monitor: Support printing processes which caused the event
Date: Mon, 15 May 2017 16:51:54 +0200
Message-ID: <20170515145154.26189-3-phil@nwl.cc>
References: <20170515145154.26189-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52615 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934555AbdEOOwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 10:52:12 -0400
In-Reply-To: <20170515145154.26189-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support for printing the process ID and name for changes which
'nft monitor' reports:

| nft -a -p monitor
| add chain ip t2 bla3 # pid 11616 (nft)

If '-n' was given in addition to '-p', parsing the process name from
/proc/<pid>/cmdline is suppressed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables.h |  1 +
 src/main.c         | 12 ++++++++-
 src/netlink.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 src/rule.c         |  2 --
 4 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 6f541557364ba..9107b56b26151 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -29,6 +29,7 @@ extern unsigned int numeric_output;
 extern unsigned int stateless_output;
 extern unsigned int ip2name_output;
 extern unsigned int handle_output;
+extern unsigned int pid_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
diff --git a/src/main.c b/src/main.c
index 1cc8b39ff4ab9..670e6791e8877 100644
--- a/src/main.c
+++ b/src/main.c
@@ -33,6 +33,7 @@ unsigned int numeric_output;
 unsigned int stateless_output;
 unsigned int ip2name_output;
 unsigned int handle_output;
+unsigned int pid_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
@@ -51,10 +52,11 @@ enum opt_vals {
 	OPT_IP2NAME		= 'N',
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
+	OPT_PID_OUTPUT		= 'p',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvf:iI:vnsNa"
+#define OPTSTRING	"hvf:iI:vnsNap"
 
 static const struct option options[] = {
 	{
@@ -103,6 +105,10 @@ static const struct option options[] = {
 		.val		= OPT_HANDLE_OUTPUT,
 	},
 	{
+		.name		= "pid",
+		.val		= OPT_PID_OUTPUT,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -125,6 +131,7 @@ static void show_help(const char *name)
 "  -s, --stateless		Omit stateful information of ruleset.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
+"  -p, --pid			Output process information in monitor.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
@@ -333,6 +340,9 @@ int main(int argc, char * const *argv)
 		case OPT_HANDLE_OUTPUT:
 			handle_output++;
 			break;
+		case OPT_PID_OUTPUT:
+			pid_output++;
+			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 7e7261fe1e1d4..baf43ad83edfe 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2068,6 +2068,53 @@ next:
 	nftnl_expr_iter_destroy(nlrei);
 }
 
+struct {
+	unsigned int portid;
+	int pid;
+	char *name;
+} proc_info = { 0 };
+
+static int netlink_events_proc_info_cb(const struct nlmsghdr *nlh, int type,
+				       struct netlink_mon_handler *monh)
+{
+	const struct nlattr *attr;
+
+	proc_info.portid = nlh->nlmsg_pid;
+
+	mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
+		switch (mnl_attr_get_type(attr)) {
+		case NFTA_PROC_NAME:
+			if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+				break;
+			if (proc_info.name)
+				free(proc_info.name);
+			proc_info.name = strdup(mnl_attr_get_string(attr));
+			break;
+		case NFTA_PROC_PID:
+			if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+				break;
+			proc_info.pid = ntohl(mnl_attr_get_u32(attr));
+			break;
+		}
+	}
+	return MNL_CB_OK;
+}
+
+static void print_pid(const struct nlmsghdr *nlh)
+{
+	/* never return outdated info (should not happen) */
+	if (nlh->nlmsg_pid != proc_info.portid)
+		return;
+
+	if (!pid_output)
+		return;
+	printf(" # pid %u", proc_info.pid);
+
+	if (numeric_output)
+		return;
+	printf(" (%s)", proc_info.name);
+}
+
 static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 				   struct netlink_mon_handler *monh)
 {
@@ -2089,8 +2136,10 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 
 		family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
 
-		printf("%s %s\n", family2str(family),
+		printf("%s %s", family2str(family),
 		       nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
+		print_pid(nlh);
+		printf("\n");
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
@@ -2125,12 +2174,16 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 			c = netlink_delinearize_chain(monh->ctx, nlc);
 			chain_print_plain(c);
 			chain_free(c);
+			print_pid(nlh);
+			printf("\n");
 			break;
 		case NFT_MSG_DELCHAIN:
 			family = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
-			printf("delete chain %s %s %s\n", family2str(family),
+			printf("delete chain %s %s %s", family2str(family),
 			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE),
 			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
+			print_pid(nlh);
+			printf("\n");
 			break;
 		}
 		break;
@@ -2170,14 +2223,17 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 			}
 			set_print_plain(set);
 			set_free(set);
+			print_pid(nlh);
 			printf("\n");
 			break;
 		case NFT_MSG_DELSET:
 			family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
-			printf("delete set %s %s %s\n",
+			printf("delete set %s %s %s",
 			       family2str(family),
 			       nftnl_set_get_str(nls, NFTNL_SET_TABLE),
 			       nftnl_set_get_str(nls, NFTNL_SET_NAME));
+			print_pid(nlh);
+			printf("\n");
 			break;
 		}
 		break;
@@ -2257,6 +2313,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		}
 		printf("element %s %s %s ", family2str(family), table, setname);
 		expr_print(dummyset->init);
+		print_pid(nlh);
 		printf("\n");
 
 		set_free(dummyset);
@@ -2294,15 +2351,18 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 			}
 			obj_print_plain(obj);
 			obj_free(obj);
+			print_pid(nlh);
 			printf("\n");
 			break;
 		case NFT_MSG_DELOBJ:
 			family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
-			printf("delete %s %s %s %s\n",
+			printf("delete %s %s %s %s",
 			       obj_type_name(nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE)),
 			       family2str(family),
 			       nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE),
 			       nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
+			print_pid(nlh);
+			printf("\n");
 			break;
 		}
 		break;
@@ -2351,13 +2411,16 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 
 			printf("add rule %s %s %s ", family, table, chain);
 			rule_print(r);
+			print_pid(nlh);
 			printf("\n");
 
 			rule_free(r);
 			break;
 		case NFT_MSG_DELRULE:
-			printf("delete rule %s %s %s handle %u\n",
+			printf("delete rule %s %s %s handle %u",
 			       family, table, chain, (unsigned int)handle);
+			print_pid(nlh);
+			printf("\n");
 			break;
 		}
 		break;
@@ -2880,6 +2943,9 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 		return ret;
 
 	switch (type) {
+	case NFT_MSG_PROC_INFO:
+		ret = netlink_events_proc_info_cb(nlh, type, monh);
+		break;
 	case NFT_MSG_NEWTABLE:
 	case NFT_MSG_DELTABLE:
 		ret = netlink_events_table_cb(nlh, type, monh);
diff --git a/src/rule.c b/src/rule.c
index 209cf2d7d9f60..10095320348eb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -691,8 +691,6 @@ void chain_print_plain(const struct chain *chain)
 		       chain->type, chain->hookstr,
 		       chain->priority, chain_policy2str(chain->policy));
 	}
-
-	printf("\n");
 }
 
 struct table *table_alloc(void)
-- 
2.11.0

