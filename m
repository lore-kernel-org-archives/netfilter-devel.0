From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Sun, 21 Sep 2003 16:05:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921140546.GB20986@sunbeam.de.gnumonks.org>
References: <20030905115534.GD665@obroa-skai.de.gnumonks.org> <3F5D91DC.3030706@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3F5D91DC.3030706@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2003 at 06:39:56PM +1000, Philip Craig wrote:
> When you do this, you will need the attached patches. =20

I'm finally at home again, being able to test PPTP with multiple
machines.  Expect a new pptp-conntrack-nat.patch later today.

> natcore-noexpecthelper.patch is related to 25natcore-nohelper.patch
> which was applied in 2.4.22.  25natcore-nohelper.patch stopped us
> from calling ip_nat_helper->help() when there were no manips, but
> we were still calling ip_nat_helper->expect().  This was corrupting
> the call IDs in the GRE packets.

mh. this is a real problem.  However, I am now convinced that
25_natcore-nohelper.patch was the wrong way to address the problem
anyway (see below).

> pptp-grekeymapdestroy.patch does some more cleaning up when freeing
> the unused second expectation.

ok, applied to netfilter-extensions CVS repository

> I now have pptp connection tracking working using linux 2.4.22,
> the latest patch from netfilter/patch-o-matic/extra, the latest
> files from netfilter-extensions/helpers/pptp, and the attached
> two patches.

great.  NAT works also?

> 25natcore-nohelper.patch fixed the problem where we were doing
> NAT for connections even if there was no matching NAT rules.
> However, we now have the opposite problem in that we don't do
> NAT even if we should.  This is because this patch bases the
> decision on the number of manipulations, but it is possible to
> match a NAT rule and have no manipulations.
>=20
> The impact of this is that I cannot guarentee unique call IDs for
> local connections when doing masquerading, since they usually have
> no manipulations (they will occassionally have a port manip).
>=20
> The only solution I can see for this problem is to add another
> field to ip_nat_info to determine whether a NAT rule was matched.

No, this is too complicated.  Let's try to thing again about what we
want to achieve:

1) unique call ID between every (srcip,dstip) tuple.  This is needed
   for distinguishing GRE packets for different calls

This is different to TCP/UDP port numbers in the 'normal' case.  The NAT
core deals with this in the FTP/IRC case for TCP port numbers, because
at the time the number is first used (PORT command, ...), the tuple for
the expectation is alrady complete.

In the PPTP case, however, we only have half the tuple when the CallID
is sent to the PAC, and the full tuple once the CallID from the PAC is
received :(

Thus, my initial solution (until the 25_natcore-nohelper.patch) was to
_always_ mangle the PNS->PAC callID to the TCP source port, independent
of any NAT rules present or not.  This would prevent multiple PPTP Calls
within one PPTP Session, but I've never seen such operation anyway.  The
TCP Source Port (after mangling, see below) has to be unique between two
IP addresses, since the destination port is fixed to 1723

However, there were some problems with running a PPTP daemon on the PPTP
NAT box at the same time, and I never really understand the source of
the problem [most likely because I didn't have enough time].  So I went
for the 'quick fix now, real solution later' approach, that ended up
with the 25_natcore-nohelper.patch.

I am now even more convinced that this is the wrong way to solve the
problem.  Adding your patch would make the behaviour consistent (don't
call expect if the master's help was never called)... but the problem of
non-unique CallID's remains.

So what I'm doing now, is to revert the 25_natcore_nohelper.patch and
see what the real problem with locally NAT'ed connections was/is.

> The second concern is that I believe we choose the NATed call ID
> based on the TCP source port prior to source NAT, which means we
> may not get a unique call ID.  If you agree this is a problem
> then I can try to fix it.

Yes, this is a problem.  If you want to work on a fix, I'd be more to
happy to integrate it.

> Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
> SnapGear - Custom Embedded Solutions and Security Appliances

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bbA6XaXGVTD0i/8RAu7FAJ95UvlggAKhr+9R8Gj0jCjzXjAW0ACfTlL0
UtRYA4ndDvPGg6bnTfLT2jI=
=cV9I
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
