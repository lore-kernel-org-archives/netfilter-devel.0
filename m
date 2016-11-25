From: Phil Sutter <phil@nwl.cc>
Subject: [PATCH] extensions: libip6t_ah: Fix translation of plain '-m ah'
Date: Fri, 25 Nov 2016 17:32:39 +0100
Message-ID: <20161125163239.6448-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51806 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932254AbcKYQcw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2016 11:32:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is actually a limitation of ip6tables:

| # ip6tables -A INPUT -p ah -j ACCEPT
| Warning: never matched protocol: ah. use extension match instead.

The working alternative is like so:

| # ip6tables -A INPUT -m ah -j ACCEPT

But upon translating, this statement gets ignored:

| $ ip6tables-translate -A INPUT -m ah -j ACCEPT
| nft add rule ip6 filter INPUT  counter accept

This patch (ab)uses the 'space' variable to check if a parameter to the
'ah' match was present and if not translates the match into an extension
header check:

| $ ip6tables-translate -A INPUT -m ah -j ACCEPT
| add rule ip6 filter INPUT meta l4proto ah counter accept

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_ah.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 5c2fe558ec464..f35982f379d76 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -152,8 +152,13 @@ static int ah_xlate(struct xt_xlate *xl,
 		space = " ";
 	}
 
-	if (ahinfo->hdrres != 0)
+	if (ahinfo->hdrres != 0) {
 		xt_xlate_add(xl, "%sah reserved %u", space, ahinfo->hdrres);
+		space = " ";
+	}
+
+	if (!space[0]) /* plain '-m ah' */
+		xt_xlate_add(xl, "meta l4proto ah");
 
 	return 1;
 }
-- 
2.10.0

