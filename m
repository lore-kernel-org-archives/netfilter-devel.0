From: netfilter@interlinx.bc.ca
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Wed, 26 Feb 2003 17:18:17 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226221816.GA4557@pc.ilinx>
References: <200302262211.h1QMBUm21885@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200302262211.h1QMBUm21885@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2003 at 08:11:29AM +1100, Ian Latter wrote:
>=20
> Howdy netfilter-dude,

Howdy pardner.  :-)

>   Wouldn't most of your problems go away if you set the expectation
> on the outbound connection?

I do that.  And it works while there are outbound connections.  But as
I described in my last message, there might be some time (quite a bit
of time in fact) between outgoing connections.  Indeed, once you have
been on the network long enough and your address gets known to enough
other peers on the network, you will start to see enough incoming
connections that you no longer make outgoing connections to keep the
"minimum connections" count up.

Since there potentially can be no outgoing connections after the first
few, it is these incoming connections that need to keep the "flywheel"
(of inbound expectations) going.

> Ie.  If I was to alter my rsh module to
> do gnutella, on what you've said below, I would look for the one=20
> outbound connection (client to server --- or client to universe in p2p),
> setup an expectation on the inbound connections (universe to client)
> for either an unlimited or numbered count of each type, then handle
> these connections.

But the expectation will go away when either of a) it times out, or b)
the master connection goes away.  It is for both of these reasons that
the expectation needs to continually be renewed (even when your only
connections are inbound).  It needs to be attached to an ESTABLISHED
connection and not be timed out.

>   In this way you will also avoid hassles later with NAT ....

For inbound connections, I don't know that there are NAT issues yet.
I don't think anything in the payload needs to be altered.  I have not
looked that deeply yet.

> So, generally, my feeling from netfilter is that you track the
> outbound and expect the inbound ...

Generally, I agree with you -- for protocols where this is in fact the
case.

b.

--=20
Brian J. Murrell

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+XT0ol3EQlGLyuXARAqCzAKDXRnwraWQccs62y4pCmehR+6CxigCeNp0g
oiRglQiz+YU07VgJyzCNc9E=
=mU1X
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
--lrZ03NoBR/3+SXJZ--
