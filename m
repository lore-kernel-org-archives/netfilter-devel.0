From: Harald Welte <laforge@netfilter.org>
Subject: Re: 2 problems with my net/conntrack helper for MSN
Date: Sat, 31 May 2003 19:49:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531174959.GD29312@sunbeam.de.gnumonks.org>
References: <1054342550.961.68.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rYRijwbmzeJBcrGE"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Content-Disposition: inline
In-Reply-To: <1054342550.961.68.camel@exile>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rYRijwbmzeJBcrGE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2003 at 02:55:50AM +0200, Filip Sneppe (Cronos) wrote:

> I am trying to write a conntrack/NAT helper for MSN Messenger file
> transfers, and I am unable to solve two problems at the moment.
>=20
> Problem 1. Summary: Can I call ip_conntrack_change_expectation()
>            from ip_conntrack_msn, and if so, how do I do this properly ?

hm, I don't see why you shouldn't be able to do so.=20
> If A wants to send a file to host B, and B accepts this,=20
> Host A sends its IP+port to a switchboard server.
> On Nat box A, this allows us to set up an expectation
> like this:
>=20
> ?:? -> IP_A:port_A
>=20
> We have no idea what IP may be connecting to host A as
> we only have a connection to the switchboard server.

exactly like the IRC DCC case

> Now imagine a scenario where Host A and B are behind the=20
> same NAT box:

> Now what happens is, when host A offers its file for download,=20
> an expectation is created on the NAT box when Host A offers=20
> the accepted file:
>=20
> ?:? -> IP_A:port_A
>=20
> But a switchboard server will inform host B that it can
> connect to host A to download the file.
> ip_conntrack_msn tries to create a second expectation:
>=20
> IP_B:? -> IP_A:port_A

This is true.  It was never solved for the IRC case.  I though it is a
not too common case, and didn't further care about the problem.

> Now, my idea is that, if both hosts are behind the same
> NAT machine, and the creation of the second expectation=20
> fails with -EBUSY, the expectation that already exists
> should be changed to incorporate the additional information
> about the IP address of host B.

This should work, yes.

> Now, I don't know how to call ip_conntrack_change_expected()
> from within a conntracker. More specifically, I don't
> know how to get a pointer to the existing expectation
> in a clean way (well, I couldn't even get to this info
> by copying bits and pieces from ip_conntrack_core.c
> since things turned out to be really messy quickly).
> What would be the recommended way to do this ?

It isn't too difficult. You iterate over the sibling_list and call
exp_for_packet() on every item. =20

The pptp code needs to delete expectations on the list from within the
conntrack helper, see
http://cvs.netfilter.org/netfilter-extensions/helpers/pptp/ip_conntrack_ppt=
p.c
and search for other_exp.

Since you're using F_REUSE_EXPECT, I assume that there can always be one
file transfer per client connection.  This would mean that even calling
exp_for_packet is not necessarry.

> Problem 2. Summary: I don't think my NAT helper's "help" function=20
>            is getting called !? What is happening ?

> I have absolutely no idea why I cannot see any
> logging messages from the NAT module's help() function...

Neither have I, sorry.

> Thanks in advance,
> Filip
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rYRijwbmzeJBcrGE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2OtHXaXGVTD0i/8RAh6dAKCRYJkUjnTkuXhpDJAYE4Yci+Rx2ACfWcnE
vn+6RUvf8Ye9kWbqI8w/OcM=
=dBsX
-----END PGP SIGNATURE-----

--rYRijwbmzeJBcrGE--
