From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] corrected ROUTE target
Date: 25 Jul 2003 11:43:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059126202.17206.15.camel@descartes>
References: <1056465726.2457.30.camel@descartes>
	 <1058517461.25182.139.camel@descartes>
	 <1058724909.8305.307.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0hTSGAQfXtOcHRBp6n0m"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1058724909.8305.307.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-0hTSGAQfXtOcHRBp6n0m
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h6P9dhb1001916

Le dim 20/07/2003 =E0 20:15, Martin Josefsson a =E9crit :
> > Le mar 24/06/2003 =E0 16:42, Cedric de Launois a =E9crit :
> > > Hi !
> > >=20
> > > Here is a new version of the ROUTE target. Following discussions,
> > > it seems that there is a need to make the ROUTE target also a
> > > non-final target. So I added a new option --force. When not using
> > > this option, the behaviour is to set the route and continue travers=
al.
> > > When using this option, the behaviour is as before, i.e. the packet
> > > is sent and the packet is stolen. This remains useful when we have
> > > to force the use of an interface (rather unfrequent).
>=20
> My concern is that even though this target isn't included in the kernel
> it's a bad idea to change the current behaviour if it can be avoidable.
> I mean this target has existed in pom for quite some time (just over 1
> year) and if the behaviour changes it might make for some surprises for
> its users. Sure the options has changed names over time but that's the
> sort of change that users notice quite easily. A subtle change that
> suddenly continues traversing rules might lead to weird things.
>=20
> It's your target but I'd like you to think about this and maybe rename
> the new option and leave the default as is.

Ok. So here is the ROUTE patch that preserves the old behaviour.
The new option is called --continue. When using it, the packet is routed
and then continues travering the rules. If the option is not used, the
behaviour is as before (i.e. the packet is sent).

The patch is against current cvs.

Cedric


--=-0hTSGAQfXtOcHRBp6n0m
Content-Disposition: attachment; filename=ROUTE.cvs.patch
Content-Type: text/x-patch; name=ROUTE.cvs.patch; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id h6P9dhb1001916

diff -Nru netfilter.orig/patch-o-matic/extra/ROUTE.patch netfilter/patch-=
o-matic/extra/ROUTE.patch
--- netfilter.orig/patch-o-matic/extra/ROUTE.patch	2003-07-25 10:38:03.00=
0000000 +0200
+++ netfilter/patch-o-matic/extra/ROUTE.patch	2003-07-25 11:37:50.0000000=
00 +0200
@@ -1,7 +1,7 @@
 diff -Nru linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h linux/incl=
ude/linux/netfilter_ipv4/ipt_ROUTE.h
---- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	Thu Jan  1 01:00=
:00 1970
-+++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	Tue Dec 17 16:49:04 2=
002
-@@ -0,0 +1,18 @@
+--- linux.orig/include/linux/netfilter_ipv4/ipt_ROUTE.h	1970-01-01 01:00=
:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv4/ipt_ROUTE.h	2003-07-25 11:05:27.0=
00000000 +0200
+@@ -0,0 +1,22 @@
 +/* Header file for iptables ipt_ROUTE target
 + *
 + * (C) 2002 by C=E9dric de Launois <delaunois@info.ucl.ac.be>
@@ -14,23 +14,27 @@
 +#define IPT_ROUTE_IFNAMSIZ 16
 +
 +struct ipt_route_target_info {
-+	char oif[IPT_ROUTE_IFNAMSIZ];
-+	char iif[IPT_ROUTE_IFNAMSIZ];
-+	unsigned int gw;
++	char      oif[IPT_ROUTE_IFNAMSIZ];      /* Output Interface Name */
++	char      iif[IPT_ROUTE_IFNAMSIZ];      /* Input Interface Name  */
++	u_int32_t gw;                           /* IP address of gateway */
++	u_int8_t  flags;
 +};
 +
++/* Values for "flags" field */
++#define IPT_ROUTE_CONTINUE        0x01
++
 +#endif /*_IPT_ROUTE_H_target*/
 diff -Nru linux.orig/net/ipv4/netfilter/ipt_ROUTE.c linux/net/ipv4/netfi=
lter/ipt_ROUTE.c
---- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	Thu Jan  1 01:00:00 1970
-+++ linux/net/ipv4/netfilter/ipt_ROUTE.c	Wed Feb 26 17:25:39 2003
-@@ -0,0 +1,359 @@
+--- linux.orig/net/ipv4/netfilter/ipt_ROUTE.c	1970-01-01 01:00:00.000000=
000 +0100
++++ linux/net/ipv4/netfilter/ipt_ROUTE.c	2003-07-25 11:07:47.000000000 +=
0200
+@@ -0,0 +1,369 @@
 +/*
 + * This implements the ROUTE target, which enables you to setup unusual
 + * routes not supported by the standard kernel routing table.
 + *
 + * Copyright (C) 2002 Cedric de Launois <delaunois@info.ucl.ac.be>
 + *
-+ * v 1.6 2003/02/26
++ * v 1.8 2003/07/25
 + *
 + * This software is distributed under GNU GPL v2, 1991
 + */
