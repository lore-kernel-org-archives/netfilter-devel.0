From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 1/2] iptables: nft-ipv6: Use meta l4proto instead of nexthdr
Date: Mon, 22 Feb 2016 00:22:48 +0530
Message-ID: <2cf9af3607f9af0ee203060ddbaae655b66a1085.1456080369.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34925 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbcBUSx0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Feb 2016 13:53:26 -0500
Received: by mail-pf0-f171.google.com with SMTP id c10so82511438pfc.2
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Feb 2016 10:53:25 -0800 (PST)
Received: from gmail.com ([116.202.36.30])
        by smtp.gmail.com with ESMTPSA id y68sm31427813pfi.6.2016.02.21.10.53.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 21 Feb 2016 10:53:24 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use meta l4proto in place of nexthdr for ipv6 protocols as it is not
necessary that all protocols be next header.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 iptables/nft-ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 0ee7957..bbf289b 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -416,7 +416,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 			snprintf(protonum, sizeof(protonum), "%u",
 				 cs->fw6.ipv6.proto);
 			protonum[sizeof(protonum) - 1] = '\0';
-			xt_xlate_add(xl, "ip6 nexthdr %s%s ",
+			xt_xlate_add(xl, "meta l4proto %s%s ",
 				   cs->fw6.ipv6.invflags & IP6T_INV_PROTO ?
 					"!= " : "",
 				   pent ? pent->p_name : protonum);
-- 
1.9.1

