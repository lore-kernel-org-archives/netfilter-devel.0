From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPtables performance (fwd)
Date: Sun, 4 May 2003 03:09:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030504010927.GN29373@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0305031129230.8273-100000@localhost> <Pine.LNX.4.33.0305031750040.8241-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFMLoheMaWcIEZAi"
Cc: Chris Wilson <chris@netservers.co.uk>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
	Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>,
	Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0305031750040.8241-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UFMLoheMaWcIEZAi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 03, 2003 at 07:39:46PM -0300, Andre Uratsuka Manoel wrote:
> 	Be my guest to implement it. I thought of doing it myself, but I'm
> still looking around and trying to understand all those structures and
> pointers and I am still trying to find my way around.

yes, the iptables structure is fairly complex :(

> 	Anyway, I was wondering, there is a variation that I think would
> be more efficient, and would avoid traversing the trees again for every
> hook.
>=20
> 	What is new is a stack of chains, initially empty, and you change
> the traversal slightly to put chains on the stack.

I don't like this idea, exactly because of the recursion problem.
The linux kernel has a very small stack (IIRC 8k on x86), and we really
don't want to introduce any limitations on the chain depth inside a
ruleset.

I will try to have an optimized version (similar to what you've been
proposing in your last mails) by tomorrow.

> 	Regards,
> 	Andre

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UFMLoheMaWcIEZAi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+tGhGXaXGVTD0i/8RAo48AKCofVKzT6LleTFBRdFxb2PxngxfWwCeIf9h
4Uhq15yQdfcOgDjYJbgeiCo=
=w6ui
-----END PGP SIGNATURE-----

--UFMLoheMaWcIEZAi--
