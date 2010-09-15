From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] iptables-xml: resolve compiler warnings
Date: Wed, 15 Sep 2010 20:53:44 +0200
Message-ID: <1284576828-32412-2-git-send-email-jengelh@medozas.de>
References: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46817 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab0IOSxy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:54 -0400
In-Reply-To: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables-xml.c: In function "parse_counters":
iptables-xml.c:70:8: warning: assignment from incompatible pointer type
iptables-xml.c:71:8: warning: assignment from incompatible pointer type

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables-xml.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/iptables-xml.c b/iptables-xml.c
index daf4208..32d996a 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -64,7 +64,7 @@ print_usage(const char *name, const char *version)
 static int
 parse_counters(char *string, struct ipt_counters *ctr)
 {
-	u_int64_t *pcnt, *bcnt;
+	__u64 *pcnt, *bcnt;
 
 	if (string != NULL) {
 		pcnt = &ctr->pcnt;
-- 
1.7.1

