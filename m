From: Florian Lohoff <flo@rfc822.org>
Subject: Re: REJECT target / need-fragment ?
Date: Wed, 6 Apr 2005 13:38:59 +0200
Message-ID: <20050406113859.GA5335@paradigm.rfc822.org>
References: <20050314125747.GA18233@paradigm.rfc822.org>
	<42373578.8060806@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42373578.8060806@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: multipart/mixed; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 15, 2005 at 08:20:24PM +0100, Patrick McHardy wrote:
> Florian Lohoff wrote:
> >Hi,
> >i'd like to reject packets based on their size and send back and
> >icmp-must-fragment with a configurable size. As i can see no such
> >possibility is there currently. The REJECT target itself does not
> >offer this.

> Yes, but adding yet another target that does something already done
> elsewhere is not a good idea. You could try to extend ipt_REJECT
> in a way similar to Rusty's patch "Add bitops to ipt_MARK without
> breaking compatbility".

Ok - Had a boring network change this morning - results:

- iptables current svn patch (manpage, libipt_REJECT.c)
- kernel 2.6.11.6 patch (ipt_REJECT.[ch])

All with revisions so if i got it right should "not break compatibility"

Compiles and works for me ...

flo@touch:~$ sudo iptables -v -L
Chain INPUT (policy ACCEPT 485K packets, 145M bytes)
 pkts bytes target     prot opt in     out     source               destina=
tion=20
   44 63243 PMTU       all  --  any    any     anywhere             anywher=
e    length 1001:1500

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destina=
tion=20

Chain OUTPUT (policy ACCEPT 647K packets, 791M bytes)
 pkts bytes target     prot opt in     out     source               destina=
tion=20

Chain PMTU (1 references)
 pkts bytes target     prot opt in     out     source               destina=
tion=20
   44 63243 REJECT     all  --  any    any     anywhere             anywher=
e    reject-with icmp-frag-needed pmtu 1000

Comments ?

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
                        Heisenberg may have been here.

--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="iptables-svn-20050506-REJECT-pmtu.diff"
Content-Transfer-Encoding: quoted-printable

Index: extensions/libipt_REJECT.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- extensions/libipt_REJECT.man	(revision 3826)
+++ extensions/libipt_REJECT.man	(working copy)
@@ -21,6 +21,7 @@
 .B " icmp-net-prohibited"
 .B " icmp-host-prohibited or"
 .B " icmp-admin-prohibited (*)"
+.B " icmp-frag-needed"
 .fi
 which return the appropriate ICMP error message (\fBport-unreachable\fP is
 the default).  The option
@@ -31,4 +32,7 @@
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
 .TP
+.BI "--pmtu " "size"
+The next-hop MTU the icmp-frag-needed is sent back with.
+.TP
 (*) Using icmp-admin-prohibited with kernels that do not support it will r=
esult in a plain DROP instead of REJECT
Index: extensions/libipt_REJECT.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- extensions/libipt_REJECT.c	(revision 3826)
+++ extensions/libipt_REJECT.c	(working copy)
@@ -46,6 +46,8 @@
 	 IPT_ICMP_HOST_PROHIBITED, "ICMP host prohibited"},
 	{"tcp-reset", "tcp-reset",
 	 IPT_TCP_RESET, "TCP RST packet"},
+	{"icmp-frag-needed", "frag-needed",
+	 IPT_ICMP_FRAG_NEEDED, "ICMP fragmentation needed"},
 	{"icmp-admin-prohibited", "admin-prohib",
 	 IPT_ICMP_ADMIN_PROHIBITED, "ICMP administratively prohibited (*)"}
 };
@@ -73,7 +75,8 @@
 	printf(
 "REJECT options:\n"
 "--reject-with type              drop input packet and send back\n"
-"                                a reply packet according to type:\n");
+"                                a reply packet according to type:\n"
+"--pmtu                          send back pmtu for icmp-frag-needed\n");
=20
 	print_reject_types();
=20
@@ -82,6 +85,7 @@
=20
 static struct option opts[] =3D {
 	{ "reject-with", 1, 0, '1' },
+	{ "pmtu", 1, 0, '2' },
 	{ 0 }
 };
=20
@@ -96,6 +100,17 @@
=20
 }
=20
+/* Allocate and initialize the target. */
+static void
+init_v1(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+	struct ipt_reject_info_v1 *reject =3D (struct ipt_reject_info_v1 *)t->dat=
a;
+
+	/* default */
+	reject->with =3D IPT_ICMP_PORT_UNREACHABLE;
+
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -132,6 +147,51 @@
 	return 0;
 }
