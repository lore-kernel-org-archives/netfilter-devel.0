From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] cleanup conntrack helper API
Date: Mon, 29 Mar 2004 12:40:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329104011.GE1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QDd5rp1wjxlDmy9q"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QDd5rp1wjxlDmy9q
Content-Type: multipart/mixed; boundary="ulDeV4rPMk/y39in"
Content-Disposition: inline


--ulDeV4rPMk/y39in
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the first in a set of 2.6.x optimization patches.  Obviosly,
they are meant for 2.6.6, not 2.6.5.  Please apply to your tree, thanks.

A: Pablo Neira
D: This patch changes the conntrack helper API.  Rather than having the
D: helper allocate an expect on the stack and then have the core
D: kmalloc and memcpy, it is now the job of a helper to call=20
D: ip_conntrack_expect_alloc()

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ulDeV4rPMk/y39in
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 04:57=
:11.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-05 03:08:30.=
000000000 +0100
@@ -917,11 +917,55 @@
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
=20
+struct ip_conntrack_expect *
+ip_conntrack_expect_alloc()
+{
+	struct ip_conntrack_expect *new;
+=09
+	new =3D (struct ip_conntrack_expect *)
+		kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
+	if (!new) {
+		DEBUGP("expect_related: OOM allocating expect\n");
+		return NULL;
+	}
+
+	/* tuple_cmp compares whole union, we have to initialized cleanly */
+	memset(new, 0, sizeof(struct ip_conntrack_expect));
+
+	return new;
+}
+
+static void
+ip_conntrack_expect_insert(struct ip_conntrack_expect *new,
+			   struct ip_conntrack *related_to)
+{
+	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
+	new->expectant =3D related_to;
+	new->sibling =3D NULL;
+	atomic_set(&new->use, 1);
+
+	/* add to expected list for this connection */
+	list_add(&new->expected_list, &related_to->sibling_list);
+	/* add to global list of expectations */
+
+	list_prepend(&ip_conntrack_expect_list, &new->list);
+	/* add and start timer if required */
+	if (related_to->helper->timeout) {
+		init_timer(&new->timeout);
+		new->timeout.data =3D (unsigned long)new;
+		new->timeout.function =3D expectation_timed_out;
+		new->timeout.expires =3D jiffies +
+					related_to->helper->timeout * HZ;
+		add_timer(&new->timeout);
+	}
+	related_to->expecting++;
+}
+
 /* Add a related connection. */
-int ip_conntrack_expect_related(struct ip_conntrack *related_to,
-				struct ip_conntrack_expect *expect)
+int ip_conntrack_expect_related(struct ip_conntrack_expect *expect,
+				struct ip_conntrack *related_to)
 {
-	struct ip_conntrack_expect *old, *new;
+	struct ip_conntrack_expect *old;
 	int ret =3D 0;
=20
 	WRITE_LOCK(&ip_conntrack_lock);
@@ -943,7 +987,7 @@
 		if (related_to->helper->timeout) {
 			if (!del_timer(&old->timeout)) {
 				/* expectation is dying. Fall through */
-				old =3D NULL;
+				goto out;
 			} else {
 				old->timeout.expires =3D jiffies +=20
 					related_to->helper->timeout * HZ;
@@ -951,10 +995,10 @@
 			}
 		}
=20
-		if (old) {
-			WRITE_UNLOCK(&ip_conntrack_lock);
-			return -EEXIST;
-		}
+		WRITE_UNLOCK(&ip_conntrack_lock);
+		kfree(expect);
+		return -EEXIST;
+
 	} else if (related_to->helper->max_expected &&=20
 		   related_to->expecting >=3D related_to->helper->max_expected) {
 		struct list_head *cur_item;
@@ -971,6 +1015,7 @@
 				       related_to->helper->name,
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].t=
uple.src.ip),
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].t=
uple.dst.ip));
+			kfree(expect);
 			return -EPERM;
 		}
 		DEBUGP("ip_conntrack: max number of expected "
@@ -1010,37 +1055,12 @@
 			     &expect->mask)) {
 		WRITE_UNLOCK(&ip_conntrack_lock);
 		DEBUGP("expect_related: busy!\n");
+
+		kfree(expect);
 		return -EBUSY;
 	}
