From: pablo@netfilter.org
Subject: [PATCH 10/14] ipvs: Remove unused variable "cs" from ip_vs_leave function.
Date: Tue,  1 Nov 2011 10:11:32 +0100
Message-ID: <1320138696-28048-11-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net,
	Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>,
	Simon Horman <horms@verge.net.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab1KAJMN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:13 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>

This is to address the following warning during compilation time:

  net/netfilter/ipvs/ip_vs_core.c: In function =E2=80=98ip_vs_leave=E2=80=
=99:
  net/netfilter/ipvs/ip_vs_core.c:532: warning: unused variable =E2=80=98=
cs=E2=80=99

This variable is indeed no longer in use.

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs=
_core.c
index 46a8130..093cc32 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -529,7 +529,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct s=
k_buff *skb,
 	   a cache_bypass connection entry */
 	ipvs =3D net_ipvs(net);
 	if (ipvs->sysctl_cache_bypass && svc->fwmark && unicast) {
-		int ret, cs;
+		int ret;
 		struct ip_vs_conn *cp;
 		unsigned int flags =3D (svc->flags & IP_VS_SVC_F_ONEPACKET &&
 				      iph.protocol =3D=3D IPPROTO_UDP)?
--=20
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
