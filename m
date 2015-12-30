From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] iptables: nft-ipv6: Replace ip with ip6
Date: Wed, 30 Dec 2015 11:08:08 +0530
Message-ID: <20151230053808.GA3717@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33602 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbbL3FiP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Dec 2015 00:38:15 -0500
Received: by mail-pf0-f172.google.com with SMTP id q63so101266195pfb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 21:38:15 -0800 (PST)
Received: from gmail.com ([223.176.169.75])
        by smtp.gmail.com with ESMTPSA id n64sm86791581pfi.19.2015.12.29.21.38.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 29 Dec 2015 21:38:14 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace ip with ip6 to avoid conflict between the protocols in the
results obtained from ip6tables-translate utility.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Replace protocol with nexthdr

 iptables/nft-ipv6.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 107a84e..0b6ff97 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -416,16 +416,16 @@ static int nft_ipv6_xlate(const void *data, struct xt_buf *buf)
 			snprintf(protonum, sizeof(protonum), "%u",
 				 cs->fw6.ipv6.proto);
 			protonum[sizeof(protonum) - 1] = '\0';
-			xt_buf_add(buf, "ip protocol %s%s ",
+			xt_buf_add(buf, "ip6 nexthdr %s%s ",
 				   cs->fw6.ipv6.invflags & IP6T_INV_PROTO ?
 					"!= " : "",
 				   pent ? pent->p_name : protonum);
 		}
 	}
 
-	xlate_ipv6_addr("ip saddr", &cs->fw6.ipv6.src,
+	xlate_ipv6_addr("ip6 saddr", &cs->fw6.ipv6.src,
 			cs->fw6.ipv6.invflags & IP6T_INV_SRCIP, buf);
-	xlate_ipv6_addr("ip daddr", &cs->fw6.ipv6.dst,
+	xlate_ipv6_addr("ip6 daddr", &cs->fw6.ipv6.dst,
 			cs->fw6.ipv6.invflags & IP6T_INV_DSTIP, buf);
 
 	ret = xlate_matches(cs, buf);
-- 
1.9.1

