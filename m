From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter Inconsistency?
Date: Fri, 23 May 2003 22:01:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523200112.GR3077@sunbeam.de.gnumonks.org>
References: <20030515174951.32627.qmail@web20002.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vTfKKTivj/mQoluA"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brian Deep <brian_deep@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030515174951.32627.qmail@web20002.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vTfKKTivj/mQoluA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2003 at 10:49:51AM -0700, Brian Deep wrote:

>  I can add and delete rules fine and open up
> connections correctly using the SNAT rules, but if I
> change the source IP address on the SNAT rule I run
> into problems.  The SNAT rule is added correctly and
> verified using iptables userspace, but when the
> connection actually gets NAT'd, it gets the source IP
> address of the SNAT rule I had in previous.  I have
> tried manually inserting and appending  SNAT rules,
> but the connection is still NAT'd with the previous
> rule source IP.  At some point, this rule "time's out"
> and I am able to correctly add my SNAT rule in.

the NAT tables are only traversed for every first packet of a
connection. if you alter the ruleset, it will only work for new
connections.  All further packets within this connection will be
transformed according to what was determined by the first packet.

> Anyone have any thoughts?  And why the he** would it
> timeout after several minutes?

because then the entry times out from the conntrack table (you can
confirm this by watching /proc/net/ip_conntrack)

> Thanks,
> -- Brian

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vTfKKTivj/mQoluA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zn4IXaXGVTD0i/8RAn9UAKCbauxJ/X/0MgHuPm4nonbxF/3UtACdGDrD
H2Rga99+8a6SgAvMXZz+HR0=
=FDhT
-----END PGP SIGNATURE-----

--vTfKKTivj/mQoluA--
