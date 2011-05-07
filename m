From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH] Fix reversed logic when implictly loading protocol matches
Date: Sat,  7 May 2011 14:46:54 +0200
Message-ID: <1304772414-17294-1-git-send-email-ljaenicke@innominate.com>
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:57616 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab1EGMrI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 May 2011 08:47:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the protocol module has already been loaded (find_proto()
is succesfull) would but has not yet been activated for this command
(proto_used is not yet set), we have to activate the protocol
specific match for this command.
Without the modification iptables-restore will fail if an
implicitly loaded protocol match is used for the second time.
  ...
  -A somechain -p udp --dport 500 -j ACCEPT
  -A somechain -p udp --dport 4500 -j ACCEPT
  ...
will fail for the "4500" line with '--dport" being an unknown option.

Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
---
 xshared.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xshared.c b/xshared.c
index 404a9f5..87402b4 100644
--- a/xshared.c
+++ b/xshared.c
@@ -92,7 +92,7 @@ static bool should_load_proto(struct iptables_command_state *cs)
 	if (find_proto(cs->protocol, XTF_DONT_LOAD,
 	    cs->options & OPT_NUMERIC, NULL) == NULL)
 		return true;
-	return cs->proto_used;
+	return !cs->proto_used;
 }
 
 struct xtables_match *load_proto(struct iptables_command_state *cs)
-- 
1.7.2.5

