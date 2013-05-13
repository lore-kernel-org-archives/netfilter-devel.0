From: Florian Westphal <fw@strlen.de>
Subject: =?UTF-8?q?=5BPATCH=5D=20netfilter=3A=20add=20and=20use=20nf=5Fafinfo=20in=20xt=5Faddrtype?=
Date: Mon, 13 May 2013 13:47:31 +0200
Message-ID: <1368445651-6822-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arpad@andrews.hu, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39693 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725Ab3EMLpZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 May 2013 07:45:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

/quote https://bugzilla.netfilter.org/show_bug.cgi?id=3D812 :

When I tried to use in the nat/PREROUTING it messes up the
routing cache even if the rule didn't matched at all.
[..]
If I remove the --limit-iface-in from the non-working scenario, so just
use the -m addrtype --dst-type LOCAL it works!
/unquote

This happens when LOCAL type matching is requested with
--limit-iface-in, and the default route is via the interface the packet
we test arrived on.

Because xt_addrtype uses ip6_route_output, the ipv6 routing
implementation creates an unwanted cached entry, and the packet
won't make it to the real/expected destination.

Silently ignoring --limit-iface-in makes the routing work
but it breaks rule matching (--dst-type LOCAL with limit-iface-in
is supposed to only match if the dst address is configured on
the incoming interface; without --limit-iface-in it will match if
the address is reachable via lo).

AFAIU there are two possible solutions:

a), extend struct nf_afinfo to also register ipv6_chk_addr(), OR
b), revert the commit that moved ipt_addrtype to xt_addrtype,
    and keep the ipv6 code in ip6t_addrtype.

IMO, the latter seems to be preferable, but would be more intrusive.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 As explained earlier, I don't like this approach; IMO the proper solut=
ion
 is to split xt_addrinfo into ipt_addrinfo and ip6t_addrinfo.
 The only downside is that it will create a bit of code duplication due
 to checkentry() functions, but it avoids adding is_local_addr hook
 for the sole purpose of fixing ipv6 xt_addrinfo.

 =C3=81rp=C3=A1d, it would be nice if you could test if this patch
 indeed fixes your problem.

 Pablo, please don't apply yet.
 the patch causes
 net/ipv6/netfilter.c:197:2: warning: passing argument 3 of 'ipv6_chk_a=
ddr' discards qualifiers from pointer target type
 include/net/addrconf.h:66:14: note: expected 'struct net_device *' but=
 argument is of type 'const struct net_device *'

 I can pass a patch for this to davem one net-next is open if
 you agree with this patch.

 include/linux/netfilter.h   |    3 +++
 net/ipv4/netfilter.c        |   12 ++++++++++++
 net/ipv6/netfilter.c        |   11 +++++++++++
 net/netfilter/xt_addrtype.c |   25 ++++++++++++-------------
 4 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0060fde..66f9af0 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -228,6 +228,9 @@ struct nf_afinfo {
 				     struct nf_queue_entry *entry);
 	int		(*reroute)(struct sk_buff *skb,
 				   const struct nf_queue_entry *entry);
+	int		(*is_local_addr)(struct net *net, const void *addr,
+				         const struct net_device *dev,
+					 bool strict);
 	int		route_key_size;
 };
=20
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index c3e0ade..29f2ea9 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -183,6 +183,17 @@ static int nf_ip_route(struct net *net, struct dst=
_entry **dst,
 	return 0;
 }
