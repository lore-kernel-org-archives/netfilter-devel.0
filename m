From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPQ Userspace Filtering
Date: Fri, 23 May 2003 22:05:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523200506.GT3077@sunbeam.de.gnumonks.org>
References: <20030516161823.31741.qmail@web10705.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk/CTwBz1VvfPIDp"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Minnis <jminnis@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030516161823.31741.qmail@web10705.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Pk/CTwBz1VvfPIDp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2003 at 09:18:23AM -0700, John Minnis wrote:
> Does anyone know of a way to determine if another
> userspace application has created an IPQ handler
> (NETLINK_FIREWALL socket)?  I understand that the only
> one may be used at a time, however currently the
> second one is allowed to open, and then all traffic is
> directed to this one.  Neither instance receives any
> indication that there is a conflict. I am using the
> intercept.c example code to test this.  My first
> preference would be to prevent the second socket from
> being opened until the first program exited.

IP queue is not designed with support for multiple processes.=20

Maybe you want to look into ipqmpd, the ip queue multiplex daemon.  It
allows multiple processes from usersapace use ip_queue.

> Thanks,
> John
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Pk/CTwBz1VvfPIDp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zn7yXaXGVTD0i/8RAk5VAJoDuCMqHNN+ZhEjNLX3LABGlDA7iACfdkYZ
BV84ETW+NA3la3zXCfKwzB0=
=NtZM
-----END PGP SIGNATURE-----

--Pk/CTwBz1VvfPIDp--
