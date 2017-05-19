From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v3] List handles of added rules if requested
Date: Fri, 19 May 2017 13:45:32 +0200
Message-ID: <20170519114532.4484-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54321 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751598AbdESLpq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 07:45:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Being able to retrieve an added rule's handle atomically is a crucial
feature for scripts invoking nft command: Without it, there is no way to
be sure a handle extracted from 'nft list ruleset' command actually
refers to the rule one has added before or that of another process which
ran in between.

Extracting an added rule's handle itself is not an easy task already,
since there is a chance that a given rule is printed differently than
when it was added before. A simple example is port number vs. service
name:

| nft add rule ip t c tcp dport { ssh, 80 } accept

There is no way to make 'nft list ruleset' return the rule just like
this as depending on whether '-nn' was given or not, it either prints
the set as '{ ssh, http }' or '{ 22, 80 }' but never in the mixed form
that was used when adding it.

This patch adds the option to print an identifying string for each added
rule which may be used as single parameter to a later 'nft delete rule'
command. So a simple scripting example looks like this:

| handle=$(nft --echo add rule ip t c counter)
| ...
| nft delete rule $handle

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Introduce --echo flag to turn the feature explicitly on instead of
  reusing --handle option.
- Don't add NLM_F_ECHO to flags if echo_output is not enabled.

Changes since v1:
- Pass NLM_F_ECHO to kernel to leverage already existing reporting
  infrastructure and therefore not require a seperate kernel patch.
- Limit mnl_callback() action to NEWRULE messages - when replacing a
  rule, it would otherwise print the deleted rule as well.
---
 include/nftables.h |  1 +
 src/main.c         | 12 +++++++++++-
 src/mnl.c          | 30 +++++++++++++++++++++++++++++-
 src/netlink.c      | 10 ++++++++--
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 6f541557364ba..d1c2561497c4e 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -29,6 +29,7 @@ extern unsigned int numeric_output;
 extern unsigned int stateless_output;
 extern unsigned int ip2name_output;
 extern unsigned int handle_output;
+extern unsigned int echo_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
diff --git a/src/main.c b/src/main.c
index 1cc8b39ff4ab9..2166f8d94382b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -33,6 +33,7 @@ unsigned int numeric_output;
 unsigned int stateless_output;
 unsigned int ip2name_output;
 unsigned int handle_output;
+unsigned int echo_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
@@ -51,10 +52,11 @@ enum opt_vals {
 	OPT_IP2NAME		= 'N',
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
+	OPT_ECHO		= 'e',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvf:iI:vnsNa"
+#define OPTSTRING	"hvf:iI:vnsNae"
 
 static const struct option options[] = {
 	{
@@ -103,6 +105,10 @@ static const struct option options[] = {
 		.val		= OPT_HANDLE_OUTPUT,
 	},
 	{
+		.name		= "echo",
+		.val		= OPT_ECHO,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -125,6 +131,7 @@ static void show_help(const char *name)
 "  -s, --stateless		Omit stateful information of ruleset.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
+"  -e, --echo			Print added rules.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
@@ -333,6 +340,9 @@ int main(int argc, char * const *argv)
 		case OPT_HANDLE_OUTPUT:
 			handle_output++;
 			break;
+		case OPT_ECHO:
+			echo_output++;
+			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
 		}
diff --git a/src/mnl.c b/src/mnl.c
index 295dd84a58406..9d7efec356cd2 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -26,9 +26,11 @@
 #include <string.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
+#include <inttypes.h>
 #include <errno.h>
 #include <utils.h>
 #include <nftables.h>
+#include <rule.h>
 
 static int seq;
 
@@ -242,6 +244,32 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
 }
 
+static int mnl_callback(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_rule *nlr;
+
+	if (!echo_output ||
+	    NFNL_MSG_TYPE(nlh->nlmsg_type) != NFT_MSG_NEWRULE)
+		return MNL_CB_OK;
+
+	nlr = nftnl_rule_alloc();
+	if (!nlr)
+		memory_allocation_error();
+
+	if (nftnl_rule_nlmsg_parse(nlh, nlr) < 0)
+		goto out_free;
+
+	printf("%s %s %s handle %" PRIu64 "\n",
+	       family2str(nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY)),
+	       nftnl_rule_get_str(nlr, NFTNL_RULE_TABLE),
+	       nftnl_rule_get_str(nlr, NFTNL_RULE_CHAIN),
+	       nftnl_rule_get_u64(nlr, NFTNL_RULE_HANDLE));
+
+out_free:
+	nftnl_rule_free(nlr);
+	return MNL_CB_OK;
+}
+
 int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 {
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
@@ -271,7 +299,7 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 		if (ret == -1)
 			return -1;
 
-		ret = mnl_cb_run(rcv_buf, ret, 0, portid, NULL, NULL);
+		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &mnl_callback, NULL);
 		/* Continue on error, make sure we get all acknowledgments */
 		if (ret == -1)
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
diff --git a/src/netlink.c b/src/netlink.c
index 59e8918d2ba0c..b2df8df1c29b9 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -445,6 +445,9 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx,
 	struct nftnl_rule *nlr;
 	int err;
 
+	if (echo_output)
+		flags |= NLM_F_ECHO;
+
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
 	err = mnl_nft_rule_batch_add(nlr, flags | NLM_F_EXCL, ctx->seqnum);
@@ -461,11 +464,14 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc)
 {
 	struct nftnl_rule *nlr;
-	int err;
+	int flags = 0, err;
+
+	if (echo_output)
+		flags = NLM_F_ECHO;
 
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
-	err = mnl_nft_rule_batch_replace(nlr, 0, ctx->seqnum);
+	err = mnl_nft_rule_batch_replace(nlr, flags, ctx->seqnum);
 	nftnl_rule_free(nlr);
 
 	if (err < 0)
-- 
2.11.0

