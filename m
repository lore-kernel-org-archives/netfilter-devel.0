From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] set_elem: parse family from Netlink message
Date: Sat, 05 Apr 2014 18:38:29 +0200
Message-ID: <20140405163829.7898.54224.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45611 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753102AbaDEQif (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2014 12:38:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lets obtain the family from the Netlink message.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/set_elem.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index b71a916..a747ba6 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -358,6 +358,9 @@ int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
         if (tb[NFTA_SET_ELEM_LIST_ELEMENTS])
 	 	ret = nft_set_elems_parse(s, tb[NFTA_SET_ELEM_LIST_ELEMENTS]);
 
+	s->family = nfg->nfgen_family;
+	s->flags |= (1 << NFT_SET_ATTR_FAMILY);
+
 	return ret;
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_parse);

