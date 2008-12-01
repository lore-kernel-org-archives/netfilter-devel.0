From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 06/18] SCTP support for PRINTPKT.
Date: Mon,  1 Dec 2008 22:36:04 +0100
Message-ID: <1228167376-22101-7-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39300 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752251AbYLAVgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:20 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies PRINTPKT plugin to add SCTP support.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/printpkt.h |    2 ++
 util/printpkt.c          |   17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/ulogd/printpkt.h b/include/ulogd/printpkt.h
index 6207d5b..a11ce4a 100644
--- a/include/ulogd/printpkt.h
+++ b/include/ulogd/printpkt.h
@@ -61,6 +61,8 @@ enum pkt_keys {
 	KEY_ARP_SPA,
 	KEY_ARP_THA,
 	KEY_ARP_TPA,
+	KEY_SCTP_SPORT,
+	KEY_SCTP_DPORT,
 	__PRINTPKT_KEYS
 };
 #define PRINTPKT_KEYS (__PRINTPKT_KEYS)
diff --git a/util/printpkt.c b/util/printpkt.c
index 2292377..5250792 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -102,7 +102,8 @@ struct ulogd_key printpkt_keys[] = {
 	[KEY_ARP_SPA]           = { .name = "arp.saddr.str", },
 	[KEY_ARP_THA]           = { .name = "arp.dhwaddr", },
 	[KEY_ARP_TPA]           = { .name = "arp.daddr.str", },
-
+	[KEY_SCTP_SPORT]	= { .name = "sctp.sport", },
+	[KEY_SCTP_DPORT]	= { .name = "sctp.dport", },
 };
 
 static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
@@ -167,6 +168,18 @@ static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
 				   ikey_get_u16(&res[KEY_UDP_DPORT]), 
 				   ikey_get_u16(&res[KEY_UDP_LEN]));
 		break;
+	case IPPROTO_SCTP:
+		buf_cur += sprintf(buf_cur, "PROTO=SCTP ");
+
+		if (!pp_is_valid(res, KEY_SCTP_SPORT)) {
+			buf_cur += sprintf(buf_cur, "INCOMPLETE");
+			break;
+		}
+
+		buf_cur += sprintf(buf_cur, "SPT=%u DPT=%u ", 
+				   ikey_get_u16(&res[KEY_SCTP_SPORT]),
+				   ikey_get_u16(&res[KEY_SCTP_DPORT]));
+		break;
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 		buf_cur += sprintf(buf_cur, "PROTO=%s ",
@@ -223,6 +236,7 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 	switch (ikey_get_u8(&res[KEY_IP_PROTOCOL])) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 		buf_cur += printpkt_proto(res, buf_cur,
@@ -311,6 +325,7 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 	switch (ikey_get_u8(&res[KEY_IP6_NEXTHDR])) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 		buf_cur += printpkt_proto(res, buf_cur,
-- 
1.5.6.3

