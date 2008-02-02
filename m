From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 09/34]  For OPRINT, changed sighup_handler_print to fallback to continue using old descriptor on new file opening failure.
Date: Sat,  2 Feb 2008 22:24:04 +0100
Message-ID: <12019874703136-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46014 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761923AbYBBWPM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:12 -0500
In-Reply-To: <12019874704144-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Based on Marius Tomaschewski work.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 07364b6... 563fc3b... M	output/ulogd_output_OPRINT.c
 output/ulogd_output_OPRINT.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 07364b6..563fc3b 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -118,15 +118,18 @@ static struct config_keyset oprint_kset = {
 static void sighup_handler_print(struct ulogd_pluginstance *upi, int signal)
 {
 	struct oprint_priv *oi = (struct oprint_priv *) &upi->private;
+	FILE *old = oi->of;
 
 	switch (signal) {
 	case SIGHUP:
 		ulogd_log(ULOGD_NOTICE, "OPRINT: reopening logfile\n");
-		fclose(oi->of);
 		oi->of = fopen(upi->config_kset->ces[0].u.string, "a");
 		if (!oi->of) {
 			ulogd_log(ULOGD_ERROR, "can't open PKTLOG: %s\n",
 				strerror(errno));
+			oi->of = old;
+		} else {
+			fclose(old);
 		}
 		break;
 	default:
-- 
1.5.2.5