=20
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse_v1(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+	struct ipt_reject_info_v1 *reject =3D (struct ipt_reject_info_v1 *)(*targ=
et)->data;
+	unsigned int limit =3D sizeof(reject_table)/sizeof(struct reject_names);
+	unsigned int i;
+
+	switch(c) {
+	case '1':
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --reject-with");
+		for (i =3D 0; i < limit; i++) {
+			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) =3D=3D 0)
+			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) =3D=
=3D 0)) {
+				reject->with =3D reject_table[i].with;
+				return 1;
+			}
+		}
+		/* This due to be dropped late in 2.4 pre-release cycle --RR */
+		if (strncasecmp("echo-reply", optarg, strlen(optarg)) =3D=3D 0
+		    || strncasecmp("echoreply", optarg, strlen(optarg)) =3D=3D 0)
+			fprintf(stderr, "--reject-with echo-reply no longer"
+				" supported\n");
+		exit_error(PARAMETER_PROBLEM, "unknown reject type `%s'",optarg);
+	case '2':
+		if (reject->with !=3D IPT_ICMP_FRAG_NEEDED)=20
+			exit_error(PARAMETER_PROBLEM, "--pmtu only valid with icmp-frag-needed"=
);
+		if (string_to_number(optarg, 68, 65535, &i) =3D=3D -1)
+			exit_error(PARAMETER_PROBLEM, "pmtu number `%s' out of range",optarg);
+
+		reject->value=3Di;
+		return 1;
+	default:
+		/* Fall through */
+		break;
+	}
+	return 0;
+}
+
+
 /* Final check; nothing. */
 static void final_check(unsigned int flags)
 {
@@ -154,6 +214,27 @@
 	printf("reject-with %s ", reject_table[i].name);
 }
=20
+/* Prints out ipt_reject_info. */
+static void
+print_v1(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+	const struct ipt_reject_info_v1 *reject
+		=3D (const struct ipt_reject_info_v1 *)target->data;
+	unsigned int i;
+
+	for (i =3D 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
+		if (reject_table[i].with =3D=3D reject->with)
+			break;
+	}
+	printf("reject-with %s ", reject_table[i].name);
+
+	if (reject->with =3D=3D IPT_ICMP_FRAG_NEEDED)
+		printf("pmtu %d ", reject->value);
+}
+
+
 /* Saves ipt_reject in parsable form to stdout. */
 static void save(const struct ipt_ip *ip, const struct ipt_entry_target *t=
arget)
 {
@@ -168,7 +249,25 @@
 	printf("--reject-with %s ", reject_table[i].name);
 }
=20
-static struct iptables_target reject =3D {=20
+/* Saves ipt_reject in parsable form to stdout. */
+static void save_v1(const struct ipt_ip *ip, const struct ipt_entry_target=
 *target)
+{
+	const struct ipt_reject_info_v1 *reject
+		=3D (const struct ipt_reject_info_v1 *)target->data;
+	unsigned int i;
+
+	for (i =3D 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++)
+		if (reject_table[i].with =3D=3D reject->with)
+			break;
+
+	printf("--reject-with %s ", reject_table[i].name);
+
+	if (reject->with =3D=3D IPT_ICMP_FRAG_NEEDED)
+		printf("--pmtu %d ", reject->value);
+}
+
+
+static struct iptables_target reject_v0 =3D {=20
 	.next		=3D NULL,
 	.name		=3D "REJECT",
 	.version	=3D IPTABLES_VERSION,
@@ -183,7 +282,25 @@
 	.extra_opts	=3D opts
 };
=20
+static struct iptables_target reject_v1 =3D {=20
+	.next		=3D NULL,
+	.name		=3D "REJECT",
+	.version	=3D IPTABLES_VERSION,
+	.revision	=3D 1,
+	.size		=3D IPT_ALIGN(sizeof(struct ipt_reject_info_v1)),
+	.userspacesize	=3D IPT_ALIGN(sizeof(struct ipt_reject_info_v1)),
+	.help		=3D &help,
+	.init		=3D &init_v1,
+	.parse		=3D &parse_v1,
+	.final_check	=3D &final_check,
+	.print		=3D &print_v1,
+	.save		=3D &save_v1,
+	.extra_opts	=3D opts
+};
+
+
 void _init(void)
 {
-	register_target(&reject);
+	register_target(&reject_v0);
+	register_target(&reject_v1);
 }

--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kernel-2.6.11.6-REJECT-pmtu.diff"
Content-Transfer-Encoding: quoted-printable

diff -Nur linux-2.6.11.6.vanilla/include/linux/netfilter_ipv4/ipt_REJECT.h =
linux-2.6.11.6/include/linux/netfilter_ipv4/ipt_REJECT.h
--- linux-2.6.11.6.vanilla/include/linux/netfilter_ipv4/ipt_REJECT.h	2005-0=
3-26 04:28:26.000000000 +0100
+++ linux-2.6.11.6/include/linux/netfilter_ipv4/ipt_REJECT.h	2005-04-06 10:=
31:03.000000000 +0200
@@ -10,11 +10,17 @@
 	IPT_ICMP_NET_PROHIBITED,
 	IPT_ICMP_HOST_PROHIBITED,
 	IPT_TCP_RESET,
-	IPT_ICMP_ADMIN_PROHIBITED
+	IPT_ICMP_ADMIN_PROHIBITED,
+	IPT_ICMP_FRAG_NEEDED
 };
