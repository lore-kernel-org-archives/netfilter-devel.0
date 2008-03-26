From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/6] Fix typo in error message.
Date: Wed, 26 Mar 2008 23:49:08 +0100
Message-ID: <12065717512028-git-send-email-eric@inl.fr>
References: <12065717514081-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36539 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754050AbYCZWtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:14 -0400
In-Reply-To: <12065717514081-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a typo in an error message.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 ef1c191... 249bde3... M	src/ulogd.c
 src/ulogd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index ef1c191..249bde3 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -163,7 +163,7 @@ int ulogd_key_size(struct ulogd_key *key)
 		ret = key->len;
 		break;
 	default:
-		ulogd_log(ULOGD_ERROR, "don't know sizeo f unknown key "
+		ulogd_log(ULOGD_ERROR, "don't know sizeof unknown key "
 			  "`%s' type 0x%x\n", key->name, key->type);
 		ret = -1;
 		break;
-- 
1.5.2.5