=20
+static bool
+nf_ip_local_address(struct net *net,
+		     const void *addr,
+		     const struct net_device *dev,
+		     bool strict)
+{
+	/* only ipv6 version is used at this time */
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static const struct nf_afinfo nf_ip_afinfo =3D {
 	.family			=3D AF_INET,
 	.checksum		=3D nf_ip_checksum,
@@ -190,6 +201,7 @@ static const struct nf_afinfo nf_ip_afinfo =3D {
 	.route			=3D nf_ip_route,
 	.saveroute		=3D nf_ip_saveroute,
 	.reroute		=3D nf_ip_reroute,
+	.is_local_addr		=3D nf_ip_local_address,
 	.route_key_size		=3D sizeof(struct ip_rt_info),
 };
=20
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 72836f4..53d009d 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -10,6 +10,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/export.h>
+#include <net/addrconf.h>
 #include <net/dst.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
@@ -186,6 +187,15 @@ static __sum16 nf_ip6_checksum_partial(struct sk_b=
uff *skb, unsigned int hook,
 	return csum;
 };
=20
+static bool
+nf_ip6_local_address(struct net *net,
+		     const void *addr,
+		     const struct net_device *dev,
+		     bool strict)
+{
+	return ipv6_chk_addr(net, addr, dev, strict) !=3D 0;
+}
+
 static const struct nf_afinfo nf_ip6_afinfo =3D {
 	.family			=3D AF_INET6,
 	.checksum		=3D nf_ip6_checksum,
@@ -193,6 +203,7 @@ static const struct nf_afinfo nf_ip6_afinfo =3D {
 	.route			=3D nf_ip6_route,
 	.saveroute		=3D nf_ip6_saveroute,
 	.reroute		=3D nf_ip6_reroute,
+	.is_local_addr		=3D nf_ip6_local_address,
 	.route_key_size		=3D sizeof(struct ip6_rt_info),
 };
=20
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index 49c5ff7..f4f91b4 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -33,28 +33,29 @@ MODULE_ALIAS("ip6t_addrtype");
=20
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static u32 match_lookup_rt6(struct net *net, const struct net_device *=
dev,
-			    const struct in6_addr *addr)
+			    const struct in6_addr *addr, u16 mask)
 {
 	const struct nf_afinfo *afinfo;
-	struct flowi6 flow;
+	struct flowi6 flow =3D { .daddr =3D *addr };
 	struct rt6_info *rt;
-	u32 ret;
+	u32 ret =3D 0;
 	int route_err;
=20
-	memset(&flow, 0, sizeof(flow));
-	flow.daddr =3D *addr;
 	if (dev)
 		flow.flowi6_oif =3D dev->ifindex;
=20
 	rcu_read_lock();
=20
 	afinfo =3D nf_get_afinfo(NFPROTO_IPV6);
-	if (afinfo !=3D NULL)
+	if (afinfo !=3D NULL) {
+		if (dev && (mask & XT_ADDRTYPE_LOCAL) &&
+		    afinfo->is_local_addr(net, addr, dev, true))
+			ret =3D XT_ADDRTYPE_LOCAL;
 		route_err =3D afinfo->route(net, (struct dst_entry **)&rt,
-					flowi6_to_flowi(&flow), !!dev);
-	else
+					  flowi6_to_flowi(&flow), false);
+	} else {
 		route_err =3D 1;
-
+	}
 	rcu_read_unlock();
=20
 	if (route_err)
@@ -62,10 +63,8 @@ static u32 match_lookup_rt6(struct net *net, const s=
truct net_device *dev,
=20
 	if (rt->rt6i_flags & RTF_REJECT)
 		ret =3D XT_ADDRTYPE_UNREACHABLE;
-	else
-		ret =3D 0;
=20
-	if (rt->rt6i_flags & RTF_LOCAL)
+	if (dev =3D=3D NULL && rt->rt6i_flags & RTF_LOCAL)
 		ret |=3D XT_ADDRTYPE_LOCAL;
 	if (rt->rt6i_flags & RTF_ANYCAST)
 		ret |=3D XT_ADDRTYPE_ANYCAST;
@@ -90,7 +89,7 @@ static bool match_type6(struct net *net, const struct=
 net_device *dev,
=20
 	if ((XT_ADDRTYPE_LOCAL | XT_ADDRTYPE_ANYCAST |
 	     XT_ADDRTYPE_UNREACHABLE) & mask)
-		return !!(mask & match_lookup_rt6(net, dev, addr));
+		return !!(mask & match_lookup_rt6(net, dev, addr, mask));
 	return true;
 }
=20
--=20
1.7.8.6

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
