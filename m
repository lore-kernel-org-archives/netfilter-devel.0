From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH] libnftnl: tests: Free nftnl_udata_buf before exit
Date: Tue, 17 May 2016 18:00:14 +0200
Message-ID: <1463500816-26155-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:38802 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbcEQQA3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 12:00:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 tests/nft-rule-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index 2f6e35f..dee3530 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -88,6 +88,7 @@ int main(int argc, char *argv[])
 	nftnl_rule_set_data(a, NFTNL_RULE_USERDATA,
 			    nftnl_udata_buf_data(udata),
 			    nftnl_udata_buf_len(udata));
+	nftnl_udata_buf_free(udata);
=20
 	nlh =3D nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, =
1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
