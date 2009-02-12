From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] libxtables: use const for vars holding literals
Date: Thu, 12 Feb 2009 07:19:11 +0100
Message-ID: <1234419553-4147-2-git-send-email-jengelh@medozas.de>
References: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60876 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZBLGTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:19:15 -0500
In-Reply-To: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 6712aac..ae1594a 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -186,8 +186,7 @@ enum xtables_exittype {
 struct xtables_globals
 {
 	unsigned int option_offset;
-	char *program_version;
-	char *program_name;
+	const char *program_name, *program_version;
 	struct option *opts;
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
-- 
1.6.1.2