=20
 struct ipt_reject_info {
 	enum ipt_reject_with with;      /* reject type */
 };
=20
+struct ipt_reject_info_v1 {
+	enum ipt_reject_with with;      /* reject type */
+	u_int16_t value;
+};
+
 #endif /*_IPT_REJECT_H*/
diff -Nur linux-2.6.11.6.vanilla/net/ipv4/netfilter/ipt_REJECT.c linux-2.6.=
11.6/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.6.11.6.vanilla/net/ipv4/netfilter/ipt_REJECT.c	2005-03-26 04:28=
:26.000000000 +0100
+++ linux-2.6.11.6/net/ipv4/netfilter/ipt_REJECT.c	2005-04-06 11:40:14.0000=
00000 +0200
@@ -220,7 +220,7 @@
 	kfree_skb(nskb);
 }
=20
-static void send_unreach(struct sk_buff *skb_in, int code)
+static void send_unreach(struct sk_buff *skb_in, int code, u_int16_t value)
 {
 	struct iphdr *iph;
 	struct icmphdr *icmph;
@@ -349,7 +349,10 @@
 	icmph->code =3D code;=09
 	icmph->un.gateway =3D 0;
 	icmph->checksum =3D 0;
-=09
+
+	if (code =3D=3D ICMP_FRAG_NEEDED)
+		icmph->un.frag.mtu=3Dhtons(value);
+
 	/* Copy as much of original packet as will fit */
 	data =3D skb_put(nskb,
 		       length - sizeof(struct iphdr) - sizeof(struct icmphdr));
@@ -366,14 +369,10 @@
 		ip_finish_output);
 }=09