-=09
-	new =3D (struct ip_conntrack_expect *)=20
-	      kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
-	if (!new) {
-		WRITE_UNLOCK(&ip_conntrack_lock);
-		DEBUGP("expect_relaed: OOM allocating expect\n");
-		return -ENOMEM;
-	}
-=09
-	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
-	memcpy(new, expect, sizeof(*expect));
-	new->expectant =3D related_to;
-	new->sibling =3D NULL;
-	atomic_set(&new->use, 1);
-=09
-	/* add to expected list for this connection */=09
-	list_add(&new->expected_list, &related_to->sibling_list);
-	/* add to global list of expectations */
-	list_prepend(&ip_conntrack_expect_list, &new->list);
-	/* add and start timer if required */
-	if (related_to->helper->timeout) {
-		init_timer(&new->timeout);
-		new->timeout.data =3D (unsigned long)new;
-		new->timeout.function =3D expectation_timed_out;
-		new->timeout.expires =3D jiffies +=20
-					related_to->helper->timeout * HZ;
-		add_timer(&new->timeout);
-	}
-	related_to->expecting++;
+
+out:	ip_conntrack_expect_insert(expect, related_to);
=20
 	WRITE_UNLOCK(&ip_conntrack_lock);
=20
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-18=
 04:57:46.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-03-05 03:=
06:54.000000000 +0100
@@ -497,6 +497,7 @@
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(__ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
+EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_change_expect);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004=
-02-18 04:57:16.000000000 +0100
+++ linux-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-03-=
05 15:11:02.000000000 +0100
@@ -35,9 +35,13 @@
=20
 extern struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_connt=
rack_tuple *tuple);
=20
+
+/* Allocate space for an expectation: this is mandatory before calling=20
+   ip_conntrack_expect_related. */
+extern struct ip_conntrack_expect *ip_conntrack_expect_alloc(void);
 /* Add an expected connection: can have more than one per connection */
-extern int ip_conntrack_expect_related(struct ip_conntrack *related_to,
-				       struct ip_conntrack_expect *exp);
+extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp,
+				       struct ip_conntrack *related_to);
 extern int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
 				      struct ip_conntrack_tuple *newtuple);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-18 04:57=
:22.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-03-06 02:54:05.=
000000000 +0100
@@ -44,7 +44,7 @@
 		     enum ip_conntrack_info ctinfo)
 {
 	struct tftphdr tftph;
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
=20
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4 + sizeof(struct udphdr),
 			  &tftph, sizeof(tftph)) !=3D 0)
@@ -57,19 +57,22 @@
 		DEBUGP("");
 		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-		memset(&exp, 0, sizeof(exp));
=20
-		exp.tuple =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		exp.mask.src.ip =3D 0xffffffff;
-		exp.mask.dst.ip =3D 0xffffffff;
-		exp.mask.dst.u.udp.port =3D 0xffff;
-		exp.mask.dst.protonum =3D 0xffff;
-		exp.expectfn =3D NULL;
+		exp =3D ip_conntrack_expect_alloc();
+		if (exp =3D=3D NULL)
+			return NF_ACCEPT;
+
+		exp->tuple =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+		exp->mask.src.ip =3D 0xffffffff;
+		exp->mask.dst.ip =3D 0xffffffff;
+		exp->mask.dst.u.udp.port =3D 0xffff;
+		exp->mask.dst.protonum =3D 0xffff;
+		exp->expectfn =3D NULL;
=20
 		DEBUGP("expect: ");
-		DUMP_TUPLE(&exp.tuple);
-		DUMP_TUPLE(&exp.mask);
-		ip_conntrack_expect_related(ct, &exp);
+		DUMP_TUPLE(&exp->tuple);
+		DUMP_TUPLE(&exp->mask);
+		ip_conntrack_expect_related(exp, ct);
 		break;
 	default:
 		DEBUGP("Unknown opcode\n");
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-18 04:59:=
06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_irc.c	2004-03-06 02:55:26.0=
00000000 +0100
@@ -106,8 +106,8 @@
 	struct tcphdr tcph;
 	char *data, *data_limit;
 	int dir =3D CTINFO2DIR(ctinfo);
-	struct ip_conntrack_expect expect, *exp =3D &expect;
-	struct ip_ct_irc_expect *exp_irc_info =3D &exp->help.exp_irc_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_irc_expect *exp_irc_info =3D NULL;
=20
 	u_int32_t dcc_ip;
 	u_int16_t dcc_port;
@@ -190,8 +190,12 @@
=20
 				continue;
 			}
-		=09
-			memset(&expect, 0, sizeof(expect));
+
+			exp =3D ip_conntrack_expect_alloc();
+			if (exp =3D=3D NULL)
+				goto out;
+
+			exp_irc_info =3D &exp->help.exp_irc_info;
=20
 			/* save position of address in dcc string,
 			 * necessary for NAT */
@@ -218,7 +222,7 @@
 				NIPQUAD(exp->tuple.dst.ip),
 				ntohs(exp->tuple.dst.u.tcp.port));
=20
-			ip_conntrack_expect_related(ct, &expect);
+			ip_conntrack_expect_related(exp, ct);
=20
 			goto out;
 		} /* for .. NUM_DCCPROTO */
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-18 04:59:=
06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-03-06 02:56:56.0=
00000000 +0100
@@ -256,8 +256,8 @@
 	int dir =3D CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff;
 	struct ip_ct_ftp_master *ct_ftp_info =3D &ct->help.ct_ftp_info;
