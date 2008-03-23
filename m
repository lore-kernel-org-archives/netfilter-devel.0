From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 04/14] Fix type of raw.mac_len key in ULOG.
Date: Sun, 23 Mar 2008 17:25:12 +0100
Message-ID: <12062895221619-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55058 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbYCWQZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:26 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Type of the raw.mac_len key was set to string but this is an unsigned
interger. This patch fix this in the ULOG module.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index c49345d..a1d52f2 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -143,7 +143,7 @@ static struct ulogd_key output_keys[] = {
 		.name = "oob.out", 
 	},
 	{ 
-		.type = ULOGD_RET_STRING, 
+		.type = ULOGD_RET_UINT16, 
 		.flags = ULOGD_RETF_NONE, 
 		.name = "raw.mac_len", 
 	},
-- 
1.5.2.5

