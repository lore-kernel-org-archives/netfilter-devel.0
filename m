From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: OSF update: netlink logging
Date: 16 Jan 2004 18:39:59 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074267599.7519.49.camel@uganda>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e6IWDtRZG5zgB7ISL5CW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-e6IWDtRZG5zgB7ISL5CW
Content-Type: multipart/mixed; boundary="=-YmCaBrjB1OvQBUc8YPwI"


--=-YmCaBrjB1OvQBUc8YPwI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello, Harald.
Hello, all.

This patches add possibility to log OSF events through netlink.
I've stolen NETLINK_NFLOG and mcast group 1 in OSF module from ipt_ULOG,
so you can't use ipt_ULOG and ipt_osf at the same time(or you will catch
some unusal events in ulogd/osfd).
Patchset also adds missing diffs for

Some "smart" hardware/software changes MSS while doing NAT/DSL, so
make additional compare with "good" MSS value(predefined 1460).
Kudos to Michal Zalewski and Mike Frantzen.

Whitespace cleanup.

Packets from outside(loopback is outside too) may have equal to
fingerprint ttl, not necessarily lesser.
=20
If we have timestamp option, do not compare it with one from
fingerprint.
(For now it is always 0).

ip->ttl must be less than finger's ttl if fingerprint is valid.

and probably others.

Patchset is against latest pom-ng/userspace.
Please test and apply.

For testing i also attach trivial osfd.c.

--=20
	Evgeniy Polaykov ( s0mbre )

--=-YmCaBrjB1OvQBUc8YPwI
Content-Disposition: inline; filename=ipt_osf.h.diff
Content-Type: text/plain; name=ipt_osf.h.diff; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

--- cvs_ext/netfilter/patch-o-matic-ng/osf/linux/include/linux/netfilter_ip=
v4/ipt_osf.h	Thu Dec 18 21:28:43 2003
+++ cvs_ext/netfilter/patch-o-matic-ng/osf/linux/include/linux/netfilter_ip=
v4/ipt_osf.h	Fri Jan 16 17:56:43 2004
@@ -26,14 +26,25 @@
 #define MAXDETLEN		64
=20
 #define IPT_OSF_GENRE		1
-#define IPT_OSF_SMART		2
+#define	IPT_OSF_SMART		2
 #define IPT_OSF_LOG		4
+#define IPT_OSF_NETLINK		8
=20
-#define IPT_OSF_LOGLEVEL_ALL		0
+#define IPT_OSF_LOGLEVEL_ALL	0
 #define IPT_OSF_LOGLEVEL_FIRST	1
=20
 #include <linux/list.h>
=20
+#ifndef __KERNEL__
+#include <netinet/ip.h>
+#include <netinet/tcp.h>
+
+struct list_head
+{
+	struct list_head *prev, *next;
+};
+#endif
+
 struct ipt_osf_info
 {
 	char 			genre[MAXGENRELEN];
@@ -59,8 +70,6 @@
 	struct osf_wc		wc;
 };
=20
-#ifdef __KERNEL__
-
 struct osf_finger
 {
 	struct list_head	flist;
@@ -78,6 +87,15 @@
 	struct osf_opt		opt[MAX_IPOPTLEN]; /* In case it is all NOP or EOL */
=20
 };
+
+struct ipt_osf_nlmsg
+{
+	struct osf_finger	f;
+	struct iphdr 		ip;
+	struct tcphdr 		tcp;
+};
+
+#ifdef __KERNEL__
=20
 /* Defines for IANA option kinds */
=20

--=-YmCaBrjB1OvQBUc8YPwI
Content-Disposition: inline; filename=libipt_osf.c.diff
Content-Type: text/plain; name=libipt_osf.c.diff; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

--- cvs_ext/netfilter/userspace/extensions/libipt_osf.c	Sun Jan  4 02:42:10=
 2004
+++ cvs_ext/netfilter/userspace/extensions/libipt_osf.c	Fri Jan 16 17:56:43=
 2004
@@ -31,9 +31,9 @@
 #include <ctype.h>
=20
 #include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_osf.h>
