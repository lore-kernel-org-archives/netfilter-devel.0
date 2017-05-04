From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] List handles of added rules if requested
Date: Thu,  4 May 2017 14:34:21 +0200
Message-ID: <20170504123421.22147-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43869 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750965AbdEDMeg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 08:34:36 -0400
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
 src/mnl.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 295dd84a58406..d5b261aff0aee 100644
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
 
@@ -242,6 +244,31 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
 }
 
+static int mnl_callback(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_rule *nlr;
+
+	if (!handle_output)
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
@@ -271,11 +298,12 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 		if (ret == -1)
 			return -1;
 
-		ret = mnl_cb_run(rcv_buf, ret, 0, portid, NULL, NULL);
+		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &mnl_callback, NULL);
 		/* Continue on error, make sure we get all acknowledgments */
 		if (ret == -1)
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
 
+
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
 		if (ret == -1)
 			return -1;
-- 
2.11.0

