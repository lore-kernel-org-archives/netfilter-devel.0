From: Harald Welte <laforge@netfilter.org>
Subject: Re: Accessing iptables from within an application...
Date: Sun, 27 Apr 2003 14:34:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427123431.GT990@sunbeam.de.gnumonks.org>
References: <20030326145319.GT21953@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0303261733140.25652-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FiqEyLLt06qkB6ow"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Stamfest <peter@stamfest.at>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303261733140.25652-100000@peter.stamf.pr.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FiqEyLLt06qkB6ow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry for my very late reply, but I tend to not reply too verbosely
about issues that are assumed to be well-known.

On Wed, Mar 26, 2003 at 05:54:46PM +0100, Peter Stamfest wrote:

> 1 libiptc.a, libip6tc.a plus the iptables.o and ip6tables.o files contain=
=20
>   most of what is needed for an API

I don't think so.

> 2 the splitting of libiptc and libip6tc  using a common libiptc.c and=20
>   #including it is not an example of "good" C-programming, however, the=
=20
>   fact that it (libiptc.c) contains functions common to both libraries=20
>   leads to trouble when using BOTH ipv4 and ipv6 versions.

yes, we are aware of that.

> 3 The modules and the libraries are STDOUT-centric. So many printfs all=
=20
>   over the place. And sometimes this is the only way to get at some=20
>   information.

true.

> 4 There is no proper way to query a module for its configuration settings=
=20
>   besides the stuff that just printf's it.

true.

> Some possible solutions:

The problem is not that we don't know of solutions.  I've presented an
outlind of my libiptables / libpkttables approach quite a couple of
times. Please have a look at
http://cvs.netfilter.org/netfilter/iptables2/libiptables/README

> I know that the proposed changes are at the core of the iptables
> utilities, but eventually something will have to be done about it.=20

Yes, yes, yes.  Now if anybody could invent some device that triples my
available time, I would be happy to implement all of this...

> I would like to compare this to eg. rpm and its librpm: did anybody
> think about an API when first inventing something like RPM?? I think
> the same thing happened to iptables.

again, true.

> peter

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FiqEyLLt06qkB6ow
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q85XXaXGVTD0i/8RAkAZAJ0WHn0VPuobwN87j4qAmakS2T/uZACeP8T9
FzeS5x7/ad69N6LtrN9lJaE=
=5tC7
-----END PGP SIGNATURE-----

--FiqEyLLt06qkB6ow--
