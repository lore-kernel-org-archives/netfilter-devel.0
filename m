From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] Fix messages and indenting.
Date: Sun,  8 Jun 2008 12:52:53 +0200
Message-ID: <1212922373-7199-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:42262 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756123AbYFHKuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:50:40 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes some messages in the NFCT and NFLOG input
plugin (end of line before quote). It also fixes indenting by
suppressing some spaces on empty line and replacing spaces by tab.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c   |    6 +++---
 input/packet/ulogd_inppkt_NFLOG.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 2a44780..f28e3fa 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -46,7 +46,7 @@
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 typedef enum TIMES_ { START, STOP, __TIME_MAX } TIMES;
- 
+
 struct ct_timestamp {
 	struct timeval time[__TIME_MAX];
 	struct nf_conntrack *ct;
@@ -730,7 +730,7 @@ static int read_cb_nfct(int fd, unsigned int what, void *param)
 					  "We are losing events. Please, "
 					  "consider using the clauses "
 					  "`netlink_socket_buffer_size' and "
-					  "`netlink_socket_buffer_maxsize\n'");
+					  "`netlink_socket_buffer_maxsize'\n");
 			}
 			
 			/* internal hash can deal with refresh */
@@ -919,7 +919,7 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 
 		cpi->ct_active =
 		     hashtable_create(buckets_ce(upi->config_kset).u.value,
-		     		      maxentries_ce(upi->config_kset).u.value,
+				      maxentries_ce(upi->config_kset).u.value,
 				      sizeof(struct ct_timestamp),
 				      hash,
 				      compare);
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 0f26564..8c2aab6 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -434,7 +434,7 @@ static int nful_read_cb(int fd, unsigned int what, void *param)
 					  "We are losing events. Please, "
 					  "consider using the clauses "
 					  "`netlink_socket_buffer_size' and "
-					  "`netlink_socket_buffer_maxsize\n'");
+					  "`netlink_socket_buffer_maxsize'\n");
 			}
 		}
 		return len;
-- 
1.5.4.3

