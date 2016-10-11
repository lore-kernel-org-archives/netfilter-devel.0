From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH ulogd2] ulogd: fix crash when ipv4 packet is truncated
Date: Tue, 11 Oct 2016 22:22:27 +0800
Message-ID: <1476195747-2852-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:43288 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbcJKOYd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 10:24:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If ipv4 packet is truncated, we should not try to dereference the
iph pointer. Otherwise, if the user add such iptables rules
"-j NFLOG --nflog-size 0", we will dereference the NULL pointer
and crash may happen.

Reported-by: Chris Caputo <ccaputo@alt.net>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 Sorry to redeliver this patch, my mail server told me that it failed.

 filter/raw2packet/ulogd_raw2packet_BASE.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 8a6180c..fd2665a 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -717,7 +717,7 @@ static int _interp_iphdr(struct ulogd_pluginstance *pi, uint32_t len)
 	struct ulogd_key *ret = pi->output.keys;
 	struct iphdr *iph =
 		ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]);
-	void *nexthdr = (uint32_t *)iph + iph->ihl;
+	void *nexthdr;
 
 	if (len < sizeof(struct iphdr) || len <= (uint32_t)(iph->ihl * 4))
 		return ULOGD_IRET_OK;
@@ -734,6 +734,7 @@ static int _interp_iphdr(struct ulogd_pluginstance *pi, uint32_t len)
 	okey_set_u16(&ret[KEY_IP_ID], ntohs(iph->id));
 	okey_set_u16(&ret[KEY_IP_FRAGOFF], ntohs(iph->frag_off));
 
+	nexthdr = (uint32_t *)iph + iph->ihl;
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
 		_interp_tcp(pi, nexthdr, len);
-- 
2.5.5


