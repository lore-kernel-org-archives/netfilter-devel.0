From: Harald Welte <laforge@netfilter.org>
Subject: Re: New logging module
Date: Sat, 30 Aug 2003 21:04:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030830190453.GE17715@sunbeam.de.gnumonks.org>
References: <200308251459.03014.mailinglists@futureware.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSVPcR81XVhxeM7P"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pg@futureware.at
Content-Disposition: inline
In-Reply-To: <200308251459.03014.mailinglists@futureware.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HSVPcR81XVhxeM7P
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2003 at 02:59:02PM +0200, Philipp G=FChring wrote:
> Hi,
>=20
> I developed a Netfilter module, that collects and logs the traffic of all=
 IP=20
> addresses of several subnets, and dumps the traffic log regulary in a sim=
ilar=20
> format as ipt_LOG, so that it can transparently replace the normal loggin=
g=20
> module.

Why did you do that?  I think it's from an architectural point of view
the wrong choice.  ipt_ULOG was invented for the sole reason that string
processing and parsing/interpretation of logged packets should not be
done inside a softirq inside the kernel.  All this should be offloaded
to userspace.

and: iptables rules are not an ideal infrastructure for accounting
anyway.

> It was developed to enhance the speed of our traffic analysis software, b=
y=20
> filtering and aggregating the packets directly in the kernel instead of t=
he=20
> userspace.

So what you really want is a session log, similar to netflow?  This
should be easy to implement with adding packet/byte counters to struct
ip_conntrack.  Several people have been working on session-log systems
based on netfilter/iptables.

> Many greetings,
> Philipp G=FChring

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HSVPcR81XVhxeM7P
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/UPVVXaXGVTD0i/8RAs6CAKCn3YFl78fDoITHFm16WLceFOZ+JwCeI8FC
6TZt/Rcbr527WxW+aDHvc5g=
=oH4d
-----END PGP SIGNATURE-----

--HSVPcR81XVhxeM7P--
