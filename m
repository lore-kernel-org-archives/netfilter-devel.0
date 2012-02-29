From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] Properly NUL-terminate name in nfct_timeout_attr_set
Date: Wed, 29 Feb 2012 08:15:40 +0100
Message-ID: <1330499742-28091-5-git-send-email-jengelh@medozas.de>
References: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48528 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030750Ab2B2HPv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:15:51 -0500
In-Reply-To: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/libnetfilter_cttimeout.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/libnetfilter_cttimeout.c b/src/libnetfilter_cttimeout.c
index 707543a..1f7c63e 100644
--- a/src/libnetfilter_cttimeout.c
+++ b/src/libnetfilter_cttimeout.c
@@ -177,7 +177,8 @@ nfct_timeout_attr_set(struct nfct_timeout *t, uint32_t type, const void *data)
 {
 	switch(type) {
 	case NFCT_TIMEOUT_ATTR_NAME:
-		strncpy(t->name, data, 32);
+		strncpy(t->name, data, sizeof(t->name));
+		t->name[sizeof(t->name)-1] = '\0';
 		break;
 	case NFCT_TIMEOUT_ATTR_L3PROTO:
 		t->l3num = *((uint16_t *) data);
-- 
1.7.7