+#include <linux/netfilter_ipv4/ipt_osf.h>
=20
-#define IPTABLES_VERSION	"1.2.6a" /* It looks like FIXME */
+#define IPTABLES_VERSION	"1.2.7a" /* Permanent FIXME */
=20
 static void help(void)
 {
@@ -42,7 +42,8 @@
 		"--smart		Use some smart extensions to determine OS (do not use TTL).\n"
 		"--log level		Log all(or only first) determined genres even if "
 					"they do not match desired one. "
-					"Level may be 0(all) or 1(only first entry).\n",
+					"Level may be 0(all) or 1(only first entry).\n"
+		"--netlink		Log through netlink(NETLINK_NFLOG).\n",
 		IPTABLES_VERSION);
 }
=20
@@ -51,6 +52,7 @@
 	{ .name =3D "genre",	.has_arg =3D 1, .flag =3D 0, .val =3D '1' },
 	{ .name =3D "smart",	.has_arg =3D 0, .flag =3D 0, .val =3D '2' },
 	{ .name =3D "log",	.has_arg =3D 1, .flag =3D 0, .val =3D '3' },
+	{ .name =3D "netlink",	.has_arg =3D 0, .flag =3D 0, .val =3D '4' },
 	{ .name =3D 0 }
 };
=20
@@ -101,6 +103,12 @@
 			*flags |=3D IPT_OSF_LOG;
 			info->loglevel =3D atoi(argv[optind-1]);
 			info->flags |=3D IPT_OSF_LOG;
+			break;
+		case '4': /* --netlink */
+			if (*flags & IPT_OSF_NETLINK)
+				exit_error(PARAMETER_PROBLEM, "Can't specify multiple smart parameter"=
);
+			*flags |=3D IPT_OSF_NETLINK;
+			info->flags |=3D IPT_OSF_NETLINK;
 			break;
 		default:
 			return 0;

--=-YmCaBrjB1OvQBUc8YPwI
Content-Description: 
Content-Disposition: attachment; filename=osfd.c
Content-Type: text/x-c; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

#include <asm/types.h>

#include <sys/types.h>
#include <sys/socket.h>

#include <linux/netlink.h>
#include <linux/rtnetlink.h>

#include <arpa/inet.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "osf/ipt_osf.h"

#ifndef NIPQUAD
#define NIPQUAD(addr) \
	((unsigned char *)&addr)[0], \
	((unsigned char *)&addr)[1], \
	((unsigned char *)&addr)[2], \
	((unsigned char *)&addr)[3]
#endif

int main()
{
	int s;
	char buf[1024];
	int len;
	struct nlmsghdr *reply;
	struct sockaddr_nl l_local;
	struct ipt_osf_nlmsg *data;
=09
	memset(buf, 0, sizeof(buf));
=09
	s =3D socket(PF_NETLINK, SOCK_DGRAM, NETLINK_NFLOG);
	if (s =3D=3D -1)
	{
		perror("socket");
		return -1;
	}
=09
	l_local.nl_family =3D AF_NETLINK;
	l_local.nl_groups =3D 1;
	l_local.nl_pid    =3D getpid();
=09
	if (bind(s, (struct sockaddr *)&l_local, sizeof(struct sockaddr_nl)) =3D=
=3D -1)
	{
		perror("bind");
		close(s);
		return -1;
	}

	while (1)
	{
		len =3D recv(s, buf, sizeof(buf), 0);
		if (len =3D=3D -1)
		{
			perror("recv buf");
			close(s);
			return -1;
		}
		reply =3D (struct nlmsghdr *)buf;
	=09
		printf("first nlmsghdr received: len=3D%d\n", len);
		printf("nlsmsghdr: len=3D%d, type=3D%d, flags=3D%d, seq=3D%d, pid=3D%d, s=
ender_pid=3D%d\n",=20
				reply->nlmsg_len, reply->nlmsg_type,=20
				reply->nlmsg_flags, reply->nlmsg_seq, reply->nlmsg_pid,
				getpid());

		switch (reply->nlmsg_type)
		{
			case NLMSG_ERROR:
				printf("Error message received.\n");
				break;
			case NLMSG_DONE:
				data =3D (struct ipt_osf_nlmsg *)NLMSG_DATA(reply);
				printf("%s [%s:%s:%s] : %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u hops=3D%d\n",=20
					data->f.genre, data->f.version,
					data->f.subtype, data->f.details,
					NIPQUAD(data->ip.saddr), ntohs(data->tcp.source),
					NIPQUAD(data->ip.daddr), ntohs(data->tcp.dest),
					data->f.ttl - data->ip.ttl);
				break;
		}
	}

	close(s);
	return 0;
}

