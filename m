From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 03/14] Fix type of raw.mac_len key in NFLOG.
Date: Sun, 23 Mar 2008 17:25:11 +0100
Message-ID: <12062895222837-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55056 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752963AbYCWQZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:26 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Type of the raw.mac_len key was set to string but this is an unsigned
interger. This patch fix this in the NFLOG module.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 166e048..467d42f 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -209,7 +209,7 @@ static struct ulogd_key output_keys[] = {
 		},
 	},
 	{ 
-		.type = ULOGD_RET_STRING, 
+		.type = ULOGD_RET_UINT16, 
 		.flags = ULOGD_RETF_NONE, 
 		.name = "raw.mac_len", 
 	},
-- 
1.5.2.5

