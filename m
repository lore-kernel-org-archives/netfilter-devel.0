From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] CT: add "none" as parameter for --ctevents
Date: Mon, 31 Jan 2011 23:48:56 +0100
Message-ID: <20110131224856.4390.31272.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49675 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab1AaWtE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:49:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows not to deliver any event. This can be useful if you want
no events for some protocols, for example:

iptables -I PREROUTING -t raw -p udp -j CT --ctevents none

Thus, no events for UDP traffic are delivered to user-space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_CT.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 682dd83..e233902 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -68,7 +68,7 @@ static uint32_t ct_parse_events(const struct event_tbl *tbl, unsigned int size,
 	strcpy(str, events);
 	while ((t = strsep(&e, ","))) {
 		for (i = 0; i < size; i++) {
-			if (strcmp(t, tbl[i].name))
+			if (!strcmp(t, "none") || strcmp(t, tbl[i].name))
 				continue;
 			mask |= 1 << tbl[i].event;
 			break;
@@ -87,6 +87,10 @@ static void ct_print_events(const char *pfx, const struct event_tbl *tbl,
 	const char *sep = "";
 	unsigned int i;
 
+	if (mask == 0) {
+		printf("none ");
+		return;
+	}
 	printf("%s ", pfx);
 	for (i = 0; i < size; i++) {
 		if (mask & (1 << tbl[i].event)) {

