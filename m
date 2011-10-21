From: Simon Horman <horms@verge.net.au>
Subject: [PATCH 1/2] ipvs: Remove unused variable "cs" from ip_vs_leave function.
Date: Fri, 21 Oct 2011 10:33:02 +0900
Message-ID: <1319160783-28422-2-git-send-email-horms@verge.net.au>
References: <1319160783-28422-1-git-send-email-horms@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Wensong Zhang <wensong@linux-vs.org>,
	Julian Anastasov <ja@ssi.bg>,
	Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>,
	Simon Horman <horms@verge.net.au>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:39787 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1JUBdJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Oct 2011 21:33:09 -0400
In-Reply-To: <1319160783-28422-1-git-send-email-horms@verge.net.au>
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
1.7.6.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
