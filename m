From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU (Patrick McHardy)
Date: Sun, 16 Feb 2003 21:01:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030216200158.GB29764@sunbeam.de.gnumonks.org>
References: <20030215232635.25928.78900.Mailman@kashyyyk> <15950.60635.389199.836425@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15950.60635.389199.836425@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2003 at 05:43:55PM -0800, Don Cohen wrote:
> I'm also more than a little confused.
> My understanding is that the UDP user can't receive fragments, just a=20
> defragmented "datagram", from which he can't tell whether or how it
> was fragmented.  Is this correct?

yes, at least as long as we are talking about a user using the standard
socket API and the UDP/IP stack - not talking about raw socktets.

>  > What about storing the biggest fragment size of a packet at
>  > defragmentation and refragmenting the packet with that size at
>  > POST_ROUTING if MTU is not smaller.
> So at this point I gather the goal is the other side of the
> robustness principle - trying to make something work that probably=20
> shouldn't have been tried to begin with.  Are there lots of other
> things out there that play the same (questionable?) tricks?

if you want to do stateful IP filtering with _transparent_ fragment
behaviour, I see two possible options:

1) hold back all individual fragments, once you receive them. once you
have all fragments, defragment to an internal buffer, but keep the
fragments.  using the defragmented copy you can consult your ruleset and
then forward all fragments in case the packet is allowed to pass.

2) do what I have been proposing: defragment, save the fragment
sizes/offsets and re-fragment in exactly the same way.

I don't know what other (proprietary) competitors do.  But I cannot
think of a different 'perfect' solution.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+T+42XaXGVTD0i/8RAopSAJ9eMygyWDHrjupPWALRb9S+1TzCcwCfS4Ti
nCL9ngMePgcYsS2RbtnCsNM=
=NP2z
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
