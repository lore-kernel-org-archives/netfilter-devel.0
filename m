From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] examples: nft-rule-parse-add: give batching
 support
Date: Tue, 23 Sep 2014 13:15:26 +0200
Message-ID: <20140923111526.4630.43942.stgit@nfdev.cica.es>
References: <20140923111521.4630.78017.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49756 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754980AbaIWLP2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:15:28 -0400
In-Reply-To: <20140923111521.4630.78017.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add support for current kernels.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-rule-parse-add.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/examples/nft-rule-parse-add.c b/examples/nft-rule-parse-add.c
index 8b6152a..4160435 100644
--- a/examples/nft-rule-parse-add.c
+++ b/examples/nft-rule-parse-add.c
@@ -75,11 +75,12 @@ static struct nft_rule *rule_parse_file(const char *file, uint16_t format)
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
+	struct mnl_nlmsg_batch *batch;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
+	uint32_t portid, seq, rule_seq;
 	struct nft_rule *r;
-	int ret;
+	int ret, batching;
 	uint16_t family, format, outformat;
 
 	if (argc < 3) {
@@ -105,14 +106,33 @@ int main(int argc, char *argv[])
 	nft_rule_fprintf(stdout, r, outformat, 0);
 	fprintf(stdout, "\n");
 
-	family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("Cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
 
 	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	rule_seq = seq;
+	family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
 	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
 				       NLM_F_CREATE|NLM_F_APPEND|NLM_F_ACK,
-				       seq);
+				       seq++);
 	nft_rule_nlmsg_build_payload(nlh, r);
 	nft_rule_free(r);
+	mnl_nlmsg_batch_next(batch);
+
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -126,14 +146,17 @@ int main(int argc, char *argv[])
 	}
 	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+			      mnl_nlmsg_batch_size(batch)) < 0) {
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
 	}
 
+	mnl_nlmsg_batch_stop(batch);
+
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		ret = mnl_cb_run(buf, ret, rule_seq, portid, NULL, NULL);
 		if (ret <= 0)
 			break;
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));

