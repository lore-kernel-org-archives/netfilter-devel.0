From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] iptables: fix an inversion
Date: Tue,  1 Mar 2011 15:44:25 +0100
Message-ID: <1298990667-22518-2-git-send-email-jengelh@medozas.de>
References: <1298990667-22518-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46321 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1CAOoa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:44:30 -0500
In-Reply-To: <1298990667-22518-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Revisiting the original condition (viewable in git log -1 -p
v1.4.10-57-gacef604), one can notice an unforuntate inversion. This
commit corrects this.

Testcase: -A INPUT -p tcp --dport 1

Reported-by: Florian Westphal
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xshared.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xshared.c b/xshared.c
index b47beb1..c5a9015 100644
--- a/xshared.c
+++ b/xshared.c
@@ -87,7 +87,7 @@ static bool should_load_proto(struct iptables_command_state *cs)
 	if (cs->protocol == NULL)
 		return false;
 	if (find_proto(cs->protocol, XTF_DONT_LOAD,
-	    cs->options & OPT_NUMERIC, NULL) != NULL)
+	    cs->options & OPT_NUMERIC, NULL) == NULL)
 		return true;
 	return cs->proto_used;
 }
-- 
1.7.1