@@ -56,7 +60,7 @@
 +/* Try to route the packet according to the routing keys specified in
 + * route_info. Keys are :
 + *  - ifindex :=20
-+ *      0 if no oif prefered,=20
++ *      0 if no oif preferred,=20
 + *      otherwise set to the index of the desired oif
 + *  - route_info->gw :
 + *      0 if no gateway specified,
@@ -88,9 +92,10 @@
 +	if (route_info->gw)
 +		key.dst =3D route_info->gw;
 +=09
-+	/* Trying to route the packet with the standard routing table. */
++	/* Trying to route the packet using the standard routing table. */
 +	if ((err =3D ip_route_output_key(&rt, &key))) {
-+		DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
 +		return -1;
 +	}
 +=09
@@ -101,7 +106,6 @@
 +	/* Success if no oif specified or if the oif correspond to the=20
 +	 * one desired */
 +	if (!ifindex || rt->u.dst.dev->ifindex =3D=3D ifindex) {
-+		/* Drop old route. */
 +		skb->dst =3D &rt->u.dst;
 +		skb->dev =3D skb->dst->dev;
 +		return 1;
@@ -111,8 +115,9 @@
 +	 * specified by the user. This may happen because the dst address
 +	 * is one of our own addresses.
 +	 */
-+	DEBUGP("ipt_ROUTE: failed to route as desired (oif: %i)",=20
-+	       rt->u.dst.dev->ifindex);
++	if (net_ratelimit())=20
++		DEBUGP("ipt_ROUTE: failed to route as desired gw=3D%u.%u.%u.%u oif=3D=
%i (got oif=3D%i)\n",=20
++		       NIPQUAD(route_info->gw), ifindex, rt->u.dst.dev->ifindex);
 +=09
 +	return 0;
 +}
@@ -159,64 +164,69 @@
 +static unsigned int route_oif(const struct ipt_route_target_info *route=
_info,
 +			      struct sk_buff *skb)=20
 +{
-+	int err;
 +	unsigned int ifindex =3D 0;
 +	struct net_device *dev_out =3D NULL;
 +
 +	/* The user set the interface name to use.
 +	 * Getting the current interface index.
 +	 */
-+	if ((dev_out =3D dev_get_by_name(route_info->oif)))
++	if ((dev_out =3D dev_get_by_name(route_info->oif))) {
 +		ifindex =3D dev_out->ifindex;
-+	else=20
++	} else {
 +		/* Unknown interface name : packet dropped */
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: oif interface %s not found\n", route_info->oif);
 +		return NF_DROP;
-+=09
-+	DEBUGP(KERN_DEBUG "oif index of %s is %i\n", route_info->oif, ifindex)=
;
-+
++	}
 +
 +	/* Trying the standard way of routing packets */
-+	err =3D route(skb, ifindex, route_info);
-+	if (err=3D=3D1) {
-+		DEBUGP(KERN_DEBUG "ROUTE oif ok, skb->dev->index=3D%i\n",
-+		       skb->dev->ifindex);
-+
++	switch (route(skb, ifindex, route_info)) {
++	case 1:
 +		dev_put(dev_out);
++		if (route_info->flags & IPT_ROUTE_CONTINUE)
++			return IPT_CONTINUE;
++
 +		ip_direct_send(skb);
 +		return NF_STOLEN;
-+	}
 +
-+	if (err) {
-+		dev_put(dev_out);
-+		return NF_DROP;
-+	}
-+
-+	/* Failed to send to oif. Trying the hard way */
-+
-+	DEBUGP(KERN_DEBUG "HARD ROUTING\n");
++	case 0:
++		/* Failed to send to oif. Trying the hard way */
++		if (route_info->flags & IPT_ROUTE_CONTINUE)
++			return NF_DROP;
 +
-+	/* We have to force the use of an interface.
-+	 * This interface must be a tunnel interface since
-+	 * otherwise we can't guess the hw address for
-+	 * the packet. For a tunnel interface, no hw address
-+	 * is needed.
-+	 */
-+	if ((dev_out->type !=3D ARPHRD_TUNNEL)
-+	    && (dev_out->type !=3D ARPHRD_IPGRE)) {
-+		DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: forcing the use of %i\n",
++			       ifindex);
++
++		/* We have to force the use of an interface.
++		 * This interface must be a tunnel interface since
++		 * otherwise we can't guess the hw address for
++		 * the packet. For a tunnel interface, no hw address
++		 * is needed.
++		 */
++		if ((dev_out->type !=3D ARPHRD_TUNNEL)
++		    && (dev_out->type !=3D ARPHRD_IPGRE)) {
++			if (net_ratelimit())=20
++				DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
++			dev_put(dev_out);
++			return NF_DROP;
++		}
++=09
++		/* Send the packet. This will also free skb
++		 * Do not go through the POST_ROUTING hook because=20
++		 * skb->dst is not set and because it will probably
++		 * get confused by the destination IP address.
++		 */
++		skb->dev =3D dev_out;
++		dev_direct_send(skb);
++		dev_put(dev_out);
++		return NF_STOLEN;
++	=09
++	default:
++		/* Unexpected error */
 +		dev_put(dev_out);
 +		return NF_DROP;
 +	}
-+=09
-+	/* Send the packet. This will also free skb
-+	 * Do not go through the POST_ROUTING hook because=20
-+	 * skb->dst is not set and because it will probably
-+	 * get confused by the destination IP address.
-+	 */
-+	skb->dev =3D dev_out;
-+	dev_direct_send(skb);
-+	dev_put(dev_out);
-+	return NF_STOLEN;
 +}
 +
 +
