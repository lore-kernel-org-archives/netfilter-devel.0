From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 7/9] Add a lacking newline in buffer overrun messages.
Date: Tue, 20 May 2008 00:31:33 +0200
Message-ID: <1211236295-30207-8-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38772 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752835AbYESWah (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:37 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c   |    4 ++--
 input/packet/ulogd_inppkt_NFLOG.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 20d0da1..e99f41a 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -699,7 +699,7 @@ static int setnlbufsiz(struct ulogd_pluginstance *upi, int size)
 				"reached. Please, consider rising "
 				"`netlink_socket_buffer_size` and "
 				"`netlink_socket_buffer_maxsize` "
-				"clauses.", cpi->nlbufsiz);
+				"clauses.\n", cpi->nlbufsiz);
 	return 0;
 }
 
@@ -730,7 +730,7 @@ static int read_cb_nfct(int fd, unsigned int what, void *param)
 					  "We are losing events. Please, "
 					  "consider using the clauses "
 					  "`netlink_socket_buffer_size' and "
-					  "`netlink_socket_buffer_maxsize'");
+					  "`netlink_socket_buffer_maxsize'\n");
 			}
 
 			nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 8d08bd8..8c2aab6 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -401,7 +401,7 @@ static int setnlbufsiz(struct ulogd_pluginstance *upi, int size)
 				"reached. Please, consider rising "
 				"`netlink_socket_buffer_size` and "
 				"`netlink_socket_buffer_maxsize` "
-				"clauses.", ui->nlbufsiz);
+				"clauses.\n", ui->nlbufsiz);
 	return 0;
 }
 
@@ -434,7 +434,7 @@ static int nful_read_cb(int fd, unsigned int what, void *param)
 					  "We are losing events. Please, "
 					  "consider using the clauses "
 					  "`netlink_socket_buffer_size' and "
-					  "`netlink_socket_buffer_maxsize'");
+					  "`netlink_socket_buffer_maxsize'\n");
 			}
 		}
 		return len;
-- 
1.5.4.3

