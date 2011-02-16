From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] ip6tables: spacing fixes for -o argument
Date: Wed, 16 Feb 2011 03:18:54 +0100
Message-ID: <1297822737-11204-2-git-send-email-jengelh@medozas.de>
References: <1297822737-11204-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36201 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1BPCTA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:19:00 -0500
In-Reply-To: <1297822737-11204-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For aesthetic consistency, put a space after -o.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 9f0b892..06f570b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -962,7 +962,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 	if (mask[0] == 0)
 		return;
 
-	printf("%s -%c", invert ? " !" : "", letter);
+	printf("%s -%c ", invert ? " !" : "", letter);
 
 	for (i = 0; i < IFNAMSIZ; i++) {
 		if (mask[i] != 0) {
-- 
1.7.1

