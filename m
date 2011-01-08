From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/13] iptables-restore: resolve confusing policy error message
Date: Sat,  8 Jan 2011 16:20:02 +0100
Message-ID: <1294500015-10691-2-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32879 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1AHPUR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:17 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Rob Leslie <rob@mars.org>

When iptables-restore (and ip6tables-restore) is unable to set a
chain's policy, it responds with a confusing message, e.g.:

iptables-restore v1.4.9: Can't set policy "PREROUTING" on "ACCEPT"
line 16: Bad built-in chain name

This is due to the chain and policy arguments being used in the wrong
order. The attached patch corrects this problem.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    2 +-
 iptables-restore.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 008566c..cea5f36 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -312,7 +312,7 @@ int main(int argc, char *argv[])
 					xtables_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
-						chain, policy, line,
+						policy, chain, line,
 						ip6tc_strerror(errno));
 			}
 
diff --git a/iptables-restore.c b/iptables-restore.c
index 8c6648e..bf80e78 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -317,7 +317,7 @@ main(int argc, char *argv[])
 					xtables_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
-						chain, policy, line,
+						policy, chain, line,
 						iptc_strerror(errno));
 			}
 
-- 
1.7.1

