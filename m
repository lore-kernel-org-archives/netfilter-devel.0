From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] libxtables: set clone's initial data to NULL
Date: Sun, 10 Jul 2011 20:22:16 +0200
Message-ID: <1310322139-28505-5-git-send-email-jengelh@medozas.de>
References: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58438 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1GJSWZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:22:25 -0400
In-Reply-To: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid a crash in xs_init_match when a clone's m->udata points at the
parent.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/xtables.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index b05df97..1a5e568 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -632,6 +632,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 			/* Second and subsequent clones */
 			clone = xtables_malloc(sizeof(struct xtables_match));
 			memcpy(clone, ptr, sizeof(struct xtables_match));
+			clone->udata = NULL;
 			clone->mflags = 0;
 			/* This is a clone: */
 			clone->next = clone;
-- 
1.7.3.4

