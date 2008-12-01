From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 10/18] Don't free pluginstance when leaving
Date: Mon,  1 Dec 2008 22:36:08 +0100
Message-ID: <1228167376-22101-11-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39316 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbYLAVgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:22 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we free pluginstance in the stop function we won't
be able to iter anymore on the stack linked list.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |    2 --
 input/packet/ulogd_inppkt_ULOG.c  |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index e27355d..9a39234 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -569,8 +569,6 @@ static int stop(struct ulogd_pluginstance *pi)
 	nflog_unbind_group(ui->nful_gh);
 	nflog_close(ui->nful_h);
 
-	free(pi);
-
 	return 0;
 }
 
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 00975de..719898d 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -309,7 +309,6 @@ static int fini(struct ulogd_pluginstance *pi)
 	struct ulog_input *ui = (struct ulog_input *)pi->private;
 
 	ulogd_unregister_fd(&ui->ulog_fd);
-	free(pi);
 
 	return 0;
 }
-- 
1.5.6.3

