From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] Fix IPv6 packet parsing.
Date: Fri, 23 May 2008 22:34:07 +0200
Message-ID: <1211574847-14768-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55398 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755434AbYEWUcc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 16:32:32 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Source and destination addresses were put in ptr field of the target structure
instead of being put in the new type ui128. The result was an improper value
of the IPv6 source add destination addresses.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index b1f4113..a5312e4 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -769,9 +769,11 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	if (len < sizeof(struct ip6_hdr))
 		return 0;
 
-	ret[KEY_IP_SADDR].u.value.ptr = &ipv6h->ip6_src;
+	memcpy(ret[KEY_IP_SADDR].u.value.ui128, &ipv6h->ip6_src,
+	       sizeof(ipv6h->ip6_src));
 	ret[KEY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_DADDR].u.value.ptr = &ipv6h->ip6_dst;
+	memcpy(ret[KEY_IP_DADDR].u.value.ui128, &ipv6h->ip6_dst,
+	       sizeof(ipv6h->ip6_dst));
 	ret[KEY_IP_DADDR].flags |= ULOGD_RETF_VALID;
 	ret[KEY_IP6_PAYLOAD_LEN].u.value.ui16 = ntohs(ipv6h->ip6_plen);
 	ret[KEY_IP6_PAYLOAD_LEN].flags |= ULOGD_RETF_VALID;
-- 
1.5.4.3

