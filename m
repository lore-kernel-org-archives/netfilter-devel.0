From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] ipvs: disable inline net_ipvs function with CONFIG_IP_VS not being set
Date: Wed, 25 Mar 2015 10:17:23 +0100
Message-ID: <1427275043-1192-1-git-send-email-zajec5@gmail.com>
References: <1427273637-29151-1-git-send-email-zajec5@gmail.com>
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
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34459 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbCYJRk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 05:17:40 -0400
Received: by wibg7 with SMTP id g7so69525733wib.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 02:17:39 -0700 (PDT)
In-Reply-To: <1427273637-29151-1-git-send-email-zajec5@gmail.com>
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
V2: Disable function totally instead of returning NULL.
---
 include/net/ip_vs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 615b20b..e6f2f2a 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -29,11 +29,13 @@
 #endif
 #include <net/net_namespace.h>		/* Netw namespace */
=20
+#if IS_ENABLED(CONFIG_IP_VS)
 /* Generic access of ipvs struct */
 static inline struct netns_ipvs *net_ipvs(struct net* net)
 {
 	return net->ipvs;
 }
+#endif
=20
 /* Get net ptr from skb in traffic cases
  * use skb_sknet when call is from userland (ioctl or netlink)
--=20
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