--=-YmCaBrjB1OvQBUc8YPwI
Content-Disposition: attachment; filename=ipt_osf.c.diff
Content-Type: text/plain; name=ipt_osf.c.diff; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

--- cvs_ext/netfilter/patch-o-matic-ng/osf/linux/net/ipv4/netfilter/ipt_osf=
.c	Thu Dec 18 21:56:03 2003
+++ cvs_ext/netfilter/patch-o-matic-ng/osf/linux/net/ipv4/netfilter/ipt_osf=
.c	Fri Jan 16 18:21:40 2004
@@ -30,6 +30,8 @@
=20
 #include <linux/config.h>
 #include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/string.h>
 #include <linux/smp.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -41,13 +43,14 @@
 #include <linux/spinlock.h>
 #include <linux/ctype.h>
 #include <linux/list.h>
+#include <linux/if.h>
=20
 #include <net/sock.h>
 #include <net/ip.h>
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
-#include <linux/netfilter_ipv4/ipt_osf.h>
+#include <linux/netfilter_ipv4/ipt_osf.h>
=20
 #define OSF_DEBUG
=20
@@ -70,12 +73,16 @@
=20
 static rwlock_t osf_lock =3D RW_LOCK_UNLOCKED;
 static struct list_head	finger_list;=09
-
 static int match(const struct sk_buff *, const struct net_device *, const =
struct net_device *,
-		      const void *, int, const void *, u_int16_t, int *);
+		      const void *, int,=20
+		      const void *, u_int16_t,=20
+		      int *);
 static int checkentry(const char *, const struct ipt_ip *, void *,
 		           unsigned int, unsigned int);
=20
+static unsigned long seq, ipt_osf_groups =3D 1;
+static struct sock *nts;
+
 static struct ipt_match osf_match =3D=20
 {=20
 	{ NULL, NULL },=20
@@ -86,12 +93,60 @@
 	THIS_MODULE=20
 };
=20
-static inline int smart_dec(unsigned long flags, unsigned char ip_ttl, uns=
igned char f_ttl)
+static void ipt_osf_nlsend(struct osf_finger *f, const struct sk_buff *sk)
 {
+	unsigned int size;
+	struct sk_buff *skb;
+	struct ipt_osf_nlmsg *data;
+	struct nlmsghdr *nlh;
+
+	size =3D NLMSG_SPACE(sizeof(struct ipt_osf_nlmsg));
+
+	skb =3D alloc_skb(size, GFP_ATOMIC);
+	if (!skb)
+	{
+		log("skb_alloc() failed.\n");
+		return;
+	}
+=09
+	nlh =3D NLMSG_PUT(skb, 0, seq++, NLMSG_DONE, size - sizeof(*nlh));
+=09
+	data =3D (struct ipt_osf_nlmsg *)NLMSG_DATA(nlh);
+
+	memcpy(&data->f, f, sizeof(struct osf_finger));
+	memcpy(&data->ip, skb->nh.iph, sizeof(struct iphdr));
+	memcpy(&data->tcp, (struct tcphdr *)((u_int32_t *)skb->nh.iph + skb->nh.i=
ph->ihl), sizeof(struct tcphdr));
+=09
+	NETLINK_CB(skb).dst_groups =3D ipt_osf_groups;
+	netlink_broadcast(nts, skb, 0, ipt_osf_groups, GFP_ATOMIC);
+
+nlmsg_failure:
+	return;
+}
+
+static inline int smart_dec(const struct sk_buff *skb, unsigned long flags=
, unsigned char f_ttl)
+{
+	struct iphdr *ip =3D skb->nh.iph;
+
 	if (flags & IPT_OSF_SMART)
-		return 1;
+	{
+		struct in_device *in_dev =3D in_dev_get(skb->dev);
+
+		for_ifa(in_dev)
+		{
+			if (inet_ifa_match(ip->saddr, ifa))
+			{
+				in_dev_put(in_dev);
+				return (ip->ttl =3D=3D f_ttl);
+			}
+		}
+		endfor_ifa(in_dev);
+	=09
+		in_dev_put(in_dev);
+		return (ip->ttl <=3D f_ttl);
+	}
 	else
-		return (ip_ttl =3D=3D f_ttl);
+		return (ip->ttl =3D=3D f_ttl);
 }
