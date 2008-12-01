From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 11/18] Fix minor memory leak in NFLOG plugin.
Date: Mon,  1 Dec 2008 22:36:09 +0100
Message-ID: <1228167376-22101-12-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39304 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752505AbYLAVgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:21 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fix a minor memory leak at NFLOG plugin exit.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 9a39234..70e9f77 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -569,6 +569,8 @@ static int stop(struct ulogd_pluginstance *pi)
 	nflog_unbind_group(ui->nful_gh);
 	nflog_close(ui->nful_h);
 
+	free(ui->nfulog_buf);
+
 	return 0;
 }
 
-- 
1.5.6.3

