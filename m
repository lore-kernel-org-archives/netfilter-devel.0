From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] NETFILTER: ipt_ULOG fix for last packet delay
Date: Sun, 1 Aug 2004 23:27:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801212705.GA18758@sunbeam2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
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


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This 2.4-patch was the only bugfix in my recent 2.6.x patch series.

At this point I don't think it's worth to further sync netfilter for
2.4.x and 2.6.x anymore, apart from bufixes, of course.

The ULOG target used to delay the last packet until another one was receive=
d.
This patch fixes the issue.

Please apply,=20
	Thanks.

Signed-off-by: Ruby Joker <ruby.joker@op.pl>
Signed-off-by: Harald Welte <laforge@netfilter.org>


--- a/net/ipv4/netfilter/ipt_ULOG.c	2004-05-10 04:32:27.000000000 +0200
+++ b/net/ipv4/netfilter/ipt_ULOG.c	2004-06-18 20:09:03.000000000 +0200
@@ -97,7 +97,6 @@
 static ulog_buff_t ulog_buffers[ULOG_MAXNLGROUPS];	/* array of buffers */
=20
 static struct sock *nflognl;	/* our socket */
-static size_t qlen;		/* current length of multipart-nlmsg */
 DECLARE_LOCK(ulog_lock);	/* spinlock */
=20
 /* send one ulog_buff_t to userspace */
@@ -116,7 +115,7 @@
=20
 	NETLINK_CB(ub->skb).dst_groups =3D (1 << nlgroupnum);
 	DEBUGP("ipt_ULOG: throwing %d packets to netlink mask %u\n",
-		ub->qlen, nlgroup);
+		ub->qlen, nlgroupnum);
 	netlink_broadcast(nflognl, ub->skb, 0, (1 << nlgroupnum), GFP_ATOMIC);
=20
 	ub->qlen =3D 0;
@@ -126,7 +125,7 @@
 }
=20
=20
-/* timer function to flush queue in ULOG_FLUSH_INTERVAL time */
+/* timer function to flush queue in flushtimeout time */
 static void ulog_timer(unsigned long data)
 {
 	DEBUGP("ipt_ULOG: timer function called, calling ulog_send\n");
@@ -257,12 +256,6 @@
 		ub->lastnlh->nlmsg_flags |=3D NLM_F_MULTI;
 	}
=20
-	/* if threshold is reached, send message to userspace */
-	if (qlen >=3D loginfo->qthreshold) {
-		if (loginfo->qthreshold > 1)
-			nlh->nlmsg_type =3D NLMSG_DONE;
-	}
-
 	ub->lastnlh =3D nlh;
=20
 	/* if timer isn't already running, start it */
@@ -271,6 +264,13 @@
 		add_timer(&ub->timer);
 	}
=20
+	/* if threshold is reached, send message to userspace */
+	if (ub->qlen >=3D loginfo->qthreshold) {
+		if (loginfo->qthreshold > 1)
+			nlh->nlmsg_type =3D NLMSG_DONE;
+		ulog_send(groupnum);
+	}
+
 	UNLOCK_BH(&ulog_lock);
=20
 	return;

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDWApXaXGVTD0i/8RAuqlAKCrn9MSkMdpg4FbMBNK6bpG/cD9jgCfUoHD
itLCC2gdv/aBpJuxpNdzMDo=
=h6N5
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
