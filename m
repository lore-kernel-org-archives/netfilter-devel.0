From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] bugfix for ip_queue_maxlen sysctl
Date: Tue, 4 Nov 2003 17:00:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031104160016.GC31614@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Vw0j8UKbyX0bfpA"
Cc: James Morris <jmorris@intercode.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--6Vw0j8UKbyX0bfpA
Content-Type: multipart/mixed; boundary="rqzD5py0kzyFAOWN"
Content-Disposition: inline


--rqzD5py0kzyFAOWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

This is the 2.6.x merge of the patch I just sent for 2.4.x:

Unfortunately the current  ip_queue implementation keeps two variables
for the maximum queue length:  One that can be set via sysctl (but is
not used internally), and one that is used by the implementation, but
cannot be set by the user. (bugzilla.netfilter.org #150)

Please apply to the 2.6 tree.

Thanks to Jim Minter for spotting this bug.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rqzD5py0kzyFAOWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="89_ip_queue-maxlen.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/net/ipv4/netfilter/ip_queue.c	2003-10-31 08:37:57.000000000 +0100
+++ linux-new/net/ipv4/netfilter/ip_queue.c	2003-11-04 16:57:19.000000000 +=
0100
@@ -581,15 +581,14 @@
 	.notifier_call	=3D ipq_rcv_nl_event,
 };
=20
-static int sysctl_maxlen =3D IPQ_QMAX_DEFAULT;
 static struct ctl_table_header *ipq_sysctl_header;
=20
 static ctl_table ipq_table[] =3D {
 	{
 		.ctl_name	=3D NET_IPQ_QMAX,
 		.procname	=3D NET_IPQ_QMAX_NAME,
-		.data		=3D &sysctl_maxlen,
-		.maxlen		=3D sizeof(sysctl_maxlen),
+		.data		=3D &queue_maxlen,
+		.maxlen		=3D sizeof(queue_maxlen),
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec
 	},
--- linux/net/ipv6/netfilter/ip6_queue.c	2003-10-31 08:35:34.000000000 +0100
+++ linux-new/net/ipv6/netfilter/ip6_queue.c	2003-11-04 16:58:31.000000000 =
+0100
@@ -584,15 +584,14 @@
 	.notifier_call	=3D ipq_rcv_nl_event,
 };
=20
-static int sysctl_maxlen =3D IPQ_QMAX_DEFAULT;
 static struct ctl_table_header *ipq_sysctl_header;
=20
 static ctl_table ipq_table[] =3D {
 	{
 		.ctl_name	=3D NET_IPQ_QMAX,
 		.procname	=3D NET_IPQ_QMAX_NAME,
-		.data		=3D &sysctl_maxlen,
-		.maxlen		=3D sizeof(sysctl_maxlen),
+		.data		=3D &queue_maxlen,
+		.maxlen		=3D sizeof(queue_maxlen),
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec
 	},

--rqzD5py0kzyFAOWN--

--6Vw0j8UKbyX0bfpA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/p80QXaXGVTD0i/8RAg/2AKCscabz3WX1d4wWPOG996X/eo8ejwCcCj9a
iIEbLr1wxiThrnA1vDwy7hE=
=mxo5
-----END PGP SIGNATURE-----

--6Vw0j8UKbyX0bfpA--
