From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/6] Parse oob protocol in ULOG when possible.
Date: Sat, 28 Jun 2008 01:02:58 +0200
Message-ID: <1214607780-31389-5-git-send-email-eric@inl.fr>
References: <485FB66A.1090601@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:56491 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764369AbYF0W5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:57:49 -0400
In-Reply-To: <485FB66A.1090601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ULOG API does not provide the value of oob.protocol (hardware protocol).
This patch parses the hardware mac header by using ethernet address packet
structure to go to the value of the field and store it inside the oob.protocol
key.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_ULOG.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 8abaa60..6b0ccc2 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -215,6 +215,14 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
 	}
 
+	if (pkt->mac_len >= 2 * ip->config_kset->ces[4].u.value
+			    + sizeof(uint16_t)) {
+		ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = ntohs(*(uint16_t *)(
+			pkt->mac + 2 *  ip->config_kset->ces[4].u.value));
+	} else
+		ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
+	ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
+
 	ret[ULOG_KEY_RAW_LABEL].u.value.ui8 = ip->config_kset->ces[3].u.value;
 	ret[ULOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
 
@@ -254,9 +262,6 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 	/* ULOG is IPv4 only */
 	ret[ULOG_KEY_OOB_FAMILY].u.value.ui8 = AF_INET;
 	ret[ULOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
-	/* Undef in ULOG but necessary */
-	ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
-	ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
 	ulogd_propagate_results(ip);
 	return 0;
-- 
1.5.4.3

