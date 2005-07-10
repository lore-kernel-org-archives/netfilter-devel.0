From: Harald Welte <laforge@netfilter.org>
Subject: Re: expire module issue
Date: Sun, 10 Jul 2005 16:12:15 +0200
Message-ID: <20050710141215.GG20465@sunbeam.de.gnumonks.org>
References: <20050706173023.GA3586@rover.pcbi.upenn.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOnUD/NgUx2c77Ud"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bryan Cardillo <dillo@seas.upenn.edu>
Content-Disposition: inline
In-Reply-To: <20050706173023.GA3586@rover.pcbi.upenn.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--GOnUD/NgUx2c77Ud
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 06, 2005 at 01:30:23PM -0400, Bryan Cardillo wrote:

>         I've been using the iptables libiptc code as a guide for
>         implementing the rule deletion, but since this is strictly a
>         deletion, I'd rather not put the entire ruleset parsing and
>         compilation code in the kernel ;)  Any ideas how I can patch
>         up hook_entry / underflow appropriately?  Is this even the
>         problem?

It sounds like it could be the source of your problem, yes.  The reason
why the linnux kernel has no support for parsing/compiling the ruleset
was not an artificial one... so you're basically tryign what was
intended not to work ;)

Unfortunately I don't have the time to analyze your code and/or the
associated problem :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GOnUD/NgUx2c77Ud
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0Sy/XaXGVTD0i/8RAt57AKCdUTBMdd1yaUHmCiftO7eInE8TmwCeICPp
assuZSn5G3aDbpQRq3Yt7nE=
=6pBE
-----END PGP SIGNATURE-----

--GOnUD/NgUx2c77Ud--
