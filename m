From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: iptables on sparc64 platform?
Date: 15 Sep 2002 14:58:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032094701.28097.150.camel@tux>
References: <20020314153419.GA5152@margo.student.utwente.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-AfTVVjaJ8a4DyPElOViv"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Simon Oosthoek <simon@cal003100.student.utwente.nl>
In-Reply-To: <20020314153419.GA5152@margo.student.utwente.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-AfTVVjaJ8a4DyPElOViv
Content-Type: multipart/mixed; boundary="=-TgttfE71HGdGSbXMIeX0"


--=-TgttfE71HGdGSbXMIeX0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2002-03-14 at 16:34, Simon Oosthoek wrote:

> The reason I have doubts about the quality of the modules on 64 bit sparc=
 is
> that the iptables command gives an invalid argument error when using the =
-m
> limit option. The ipt_limit module is in memory (according to lsmod).

Hi Simon, sorry for the very very late reply.

It seems I made a patch for libipt_limit.c when I read this mail but it
seems I never sent it to anyone :( I found it when I was cleaning up a
bit.

Do you still have this problem?
I don't know if this patch will solve the problem but if you want you
can give it a try.

--=20
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-TgttfE71HGdGSbXMIeX0
Content-Disposition: attachment; filename=libipt_limit-diff
Content-Type: text/plain; name=libipt_limit-diff; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- netfilter/userspace/extensions/libipt_limit.c.orig	Tue Jul 30 11:56:40 =
2002
+++ netfilter/userspace/extensions/libipt_limit.c	Tue Jul 30 11:57:28 2002
@@ -183,7 +183,7 @@
     "limit",
     IPTABLES_VERSION,
     IPT_ALIGN(sizeof(struct ipt_rateinfo)),
-    offsetof(struct ipt_rateinfo, prev),
+    IPT_ALIGN(sizeof(struct ipt_rateinfo)),
     &help,
     &init,
     &parse,

--=-TgttfE71HGdGSbXMIeX0--

--=-AfTVVjaJ8a4DyPElOViv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA9hIPtWm2vlfa207ERApMGAJ9h5pKZ6RwAkFvYFn8cUJHc2MgkDgCfeG7T
sb1vsqfdjc6qmKgJHXTH7EA=
=dgGg
-----END PGP SIGNATURE-----

--=-AfTVVjaJ8a4DyPElOViv--
