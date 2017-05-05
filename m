From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2] List handles of added rules if requested
Date: Fri,  5 May 2017 16:33:23 +0200
Message-ID: <20170505143323.29654-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34003 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751384AbdEEOdh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2017 10:33:37 -0400
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

This patch prints an identifying string for each added rule which may be
used as single parameter to a later 'nft delete rule' command. So a
simple scripting example looks like this:

| handle=$(nft add rule ip t c counter)
| ...
| nft delete rule $handle

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Pass NLM_F_ECHO to kernel to leverage already existing reporting
  infrastructure and therefore not require a seperate kernel patch.
- Limit mnl_callback() action to NEWRULE messages - when replacing a
  rule, it would otherwise print the deleted rule as well.
---
 src/mnl.c     | 30 +++++++++++++++++++++++++++++-
 src/netlink.c |  6 ++++--
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 295dd84a58406..c92d036dcc132 100644
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
+	if (!handle_output ||
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
index 6fbb67da7f76f..7e7261fe1e1d4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -445,9 +445,11 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx,
 	struct nftnl_rule *nlr;
 	int err;
 
+	flags += NLM_F_EXCL | NLM_F_ECHO;
+
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
-	err = mnl_nft_rule_batch_add(nlr, flags | NLM_F_EXCL, ctx->seqnum);
+	err = mnl_nft_rule_batch_add(nlr, flags, ctx->seqnum);
 	nftnl_rule_free(nlr);
 	if (err < 0)
 		netlink_io_error(ctx, &rule->location,
@@ -465,7 +467,7 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
-	err = mnl_nft_rule_batch_replace(nlr, 0, ctx->seqnum);
+	err = mnl_nft_rule_batch_replace(nlr, NLM_F_ECHO, ctx->seqnum);
 	nftnl_rule_free(nlr);
 
 	if (err < 0)
-- 
2.11.0

