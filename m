From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 6/8] Duplicate message to all existing instance of NFLOG.
Date: Sun,  9 Mar 2008 23:36:27 +0100
Message-ID: <1205102190176-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57599 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753349AbYCIWgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:32 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A specific instance of NFLOG can now be use in multiple stacks. This is done
by duplicating the interpretation of the message.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index e0e8554..166e048 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -370,7 +370,15 @@ static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 		  struct nflog_data *nfa, void *data)
 {
 	struct ulogd_pluginstance *upi = data;
-
+	struct ulogd_pluginstance *npi = NULL;
+	int ret = 0;
+
+	/* ok let's feed the bird (other instance) */
+	llist_for_each_entry(npi, &upi->plist, plist) {
+		ret = interp_packet(npi, nfa);
+		if (ret != 0)
+			return ret;
+	}
 	return interp_packet(upi, nfa);
 }
 
-- 
1.5.4.3