@@ -229,11 +239,12 @@
 +	/* Getting the current interface index. */
 +	if ((dev_out =3D dev_get_by_name(route_info->iif)))
 +		ifindex =3D dev_out->ifindex;
-+	else=20
++	else {
 +		/* Unknown interface name : packet dropped */
++		if (net_ratelimit())=20
++			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->oif);
 +		return NF_DROP;
-+
-+	DEBUGP(KERN_DEBUG "iif index of %s is %i\n", route_info->iif, ifindex)=
;
++	}
 +
 +	skb->dev =3D dev_out;
 +	dst_release(skb->dst);
@@ -251,11 +262,10 @@
 +	if (route(skb, 0, route_info)!=3D1)
 +		return NF_DROP;
 +
-+	DEBUGP(KERN_DEBUG "ROUTE gw ok, skb->dev->index=3D%i\n",
-+	       skb->dev->ifindex);
++	if (route_info->flags & IPT_ROUTE_CONTINUE)
++		return IPT_CONTINUE;
 +
 +	ip_direct_send(skb);
-+
 +	return NF_STOLEN;
 +}
 +
@@ -308,12 +318,14 @@
 +	 * when a packet is leaving with dst address =3D=3D our address.
 +	 * Good idea ? Dunno. Need advice.
 +	 */
-+	nf_conntrack_put(skb->nfct);
-+	skb->nfct =3D NULL;
-+	skb->nfcache =3D 0;
++	if (!(route_info->flags & IPT_ROUTE_CONTINUE)) {
++		nf_conntrack_put(skb->nfct);
++		skb->nfct =3D NULL;
++		skb->nfcache =3D 0;
 +#ifdef CONFIG_NETFILTER_DEBUG
-+	skb->nf_debug =3D 0;
++		skb->nf_debug =3D 0;
 +#endif
++	}
 +
 +	if (route_info->oif[0])=20
 +		return route_oif(route_info, *pskb);
@@ -324,8 +336,10 @@
 +	if (route_info->gw)=20
 +		return route_gw(route_info, *pskb);
 +
-+	DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
-+	return NF_ACCEPT;
++	if (net_ratelimit())=20
++		DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
++
++	return IPT_CONTINUE;
 +}
 +
 +
diff -Nru netfilter.orig/userspace/extensions/libipt_ROUTE.c netfilter/us=
erspace/extensions/libipt_ROUTE.c
--- netfilter.orig/userspace/extensions/libipt_ROUTE.c	2003-06-24 15:10:1=
2.000000000 +0200
+++ netfilter/userspace/extensions/libipt_ROUTE.c	2003-07-25 11:24:35.000=
000000 +0200
@@ -1,5 +1,6 @@
 /* Shared library add-on to iptables to add ROUTE target support.
- * Author : C=E9dric de Launois, <delaunois@info.ucl.ac.be>
+ * Author : Cedric de Launois, <delaunois@info.ucl.ac.be>
+ * v 1.8 2003/06/24
  */
=20
 #include <stdio.h>
@@ -20,17 +21,20 @@
 {
 	printf(
 "ROUTE target v%s options:\n"
-"  --oif   \tifname \t\tSend the packet out using `ifname' network inter=
face\n"
-"  --iif   \tifname \t\tChange the packet's incoming interface to `ifnam=
e'\n"
-"  --gw    \tip     \t\tRoute the packet via this gateway\n"
+"    --oif   \tifname \t\tRoute the packet through `ifname' network inte=
rface\n"
+"    --iif   \tifname \t\tChange the packet's incoming interface to `ifn=
ame'\n"
+"    --gw    \tip     \t\tRoute the packet via this gateway\n"
+"    --continue\t     \t\tRoute the packet and continue traversing the\n=
"
+"            \t       \t\trules. Not valid with --iif.\n"
 "\n",
-IPTABLES_VERSION);
+"1.8");
 }
