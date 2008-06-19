From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 6/6] Suppress verbose debug message in ULOG.
Date: Thu, 19 Jun 2008 14:23:07 +0200
Message-ID: <1213878187-909-7-git-send-email-eric@inl.fr>
References: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60859 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbYFSMXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:23:32 -0400
In-Reply-To: <1213878187-909-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ULOG input plugin was displaying a message for each received packet. This
patch suppress the message.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 97b9972..c00d9bf 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -270,7 +270,6 @@ static int ulog_read_cb(int fd, unsigned int what, void *param)
 		}
 		while ((upkt = ipulog_get_packet(u->libulog_h,
 						 u->libulog_buf, len))) {
-			ulogd_log(ULOGD_DEBUG, "==> ulog packet received\n");
 			/* since we support the re-use of one instance in
 			 * several different stacks, we duplicate the message
 			 * to let them know */
-- 
1.5.5.3

