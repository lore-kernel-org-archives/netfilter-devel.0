From: Harald Welte <laforge@netfilter.org>
Subject: Re: raw.patch needs defrag at LOCAL_OUT
Date: Sat, 1 Nov 2003 20:01:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031101190105.GA1536@sunbeam.de.gnumonks.org>
References: <20031101183812.GL15184@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031101183812.GL15184@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 01, 2003 at 07:38:12PM +0100, Harald Welte wrote:

> I'll prepare a fix (need it working for my own NFS server).

please see the attached fix (I didn't bother to merge it with
patch-o-matic, since IIRC you also have pending changes left)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="raw.patch-localout-defrag.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.23-pre7-oldraw/net/ipv4/netfilter/ip_conntrack_standalone.c	2=
003-11-01 19:53:31.000000000 +0100
+++ linux-2.4.23-pre7-nfpom2410/net/ipv4/netfilter/ip_conntrack_standalone.=
c	2003-11-01 19:44:08.000000000 +0100
@@ -257,6 +257,9 @@
 static struct nf_hook_ops ip_conntrack_in_ops
 =3D { { NULL, NULL }, ip_conntrack_in, PF_INET, NF_IP_PRE_ROUTING,
 	NF_IP_PRI_CONNTRACK };
+static struct nf_hook_ops ip_conntrack_defrag_local_out_ops
+=3D { { NULL, NULL }, ip_conntrack_defrag, PF_INET, NF_IP_LOCAL_OUT,
+	NF_IP_PRI_CONNTRACK_DEFRAG };
 static struct nf_hook_ops ip_conntrack_local_out_ops
 =3D { { NULL, NULL }, ip_conntrack_local, PF_INET, NF_IP_LOCAL_OUT,
 	NF_IP_PRI_CONNTRACK };
@@ -375,13 +378,18 @@
=20
 	ret =3D nf_register_hook(&ip_conntrack_defrag_ops);
 	if (ret < 0) {
-		printk("ip_conntrack: can't register pre-routing hook to defrag.\n");
+		printk("ip_conntrack: can't register pre_routing defrag hook.\n");
 		goto cleanup_proc;
 	}
+	ret =3D nf_register_hook(&ip_conntrack_defrag_local_out_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register local_out defrag hook.\n");
+		goto cleanup_defragops;
+	}
 	ret =3D nf_register_hook(&ip_conntrack_in_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register pre-routing hook.\n");
-		goto cleanup_defragops;
+		goto cleanup_defraglocalops;
 	}
 	ret =3D nf_register_hook(&ip_conntrack_local_out_ops);
 	if (ret < 0) {
@@ -419,6 +427,8 @@
 	nf_unregister_hook(&ip_conntrack_local_out_ops);
  cleanup_inops:
 	nf_unregister_hook(&ip_conntrack_in_ops);
+ cleanup_defraglocalops:
+	nf_unregister_hook(&ip_conntrack_defrag_local_out_ops);
  cleanup_defragops:
 	nf_unregister_hook(&ip_conntrack_defrag_ops);
  cleanup_proc:

--- linux-2.4.23-pre7-oldraw/net/ipv4/netfilter/ip_conntrack_core.c	2003-11=
-01 19:53:31.000000000 +0100
+++ linux-2.4.23-pre7-nfpom2410/net/ipv4/netfilter/ip_conntrack_core.c	2003=
-11-01 19:40:32.000000000 +0100
@@ -812,9 +890,18 @@
 	int set_reply;
 	int ret;
=20
+	/* Never happen */
+	if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
+		if (net_ratelimit()) {
+		printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=3D%u)\n",
+		       (*pskb)->nh.iph->protocol, hooknum);
+		}
+		return NF_DROP;
+	}
+
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |=3D NFC_UNKNOWN;
=20
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */


--YZ5djTAD1cGYuMQK--

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pALxXaXGVTD0i/8RAvhJAKCBplhciRNQePwtZf1kNLbiGpcyzQCffaE1
LcwmPPIjrW7wWRGy04yE+do=
=yxp5
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
