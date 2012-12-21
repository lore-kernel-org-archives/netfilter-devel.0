From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/3] Fix parsing of ipv6 flowlabel and tc fields
Date: Fri, 21 Dec 2012 15:01:51 +0100
Message-ID: <1356098513-18684-2-git-send-email-eric@regit.org>
References: <1356098513-18684-1-git-send-email-eric@regit.org>
Cc: Bob Hockney <zeus@ix.netcom.com>, Eric Leblond <eric@regit.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:46337 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2LUOCx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:02:53 -0500
In-Reply-To: <1356098513-18684-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Bob Hockney <zeus@ix.netcom.com>

Mask should be applied after ntohl conversion.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index d0fcdfa..05141b8 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -784,9 +784,9 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	okey_set_u128(&ret[KEY_IP_DADDR], &ipv6h->ip6_dst);
 	okey_set_u16(&ret[KEY_IP6_PAYLOAD_LEN], ntohs(ipv6h->ip6_plen));
 	okey_set_u8(&ret[KEY_IP6_PRIORITY],
-		    ntohl(ipv6h->ip6_flow & 0x0ff00000) >> 20);
+		    (ntohl(ipv6h->ip6_flow) & 0x0ff00000) >> 20);
 	okey_set_u32(&ret[KEY_IP6_FLOWLABEL],
-		     ntohl(ipv6h->ip6_flow & 0x000fffff));
+		     ntohl(ipv6h->ip6_flow) & 0x000fffff);
 	okey_set_u8(&ret[KEY_IP6_HOPLIMIT], ipv6h->ip6_hlim);
 
 	curhdr = ipv6h->ip6_nxt;
-- 
1.7.10.4

