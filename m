From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: `conntrack -L --src-nat --dst-nat` doesn't work with version
 0.9.14
Date: Thu, 10 Jun 2010 14:43:24 +0200
Message-ID: <4C10DDEC.3030404@netfilter.org>
References: <1795331132.150261276129817743.JavaMail.root@tahiti.vyatta.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030605030407000505020901"
Cc: netfilter-devel@vger.kernel.org
To: Mohit Mehta <mohit.mehta@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49504 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780Ab0FJMnf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:43:35 -0400
In-Reply-To: <1795331132.150261276129817743.JavaMail.root@tahiti.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030605030407000505020901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Mohit Mehta wrote:
> Hi Everyone,
> 
> With previous versions of conntrack [for eg. version 0.9.6]; you could list conntrack entries and have them filtered for both source and destination NAT. This was great for looking at all NAT entries at the same time.
> 
> However, it seems that in the current version that doesn't work i.e. you cannot filter entries for both source and destination NAT together. Filtering on either of the two types still works fine. I'm not quite sure about the history of this if any; so can someone point out whether this change was intentional or an oversight?

Could you test if this patch helps?

--------------030605030407000505020901
Content-Type: text/x-patch;
 name="nat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nat.patch"

conntrack: fix `-L --src-nat --dst-nat'

From: Pablo Neira Ayuso <pablo@netfilter.org>

Since > 0.9.6, the conntrack listing with the options --src-nat
and --dst-nat does not work. This patch fixes the problem.

Reported-by: Mohit Mehta <mohit.mehta@vyatta.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index eec3868..7d413c7 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -635,27 +635,23 @@ filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
 	uint32_t ip;
 
 	if (options & CT_OPT_SRC_NAT) {
-		if (!nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT))
-		  	return 1;
-
 		if (nfct_attr_is_set(obj, ATTR_SNAT_IPV4)) {
 			ip = nfct_get_attr_u32(obj, ATTR_SNAT_IPV4);
-			if (ip != nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST))
-				return 1;
-		}
+			if (ip == nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST))
+				return 0;
+		} else if (nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT))
+		  	return 0;
 	}
 	if (options & CT_OPT_DST_NAT) {
-		if (!nfct_getobjopt(ct, NFCT_GOPT_IS_DNAT))
-			return 1;
-
 		if (nfct_attr_is_set(obj, ATTR_DNAT_IPV4)) {
 			ip = nfct_get_attr_u32(obj, ATTR_DNAT_IPV4);
-			if (ip != nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC))
-				return 1;
-		}
+			if (ip == nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC))
+				return 0;
+		} else if (nfct_getobjopt(ct, NFCT_GOPT_IS_DNAT))
+			return 0;
 	}
 
-	return 0;
+	return 1;
 }
 
 static int counter;

--------------030605030407000505020901--