=20
 static int
@@ -151,7 +206,7 @@
 		fmatch =3D FMATCH_WRONG;
=20
 		if (totlen =3D=3D f->ss && df =3D=3D f->df &&=20
-			smart_dec(info->flags, ip->ttl, f->ttl))
+			smart_dec(skb, info->flags, f->ttl))
 		{
 			unsigned long foptsize;
 			int optnum;
@@ -197,32 +252,57 @@
=20
 			for (optnum=3D0; optnum<f->opt_num; ++optnum)
 			{
-				if (f->opt[optnum].kind =3D=3D (*optp))
+				if (f->opt[optnum].kind =3D=3D (*optp))=20
 				{
 					unsigned char len =3D f->opt[optnum].length;
 					unsigned char *optend =3D optp + len;
+					int loop_cont =3D 0;
=20
 					fmatch =3D FMATCH_OK;
=20
-					if (*optp =3D=3D OSFOPT_MSS) /* MSS */
-						mss =3D ntohs(*(unsigned short *)(optp+2));
+
+					switch (*optp)
+					{
+						case OSFOPT_MSS:
+							mss =3D ntohs(*(unsigned short *)(optp+2));
+							break;
+						case OSFOPT_TS:
+							loop_cont =3D 1;
+							break;
+					}
+				=09
+					if (loop_cont)
+					{
+						optp =3D optend;
+						continue;
+					}
 				=09
 					if (len !=3D 1)
 					{
 						/* Skip kind and length fields*/
 						optp +=3D 2;=20
=20
-						if (f->opt[optnum].wc.wc !=3D 0)
+						if (f->opt[optnum].wc.val !=3D 0)
 						{
 							unsigned long tmp =3D 0;
 						=09
 							/* Hmmm... It looks a bit ugly. :) */
-							memcpy(&tmp, &f->opt[optnum].wc.val,=20
+							memcpy(&tmp, optp,=20
 								(len > sizeof(unsigned long)?
 								 	sizeof(unsigned long):len));
-
-							tmp =3D ntohl(tmp);
-							if (tmp !=3D f->opt[optnum].wc.val)
+							/* 2 + 2: optlen(2 bytes) +=20
+							 * 	kind(1 byte) + length(1 byte) */
+							if (len =3D=3D 4)=20
+								tmp =3D ntohs(tmp);
+							else
+								tmp =3D ntohl(tmp);
+
+							if (f->opt[optnum].wc.wc =3D=3D '%')
+							{
+								if ((tmp % f->opt[optnum].wc.val) !=3D 0)
+									fmatch =3D FMATCH_OPT_WRONG;
+							}
+							else if (tmp !=3D f->opt[optnum].wc.val)
 								fmatch =3D FMATCH_OPT_WRONG;
 						}
 					}
@@ -243,19 +323,23 @@
 				switch (check_WSS)
 				{
 					case 0:
-						if (window =3D=3D f->wss.val)
+						if (f->wss.val =3D=3D 0 || window =3D=3D f->wss.val)
 							fmatch =3D FMATCH_OK;
 						break;
 					case 1: /* MSS */
-						if (window =3D=3D f->wss.val*mss)
+/* Lurked in OpenBSD */
+#define SMART_MSS	1460
+						if (window =3D=3D f->wss.val*mss ||=20
+							window =3D=3D f->wss.val*SMART_MSS)
 							fmatch =3D FMATCH_OK;
 						break;
 					case 2: /* MTU */
-						if (window =3D=3D f->wss.val*(mss+40))
+						if (window =3D=3D f->wss.val*(mss+40) ||
+							window =3D=3D f->wss.val*(SMART_MSS+40))
 							fmatch =3D FMATCH_OK;
 						break;
 					case 3: /* MOD */
-						if (window % f->wss.val =3D=3D 0)
+						if ((window % f->wss.val) =3D=3D 0)
 							fmatch =3D FMATCH_OK;
 						break;
 				}
@@ -265,18 +349,45 @@
 			if (fmatch =3D=3D FMATCH_OK)
 			{
 				fcount++;
-				log("%s [%s]: %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u\n",=20
-					f->genre, f->details,
+				log("%s [%s:%s:%s] : %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u hops=3D%d\n",=20
+					f->genre, f->version,
+					f->subtype, f->details,
 					NIPQUAD(ip->saddr), ntohs(tcp->source),
-					NIPQUAD(ip->daddr), ntohs(tcp->dest));
+					NIPQUAD(ip->daddr), ntohs(tcp->dest),
+					f->ttl - ip->ttl);
+				if (info->flags & IPT_OSF_NETLINK)
+					ipt_osf_nlsend(f, skb);
 				if ((info->flags & IPT_OSF_LOG) &&=20
 					info->loglevel =3D=3D IPT_OSF_LOGLEVEL_FIRST)
 					break;
 			}
 		}
 	}
+	if (!fcount && (info->flags & IPT_OSF_NETLINK))
+	{
+		struct osf_finger u;
+
+		memset(&u, 0, sizeof(u));
+		snprintf(u.genre, MAXGENRELEN, "Unknown");
+		snprintf(u.version, MAXGENRELEN, "Unknown");
+		snprintf(u.subtype, MAXGENRELEN, "Unknown");
+		u.wss.val =3D window;
+		u.ttl =3D ip->ttl;
+		u.df =3D df;
+		u.ss =3D totlen;
+		if (optp)
+		{
+			unsigned int optsize;
+
+			optsize =3D tcp->doff * 4 - sizeof(struct tcphdr);
+			/* optsize <=3D 40. So it always less than MAXDETLEN (64) */
+			skb_copy_bits(skb, ip->ihl*4 + sizeof(struct tcphdr), u.details, optsiz=
e);
+		}
+		ipt_osf_nlsend(&u, skb);
+	}
 	if (!fcount && (info->flags & IPT_OSF_LOG))
 	{
+
 		log("Unknown: %lu:%d:%d:%lu:", window, ip->ttl, df, totlen);
 		if (optp)
 		{
@@ -594,7 +705,12 @@
 			else=20
 				finger->wss.val =3D simple_strtoul(pbeg+1, NULL, 10);
 		}
-		if (isdigit(pbeg[0]))
+		else if (pbeg[0] =3D=3D '%')
+		{
+			finger->wss.wc =3D '%';
+			finger->wss.val =3D simple_strtoul(pbeg+1, NULL, 10);
+		}
+		else if (isdigit(pbeg[0]))
 		{
 			finger->wss.wc =3D 0;
 			finger->wss.val =3D simple_strtoul(pbeg, NULL, 10);
@@ -702,6 +818,15 @@
=20
 	p->write_proc =3D osf_proc_write;
 	p->read_proc  =3D osf_proc_read;
+=09
+	nts =3D netlink_kernel_create(NETLINK_NFLOG, NULL);
+	if (!nts)
+	{
+		log("netlink_kernel_create() failed\n");
+		remove_proc_entry("sys/net/ipv4/osf", NULL);
+		ipt_unregister_match(&osf_match);
+		return -ENOMEM;
+	}
=20
 	return 0;
 }
@@ -713,6 +838,8 @@
 =09
 	remove_proc_entry("sys/net/ipv4/osf", NULL);
 	ipt_unregister_match(&osf_match);
+	if (nts && nts->socket)
+		sock_release(nts->socket);
=20
 	list_for_each_safe(ent, n, &finger_list)
 	{
@@ -730,4 +857,3 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
 MODULE_DESCRIPTION("Passive OS fingerprint matching.");
-

--=-YmCaBrjB1OvQBUc8YPwI--

--=-e6IWDtRZG5zgB7ISL5CW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQBACAXPIKTPhE+8wY0RAhNRAKCF4diunaMv+IuKtyrIXzWNETI4cgCfYvED
COo8p1FrTzN3c5qzFg9/Ozs=
=3O3g
-----END PGP SIGNATURE-----

--=-e6IWDtRZG5zgB7ISL5CW--
