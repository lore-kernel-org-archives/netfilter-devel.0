From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] Fix crash when using NFCT with hash_enable=0.
Date: Wed,  4 Jun 2008 10:38:14 +0200
Message-ID: <1212568694-3980-1-git-send-email-eric@inl.fr>
Cc: regit <regit@ghlodit.inl.fr>
To: pablo@nefilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33088 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752329AbYFDIgo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:36:44 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: regit <regit@ghlodit.inl.fr>

This patch fixes NFCT when hash_enable is 0. Limitation of treatment to NFCT_DESTROY
message type causes usage of the hashtable function and hence a crash because it is
not initiated.

Signed-off-by: regit <regit@ghlodit.inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index dfb58d5..2a44780 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -625,7 +625,7 @@ static int event_handler(enum nf_conntrack_msg_type type,
 		.ct = ct,
 	};
 
-	if (!usehash_ce(upi->config_kset).u.value && type == NFCT_T_DESTROY) {
+	if (!usehash_ce(upi->config_kset).u.value) {
 		switch(type) {
 		case NFCT_T_NEW:
 			gettimeofday(&tmp.time[START], NULL);
-- 
1.5.5.1

