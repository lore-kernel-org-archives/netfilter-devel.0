From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] audit: export symbol for use with xt_AUDIT
Date: Tue, 18 Jan 2011 16:16:56 +0100
Message-ID: <1295363820-14881-3-git-send-email-jengelh@medozas.de>
References: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40486 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1ARPRI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:17:08 -0500
In-Reply-To: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When xt_AUDIT is built as a module, modpost reports a problem.

	MODPOST 322 modules
	ERROR: "audit_enabled" [net/netfilter/x_tables.ko] undefined!
	WARNING: modpost: Found 1 section mismatch(es).

Cc: Thomas Graf <tgraf@redhat.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 kernel/audit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 77770a0..5842f65 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -74,6 +74,8 @@ static int	audit_initialized;
 int		audit_enabled;
 int		audit_ever_enabled;
 
+EXPORT_SYMBOL_GPL(audit_enabled);
+
 /* Default state when kernel boots without any parameters. */
 static int	audit_default;
 
-- 
1.7.1

