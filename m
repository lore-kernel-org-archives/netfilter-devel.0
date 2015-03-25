From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ipvs: fix header inline net_ipvs function to work without CONFIG_IP_VS
Date: Wed, 25 Mar 2015 09:53:57 +0100
Message-ID: <1427273637-29151-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34536 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbbCYIyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 04:54:16 -0400
Received: by wgs2 with SMTP id 2so19107668wgs.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 01:54:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Including net/ip_vs.h without CONFIG_IP_VS was causing:
include/net/ip_vs.h: In function 'net_ipvs':
include/net/ip_vs.h:35:12: error: 'struct net' has no member named 'ipv=
s'

=46ixes: 8b4d14d8eb368 ("netns: exclude ipvs from struct net when IPVS =
disabled")
Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
---
 include/net/ip_vs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 615b20b..cd3942f 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -32,7 +32,10 @@
 /* Generic access of ipvs struct */
 static inline struct netns_ipvs *net_ipvs(struct net* net)
 {
+#if IS_ENABLED(CONFIG_IP_VS)
 	return net->ipvs;
+#endif
+	return NULL;
 }
=20
 /* Get net ptr from skb in traffic cases
--=20
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
