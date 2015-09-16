From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: fix LIBVERSION, should be 3:0:0 instead of 3:0:3
Date: Wed, 16 Sep 2015 19:46:31 +0200
Message-ID: <1442425591-1776-1-git-send-email-pablo@netfilter.org>
Cc: jengelh@inai.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39968 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbbIPRjx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 13:39:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_rule_expr_build_payload() is gone, so age should have been reset at that
time.

Fixes: 5ea54b224a11 ("expr: seperate expression parsing and building")
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This applies on top on the previous patches to address map file problems for
libnftnl.

Thinking it well, I would like to stick have the release versions used from the
map file, as it is easier to track when symbols were added.

The LIBVERSION should help binaries to catch if they are working with the right
interface version (now libnftnl.so.3), this handles the "interfaces are gone"
case for us.

 Make_global.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Make_global.am b/Make_global.am
index 14ddeef..8f0673c 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=3:0:3
+LIBVERSION=3:0:0

 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
--
1.7.10.4

