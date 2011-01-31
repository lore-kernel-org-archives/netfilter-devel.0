From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] iptables: remove bogus address-of
Date: Mon, 31 Jan 2011 03:12:51 +0100
Message-ID: <1296439973-16089-7-git-send-email-jengelh@medozas.de>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45285 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab1AaCND (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:13:03 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Casts are bad. &curtable is actually of type char (*)[], which is
quite different from what add_argv expects.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    2 +-
 iptables-restore.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 9948cd6..d8a45da 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -365,7 +365,7 @@ int main(int argc, char *argv[])
 
 			add_argv(argv[0]);
 			add_argv("-t");
-			add_argv((char *) &curtable);
+			add_argv(curtable);
 
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters");
diff --git a/iptables-restore.c b/iptables-restore.c
index 519d480..cd23cfa 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -370,7 +370,7 @@ main(int argc, char *argv[])
 
 			add_argv(argv[0]);
 			add_argv("-t");
-			add_argv((char *) &curtable);
+			add_argv(curtable);
 
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters");
-- 
1.7.1

