From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] chain: fix segfault in 'device' XML parsing
Date: Tue, 13 Oct 2015 09:39:10 +0200
Message-ID: <20151013073910.19469.65757.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38555 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751880AbbJMHjS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2015 03:39:18 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 600F351F21E
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2015 07:39:16 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EunawVCdo3aa for <netfilter-devel@vger.kernel.org>;
	Tue, 13 Oct 2015 09:39:11 +0200 (CEST)
Received: from r2d2.cica.es (r2d2.cica.es [IPv6:2a00:9ac0:c1ca:27::150])
	by smtp.cica.es (Postfix) with ESMTP id 0C54051F215
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2015 09:39:10 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reported by valgrind:
[...]
==14065== Process terminating with default action of signal 11 (SIGSEGV)
==14065==  Access not within mapped region at address 0x0
==14065==    at 0x4C2C022: strlen (vg_replace_strmem.c:454)
==14065==    by 0x4E41A93: nftnl_chain_set_str (chain.c:259)
==14065==    by 0x4E427F7: nftnl_mxml_chain_parse (chain.c:770)
==14065==    by 0x4E48F96: nftnl_ruleset_parse_chains (ruleset.c:314)
==14065==    by 0x4E4959A: nftnl_ruleset_xml_parse_ruleset (ruleset.c:625)
==14065==    by 0x4E4959A: nftnl_ruleset_xml_parse_cmd (ruleset.c:668)
==14065==    by 0x4E4959A: nftnl_ruleset_xml_parse (ruleset.c:706)
==14065==    by 0x4E4959A: nftnl_ruleset_do_parse (ruleset.c:734)
==14065==    by 0x4013C9: test_xml (nft-parsing-test.c:166)
==14065==    by 0x4016F4: execute_test (nft-parsing-test.c:214)
==14065==    by 0x400EBA: main (nft-parsing-test.c:330)
[...]

While at it, fix a bit the coding style.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 8a8e8b8..2b44a31 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -763,10 +763,10 @@ int nftnl_mxml_chain_parse(mxml_node_t *tree, struct nftnl_chain *c,
 			nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY,
 					       policy);
 		}
-		dev = nftnl_mxml_str_parse(tree, "device", MXML_DESCEND_FIRST,
-					 NFTNL_XML_MAND, err);
 
-		if (table != NULL)
+		dev = nftnl_mxml_str_parse(tree, "device", MXML_DESCEND_FIRST,
+					   NFTNL_XML_MAND, err);
+		if (dev != NULL)
 			nftnl_chain_set_str(c, NFTNL_CHAIN_DEV, dev);
 	}
 

