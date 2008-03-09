From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/8] Fix indentation in ulogd_inppkt_NFLOG.c
Date: Sun,  9 Mar 2008 23:36:24 +0100
Message-ID: <12051021891100-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57593 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbYCIWgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:31 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Minor indentation fix in ulogd_inppkt_NFLOG.c.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 3f013cc..e0e8554 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -406,7 +406,7 @@ static int start(struct ulogd_pluginstance *upi)
 				    af_ce(upi->config_kset).u.value) < 0) {
 			ulogd_log(ULOGD_ERROR, "unable to force-unbind "
 				  "existing log handler for protocol %d\n",
-			  	  af_ce(upi->config_kset).u.value);
+				  af_ce(upi->config_kset).u.value);
 			goto out_handle;
 		}
 	}
-- 
1.5.4.3

