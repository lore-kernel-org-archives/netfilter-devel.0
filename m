From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 07/34]  Changed sighup_handler_print to fallback to continue using old descriptor on new file opening failure.
Date: Sat,  2 Feb 2008 22:24:02 +0100
Message-ID: <12019874701366-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46054 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762339AbYBBWQj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:39 -0500
In-Reply-To: <12019874701589-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is a backport of Marius Tomaschewski <mt@suse.de> work on ulogd.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 c18aad7... b8d3903... M	output/ulogd_output_LOGEMU.c
 output/ulogd_output_LOGEMU.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index c18aad7..b8d3903 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -114,15 +114,18 @@ static int _output_logemu(struct ulogd_pluginstance *upi)
 static void signal_handler_logemu(struct ulogd_pluginstance *pi, int signal)
 {
 	struct logemu_instance *li = (struct logemu_instance *) &pi->private;
+	FILE *old = li->of;
 
 	switch (signal) {
 	case SIGHUP:
 		ulogd_log(ULOGD_NOTICE, "syslogemu: reopening logfile\n");
-		fclose(li->of);
 		li->of = fopen(pi->config_kset->ces[0].u.string, "a");
 		if (!li->of) {
 			ulogd_log(ULOGD_ERROR, "can't reopen syslogemu: %s\n",
 				  strerror(errno));
+			li->of = old;
+		} else {
+			fclose(old);
 		}
 		break;
 	default:
-- 
1.5.2.5

