From: vecna@s0ftpj.org
Subject: Re: PATCH: extra conntrack stats
Date: Mon, 28 Apr 2003 11:13:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428091332.GB29390@dns2.italway.it>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200304192142.h3JLg1S03466@fokkensr.vertis.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: multipart/mixed; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2003 at 11:42:01PM +0200, Rolf Fokkens wrote:
> Hi!
>=20
> This patch adds a little statistical information to the connection tracki=
ng:
> the number of packets and bytes that have gone throught each connection.

in attach I've put a simple patch for make proc entry that report number of
connection tracked, if anyone is interesting ... I've used them because
cat /proc/net/ip_conntrack | wc -l is too low with a large number of=20
connection tracked.

in addiction, for large tracking of connection, I think that the problem
is on the manage of linked list, I'm thinking to implement a system for=20
apply merge sort over sortder array of connection hashs, did you think
that this should be a good idea ?=20

bye

--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="counter.diff"
Content-Transfer-Encoding: quoted-printable

--- kernel-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c	2002-11-29 02:53:1=
5.000000000 +0300
+++ linux/net/ipv4/netfilter/ip_conntrack_core.c	2003-04-28 13:23:28.000000=
000 +0400
@@ -61,7 +61,8 @@
 LIST_HEAD(protocol_list);
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size =3D 0;
-static int ip_conntrack_max =3D 0;
+static unsigned ip_conntrack_max =3D 0;
+static unsigned ip_conntrack_cnt =3D 0;
 static atomic_t ip_conntrack_count =3D ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
@@ -640,8 +641,9 @@
=20
 	hash =3D hash_conntrack(tuple);
=20
-	if (ip_conntrack_max &&
-	    atomic_read(&ip_conntrack_count) >=3D ip_conntrack_max) {
+	ip_conntrack_cnt =3Datomic_read(&ip_conntrack_count);
+=09
+	if (ip_conntrack_max && ip_conntrack_cnt >=3D ip_conntrack_max) {
 		/* Try dropping from random chain, or else from the
                    chain about to put into (in case they're trying to
                    bomb one hash chain). */
@@ -1348,8 +1350,12 @@
 #define NET_IP_CONNTRACK_MAX 2089
 #define NET_IP_CONNTRACK_MAX_NAME "ip_conntrack_max"
=20
+#define NET_IP_CONNTRACK_CNT 2090
+#define NET_IP_CONNTRACK_CNT_NAME "ip_conntrack_cnt"
+
 #ifdef CONFIG_SYSCTL
-static struct ctl_table_header *ip_conntrack_sysctl_header;
+static struct ctl_table_header *ip_conntrack_sysctl_hdr_max;
+static struct ctl_table_header *ip_conntrack_sysctl_hdr_cnt;
=20
 static ctl_table ip_conntrack_table[] =3D {
 	{ NET_IP_CONNTRACK_MAX, NET_IP_CONNTRACK_MAX_NAME, &ip_conntrack_max,
@@ -1366,6 +1372,23 @@
 	{CTL_NET, "net", NULL, 0, 0555, ip_conntrack_dir_table, 0, 0, 0, 0, 0},
 	{ 0 }
 };
+
+static ctl_table ip_conntrack_t_cnt[] =3D {
+	{ NET_IP_CONNTRACK_CNT, NET_IP_CONNTRACK_CNT_NAME, &ip_conntrack_cnt,
+	sizeof(ip_conntrack_cnt), 0644,  NULL, proc_dointvec },
+	{ 0 }
+};
+
+static ctl_table ip_conntrack_dir_t_cnt[] =3D {
+	{ NET_IPV4, "ipv4", NULL, 0, 0555, ip_conntrack_t_cnt, 0, 0, 0, 0, 0},
+	{ 0 }
+};
+
+static ctl_table ip_conntrack_root_t_cnt[] =3D {
+	{CTL_NET, "net", NULL, 0, 0555, ip_conntrack_dir_t_cnt, 0, 0, 0, 0, 0},
+	{ 0 }
+};
+
 #endif /*CONFIG_SYSCTL*/
=20
 static int kill_all(const struct ip_conntrack *i, void *data)
@@ -1378,7 +1401,10 @@
 void ip_conntrack_cleanup(void)
 {
 #ifdef CONFIG_SYSCTL
-	unregister_sysctl_table(ip_conntrack_sysctl_header);
+	/* max of connection tracked */
+	unregister_sysctl_table(ip_conntrack_sysctl_hdr_max);
+	/* counter of connection tracked */
+	unregister_sysctl_table(ip_conntrack_sysctl_hdr_cnt);
 #endif
 	ip_ct_attach =3D NULL;
 	/* This makes sure all current packets have passed through
@@ -1462,9 +1488,14 @@
    the CONFIG_SYSCTL unless you don't want to detect errors.
    Grrr... --RR */
 #ifdef CONFIG_SYSCTL
-	ip_conntrack_sysctl_header
+	ip_conntrack_sysctl_hdr_max
 		=3D register_sysctl_table(ip_conntrack_root_table, 0);
-	if (ip_conntrack_sysctl_header =3D=3D NULL) {
+	if (ip_conntrack_sysctl_hdr_max =3D=3D NULL) {
+		goto err_free_ct_cachep;
+	}
+	ip_conntrack_sysctl_hdr_cnt
+		=3D register_sysctl_table(ip_conntrack_root_t_cnt, 0);
+	if (ip_conntrack_sysctl_hdr_cnt =3D=3D NULL) {
 		goto err_free_ct_cachep;
 	}
 #endif /*CONFIG_SYSCTL*/

--aVD9QWMuhilNxW9f--

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rPC8qso6AcJ1LUsRAvf3AJ9MN7C3baTAsngj5V0/4vC19SYqDwCfYaWJ
oNCERnn5J7wMaXTgJw94S/s=
=uNyh
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