-	struct ip_conntrack_expect expect, *exp =3D &expect;
-	struct ip_ct_ftp_expect *exp_ftp_info =3D &exp->help.exp_ftp_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_ftp_expect *exp_ftp_info;
=20
 	unsigned int i;
 	int found =3D 0;
@@ -346,8 +346,15 @@
 	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
 	       (int)matchlen, data + matchoff,
 	       matchlen, ntohl(tcph.seq) + matchoff);
-	      =20
-	memset(&expect, 0, sizeof(expect));
+
+	/* Allocate expectation which will be inserted */
+	exp =3D ip_conntrack_expect_alloc();
+	if (exp =3D=3D NULL) {
+		ret =3D NF_ACCEPT;
+		goto out;
+	}
+
+	exp_ftp_info =3D &exp->help.exp_ftp_info;
=20
 	/* Update the ftp info */
 	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3=
])
@@ -389,7 +396,7 @@
 	exp->expectfn =3D NULL;
=20
 	/* Ignore failure; should only happen with NAT */
-	ip_conntrack_expect_related(ct, &expect);
+	ip_conntrack_expect_related(exp, ct);
 	ret =3D NF_ACCEPT;
  out:
 	UNLOCK_BH(&ip_ftp_lock);
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-05 03:=
24:47.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-06 02:22:2=
0.000000000 +0100
@@ -46,10 +46,11 @@
 static int help(struct sk_buff *skb,
                 struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 	struct ip_ct_amanda_expect *exp_amanda_info;
 	char *data, *data_limit, *tmp;
 	unsigned int dataoff, i;
+	u_int16_t port, len;
=20
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL)
@@ -79,33 +80,40 @@
 		goto out;
 	data +=3D strlen("CONNECT ");
=20
-	memset(&exp, 0, sizeof(exp));
-	exp.tuple.src.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	exp.tuple.dst.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	exp.tuple.dst.protonum =3D IPPROTO_TCP;
-	exp.mask.src.ip =3D 0xFFFFFFFF;
-	exp.mask.dst.ip =3D 0xFFFFFFFF;
-	exp.mask.dst.protonum =3D 0xFFFF;
-	exp.mask.dst.u.tcp.port =3D 0xFFFF;
-
 	/* Only search first line. */=09
 	if ((tmp =3D strchr(data, '\n')))
 		*tmp =3D '\0';
=20
-	exp_amanda_info =3D &exp.help.exp_amanda_info;
 	for (i =3D 0; i < ARRAY_SIZE(conns); i++) {
 		char *match =3D strstr(data, conns[i]);
 		if (!match)
 			continue;
 		tmp =3D data =3D match + strlen(conns[i]);
-		exp_amanda_info->offset =3D data - amanda_buffer;
-		exp_amanda_info->port   =3D simple_strtoul(data, &data, 10);
-		exp_amanda_info->len    =3D data - tmp;
-		if (exp_amanda_info->port =3D=3D 0 || exp_amanda_info->len > 5)
+		port =3D simple_strtoul(data, &data, 10);
+		len =3D data - tmp;
+		if (port =3D=3D 0 || len > 5)
 			break;
=20
-		exp.tuple.dst.u.tcp.port =3D htons(exp_amanda_info->port);
-		ip_conntrack_expect_related(ct, &exp);
+		exp =3D ip_conntrack_expect_alloc();
+		if (exp =3D=3D NULL)
+			goto out;
+
+		exp->tuple.src.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		exp->tuple.dst.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+		exp->tuple.dst.protonum =3D IPPROTO_TCP;
+		exp->mask.src.ip =3D 0xFFFFFFFF;
+		exp->mask.dst.ip =3D 0xFFFFFFFF;
+		exp->mask.dst.protonum =3D 0xFFFF;
+		exp->mask.dst.u.tcp.port =3D 0xFFFF;
+
+		exp_amanda_info =3D &exp->help.exp_amanda_info;
+		exp_amanda_info->offset =3D data - amanda_buffer;
+		exp_amanda_info->port   =3D port;
+		exp_amanda_info->len    =3D len;
+
+		exp->tuple.dst.u.tcp.port =3D htons(port);
+
+		ip_conntrack_expect_related(exp, ct);
 	}
=20
 out:

--ulDeV4rPMk/y39in--

--QDd5rp1wjxlDmy9q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZ/0LXaXGVTD0i/8RAuLLAJ4lwrCuFfNGoQh/xDuVuQzRRkZFCACcDa2r
DMMVo+gaNUWPpIAAZQu8H9A=
=CU2z
-----END PGP SIGNATURE-----

--QDd5rp1wjxlDmy9q--
