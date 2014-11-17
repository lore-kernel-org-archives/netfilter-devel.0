From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] examples: nft-rule-parse-add: fix wrong buffer
 usage when building rule header
Date: Mon, 17 Nov 2014 10:26:41 +0100
Message-ID: <20141117092641.671.15727.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:32908 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751313AbaKQJ0x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:26:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The libmnl helper returns a pointer where to start putting the rule data.

CC: Ian Bishop <ian@pace7.com>
Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=983
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-rule-parse-add.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/examples/nft-rule-parse-add.c b/examples/nft-rule-parse-add.c
index 4160435..75f5268 100644
--- a/examples/nft-rule-parse-add.c
+++ b/examples/nft-rule-parse-add.c
@@ -122,7 +122,8 @@ int main(int argc, char *argv[])
 
 	rule_seq = seq;
 	family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				       NFT_MSG_NEWRULE, family,
 				       NLM_F_CREATE|NLM_F_APPEND|NLM_F_ACK,
 				       seq++);
 	nft_rule_nlmsg_build_payload(nlh, r);