=20
-static unsigned int reject(struct sk_buff **pskb,
-			   const struct net_device *in,
-			   const struct net_device *out,
-			   unsigned int hooknum,
-			   const void *targinfo,
-			   void *userinfo)
+
+static unsigned int reject(struct sk_buff **pskb, unsigned int hooknum,=20
+			int with, u_int16_t value)
 {
-	const struct ipt_reject_info *reject =3D targinfo;
=20
 	/* Our naive response construction doesn't deal with IP
            options, and probably shouldn't try. */
@@ -383,27 +382,30 @@
 	/* WARNING: This code causes reentry within iptables.
 	   This means that the iptables jump stack is now crap.  We
 	   must return an absolute verdict. --RR */
-    	switch (reject->with) {
+    	switch (with) {
     	case IPT_ICMP_NET_UNREACHABLE:
-    		send_unreach(*pskb, ICMP_NET_UNREACH);
+    		send_unreach(*pskb, ICMP_NET_UNREACH, 0);
     		break;
     	case IPT_ICMP_HOST_UNREACHABLE:
-    		send_unreach(*pskb, ICMP_HOST_UNREACH);
+    		send_unreach(*pskb, ICMP_HOST_UNREACH, 0);
     		break;
     	case IPT_ICMP_PROT_UNREACHABLE:
-    		send_unreach(*pskb, ICMP_PROT_UNREACH);
+    		send_unreach(*pskb, ICMP_PROT_UNREACH, 0);
     		break;
     	case IPT_ICMP_PORT_UNREACHABLE:
-    		send_unreach(*pskb, ICMP_PORT_UNREACH);
+    		send_unreach(*pskb, ICMP_PORT_UNREACH, 0);
     		break;
     	case IPT_ICMP_NET_PROHIBITED:
-    		send_unreach(*pskb, ICMP_NET_ANO);
+    		send_unreach(*pskb, ICMP_NET_ANO, 0);
     		break;
 	case IPT_ICMP_HOST_PROHIBITED:
-    		send_unreach(*pskb, ICMP_HOST_ANO);
+    		send_unreach(*pskb, ICMP_HOST_ANO, 0);
     		break;
     	case IPT_ICMP_ADMIN_PROHIBITED:
-		send_unreach(*pskb, ICMP_PKT_FILTERED);
+		send_unreach(*pskb, ICMP_PKT_FILTERED, 0);
+		break;
+    	case IPT_ICMP_FRAG_NEEDED:
+		send_unreach(*pskb, ICMP_FRAG_NEEDED, value);
 		break;
 	case IPT_TCP_RESET:
 		send_reset(*pskb, hooknum);
@@ -415,7 +417,29 @@
 	return NF_DROP;
 }
=20
-static int check(const char *tablename,
+static unsigned int reject_v0(struct sk_buff **pskb,
+			   const struct net_device *in,
+			   const struct net_device *out,
+			   unsigned int hooknum,
+			   const void *targinfo,
+			   void *userinfo)
+{
+	const struct ipt_reject_info *rejinfo =3D targinfo;
+	return reject(pskb, hooknum, rejinfo->with, 0);
+}
+
+static unsigned int reject_v1(struct sk_buff **pskb,
+			   const struct net_device *in,
+			   const struct net_device *out,
+			   unsigned int hooknum,
+			   const void *targinfo,
+			   void *userinfo)
+{
+	const struct ipt_reject_info_v1 *rejinfo =3D targinfo;
+	return reject(pskb, hooknum, rejinfo->with, rejinfo->value);
+}
+
+static int check_v0(const char *tablename,
 		 const struct ipt_entry *e,
 		 void *targinfo,
 		 unsigned int targinfosize,
@@ -455,21 +479,84 @@
 	return 1;
 }
=20
-static struct ipt_target ipt_reject_reg =3D {
+static int check_v1(const char *tablename,
+		 const struct ipt_entry *e,
+		 void *targinfo,
+		 unsigned int targinfosize,
+		 unsigned int hook_mask)
+{
+ 	const struct ipt_reject_info_v1 *rejinfo =3D targinfo;
+
+ 	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_reject_info_v1))) {
+  		DEBUGP("REJECT: targinfosize %u !=3D 0\n", targinfosize);
+  		return 0;
+  	}
+
+	/* Only allow these for packet filtering. */
+	if (strcmp(tablename, "filter") !=3D 0) {
+		DEBUGP("REJECT: bad table `%s'.\n", tablename);
+		return 0;
+	}
+	if ((hook_mask & ~((1 << NF_IP_LOCAL_IN)
+			   | (1 << NF_IP_FORWARD)
+			   | (1 << NF_IP_LOCAL_OUT))) !=3D 0) {
+		DEBUGP("REJECT: bad hook mask %X\n", hook_mask);
+		return 0;
+	}
+
+	if (rejinfo->with =3D=3D IPT_ICMP_ECHOREPLY) {
+		printk("REJECT: ECHOREPLY no longer supported.\n");
+		return 0;
+	} else if (rejinfo->with =3D=3D IPT_TCP_RESET) {
+		/* Must specify that it's a TCP packet */
+		if (e->ip.proto !=3D IPPROTO_TCP
+		    || (e->ip.invflags & IPT_INV_PROTO)) {
+			DEBUGP("REJECT: TCP_RESET invalid for non-tcp\n");
+			return 0;
+		}
+	} else if (rejinfo->with =3D=3D IPT_ICMP_FRAG_NEEDED) {
+		if (rejinfo->value < 68) {
+			DEBUGP("REJECT: pmtu too small\n");
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+
+static struct ipt_target ipt_reject_reg_v0 =3D {
+	.name		=3D "REJECT",
+	.target		=3D reject_v0,
+	.checkentry	=3D check_v0,
+	.me		=3D THIS_MODULE,
+	.revision	=3D 0
+};
+
+static struct ipt_target ipt_reject_reg_v1 =3D {
 	.name		=3D "REJECT",
-	.target		=3D reject,
-	.checkentry	=3D check,
+	.target		=3D reject_v1,
+	.checkentry	=3D check_v1,
 	.me		=3D THIS_MODULE,
+	.revision	=3D 1
 };
=20
 static int __init init(void)
 {
-	return ipt_register_target(&ipt_reject_reg);
+	int	err;
+	err =3D ipt_register_target(&ipt_reject_reg_v0);
+	if (!err) {
+		err =3D ipt_register_target(&ipt_reject_reg_v1);
+		if (err)
+			ipt_unregister_target(&ipt_reject_reg_v0);
+	}=09
+	return err;
 }
=20
 static void __exit fini(void)
 {
-	ipt_unregister_target(&ipt_reject_reg);
+	ipt_unregister_target(&ipt_reject_reg_v0);
+	ipt_unregister_target(&ipt_reject_reg_v1);
 }
=20
 module_init(init);

--eJnRUKwClWJh1Khz--

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCU8pSUaz2rXW+gJcRAkH2AKDi8/IznfVZnvGI+RpSMVng6olrewCeKpIz
7nXIx7vXnTNYZrvKOGmsieg=
=GgjV
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
