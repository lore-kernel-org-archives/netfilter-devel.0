From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPtables performance (fwd)
Date: Tue, 29 Apr 2003 16:34:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429143442.GD684@naboo.intranet.astaro.de>
References: <20030427130229.GG990@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0304281155450.24242-100000@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Cc: netfilter-devel@lists.netfilter.org, Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0304281155450.24242-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 01:25:59PM +0100, Chris Wilson wrote:
> We have already been using iptables-restore since last year, with a big
> increase in performance, but the basic problem still remains. Without this
> patch however, it still takes 15 seconds in mark_source_chains every time
> we change the ruleset on a large firewall. This is a significant delay
> when it needs to happen every time a VPN user connects, for example,
> before they can send traffic.

Yes, I can imagine.

> I don't claim to understand exactly how mark_source_chains works, but here
> is my argument that the patch does detect all loops.=20

I have to admit that I don't exactly remember all the details about
mark_source_chains without re-investigating it as well.  I did that now,
so I think I'm fit for further discussion  ;)

> It appears to me that loop check made by mark_source_chains is
> deterministic, so once we've visited a particular rule, and determined
> that there are no loops in the paths leading from it, then the rule is
> _safe_, and we don't need to check it again.

You are missing the other half of the functionality of
mark_source_chains:  It needs to write down (into the 'comefrom' field),
from which hooks the particular rule can be called.

There are matches (like the 'owner' match), that can only be used at
certain hooks (in our example: There is no socket owner at
NF_IP_FORWARD).

> However, the current algorithm in mark_source_chains is to check the rule
> once for every path leading _to_ it, despite the fact that each and every
> one of these checks will return precisely the same verdict.

Yes, this is (as stated above) to save for every rule from which hook it
could possibly be called.

> All that Robert's patch does is to add an array of "been" flags, one per
> rule, which tells us if the rule is a jump and we've checked it before. =
=20
> Since we're still running mark_source_chains and didn't return earlier,
> the rule did not cuase a loop then, and if nobody's changed the rules then
> it still does not cause a loop, and doesn't need to be checked again.

So how does this make sure that every rule will be flagged with the hook
numbers of all paths leading to it?

> Cheers, Chris.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+ro2CXaXGVTD0i/8RAsD3AJ9H1X8/Tue5xinoojzsO4IVBqq1AACfXgrv
ADxDHrGRRW0sR4aZKrdUTJo=
=oF46
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
