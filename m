From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [ipset PATCH] Fix wrong bracket placing
Date: Thu, 27 Dec 2012 16:46:29 +0100
Message-ID: <1952176.MYFl3FrgUH@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:48980 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2L0Pqf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 10:46:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

cppcheck (vaguely) reported:
[lib/parse.c:448]: (style) Suspicious condition (assignment + comparison); Clarify expression with parentheses.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 lib/parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/parse.c b/lib/parse.c
index 550048c..d06e9cd 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -445,8 +445,8 @@ ipset_parse_proto(struct ipset_session *session,
 		uint8_t protonum;
 		int err;
 
-		if (!((err = string_to_u8(session, str, &protonum) == 0) &&
-		      (protoent = getprotobynumber(protonum)) != NULL))
+		if (!((err = string_to_u8(session, str, &protonum)) == 0) &&
+		      (protoent = getprotobynumber(protonum)) != NULL)
 			return syntax_err("cannot parse '%s' "
 					  "as a protocol", str);
 	}
-- 
1.7.11.7

