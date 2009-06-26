From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/10] xtables: warn of missing version identifier in extensions
Date: Fri, 26 Jun 2009 21:19:51 +0200
Message-ID: <1246043992-379-10-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39676 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbZFZTUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:13 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/xtables.c b/xtables.c
index 1ff6e82..41e0b87 100644
--- a/xtables.c
+++ b/xtables.c
@@ -724,6 +724,11 @@ void xtables_register_match(struct xtables_match *me)
 {
 	struct xtables_match **i, *old;
 
+	if (me->version == NULL) {
+		fprintf(stderr, "%s: match %s<%u> is missing a version\n",
+		        xt_params->program_name, me->name, me->revision);
+		exit(1);
+	}
 	if (strcmp(me->version, XTABLES_VERSION) != 0) {
 		fprintf(stderr, "%s: match \"%s\" has version \"%s\", "
 		        "but \"%s\" is required.\n",
@@ -805,6 +810,11 @@ void xtables_register_target(struct xtables_target *me)
 {
 	struct xtables_target *old;
 
+	if (me->version == NULL) {
+		fprintf(stderr, "%s: target %s<%u> is missing a version\n",
+		        xt_params->program_name, me->name, me->revision);
+		exit(1);
+	}
 	if (strcmp(me->version, XTABLES_VERSION) != 0) {
 		fprintf(stderr, "%s: target \"%s\" has version \"%s\", "
 		        "but \"%s\" is required.\n",
-- 
1.6.3.2