=20
 static struct option opts[] =3D {
 	{ "oif", 1, 0, '1' },
 	{ "iif", 1, 0, '2' },
 	{ "gw", 1, 0, '3' },
+	{ "continue", 0, 0, '4' },
 	{ 0 }
 };
=20
@@ -44,11 +48,14 @@
 	route_info->oif[0] =3D '\0';
 	route_info->iif[0] =3D '\0';
 	route_info->gw =3D 0;
+	route_info->flags =3D 0;
 }
=20
=20
-#define IPT_ROUTE_OPT_IF       0x01
-#define IPT_ROUTE_OPT_GW       0x02
+#define IPT_ROUTE_OPT_OIF      0x01
+#define IPT_ROUTE_OPT_IIF      0x02
+#define IPT_ROUTE_OPT_GW       0x04
+#define IPT_ROUTE_OPT_CONTINUE 0x08
=20
 /* Function which parses command options; returns true if it
    ate an option */
@@ -62,9 +69,13 @@
=20
 	switch (c) {
 	case '1':
-		if (*flags & IPT_ROUTE_OPT_IF)
+		if (*flags & IPT_ROUTE_OPT_OIF)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --oif twice or --oif with --iif");
+				   "Can't specify --oif twice");
+
+		if (*flags & IPT_ROUTE_OPT_IIF)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't use --oif and --iif together");
=20
 		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
@@ -76,13 +87,17 @@
 				   sizeof(route_info->oif) - 1);
=20
 		strcpy(route_info->oif, optarg);
-		*flags |=3D IPT_ROUTE_OPT_IF;
+		*flags |=3D IPT_ROUTE_OPT_OIF;
 		break;
=20
 	case '2':
-		if (*flags & IPT_ROUTE_OPT_IF)
+		if (*flags & IPT_ROUTE_OPT_IIF)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify --iif twice or --iif with --oif");
+				   "Can't specify --iif twice");
+
+		if (*flags & IPT_ROUTE_OPT_OIF)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't use --iif and --oif together");
=20
 		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
@@ -94,7 +109,7 @@
 				   sizeof(route_info->iif) - 1);
=20
 		strcpy(route_info->iif, optarg);
-		*flags |=3D IPT_ROUTE_OPT_IF;
+		*flags |=3D IPT_ROUTE_OPT_IIF;
 		break;
=20
 	case '3':
@@ -102,6 +117,10 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --gw twice");
=20
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --gw");
+
 		if (!inet_aton(optarg, (struct in_addr*)&route_info->gw)) {
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid IP address %s",
@@ -111,6 +130,16 @@
 		*flags |=3D IPT_ROUTE_OPT_GW;
 		break;
=20
+	case '4':
+		if (*flags & IPT_ROUTE_OPT_CONTINUE)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --continue twice");
+
+		route_info->flags |=3D IPT_ROUTE_CONTINUE;
+		*flags |=3D IPT_ROUTE_OPT_CONTINUE;
+
+		break;
+
 	default:
 		return 0;
 	}
@@ -124,7 +153,11 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-		           "ROUTE target: one parameter is required");
+		           "ROUTE target: oif, iif or gw option required");
+
+	if ((flags & IPT_ROUTE_OPT_CONTINUE) && (flags & IPT_ROUTE_OPT_IIF))
+		exit_error(PARAMETER_PROBLEM,
+			   "ROUTE target: can't continue traversing the rules with iif option=
");
 }
=20
=20
@@ -140,15 +173,19 @@
 	printf("ROUTE ");
=20
 	if (route_info->oif[0])
-		printf("oif %s ", route_info->oif);
+		printf("oif:%s ", route_info->oif);
=20
 	if (route_info->iif[0])
-		printf("iif %s ", route_info->iif);
+		printf("iif:%s ", route_info->iif);
=20
 	if (route_info->gw) {
 		struct in_addr ip =3D { route_info->gw };
-		printf("gw %s ", inet_ntoa(ip));
+		printf("gw:%s ", inet_ntoa(ip));
 	}
+
+	if (route_info->flags & IPT_ROUTE_CONTINUE)
+		printf("continue");
+
 }
=20
=20
@@ -168,6 +205,9 @@
 		struct in_addr ip =3D { route_info->gw };
 		printf("--gw %s ", inet_ntoa(ip));
 	}
+
+	if (route_info->flags & IPT_ROUTE_CONTINUE)
+		printf("--continue ");
 }
=20
=20

--=-0hTSGAQfXtOcHRBp6n0m--
