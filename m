From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT pat ch
Date: Sun, 9 Feb 2003 10:26:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209092640.GN13269@naboo.fugue.com>
References: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hl1kWnBARzJiTscN"
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Poon <Chris.Poon@TELUS.COM>
Content-Disposition: inline
In-Reply-To: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hl1kWnBARzJiTscN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2003 at 10:56:09AM -0700, Chris Poon wrote:
> Padding was the first way I think of how to solve it, but now that I
> look at it again, the problem is actually the size assumption of the
> mask - almost all helpers assumes a 16 bit mask.=20

Yes, this is correct.

> The PPTP patch breaks that assumption, and because of the nature of
> the patches, I wouldn't have modified all the places where the mask is
> filled out. Maybe the correct way is solve this is to make the field
> size change permanent in ip_conntrack_manip_proto and
> ip_conntrack_tuple, and change all the places that fill out the mask
> to use the right sized mask instead of 0xffff, which happens to break
> the big-endian machines but not the little endian machines. What do
> you think?

Yes, this is definitely the way to go.  If you want to provide me a
patch for this (against a plain 2.4.20 or 2.4.21-preX kernel), it would
be really great.  Otherwise I'll just put it on my TODO list, and I
don't know how long it will take...

> -----Original Message-----

Please stop full quoting on a mailinglist.  This is a very basic
netiquette rule... if people want to read the original posting, they
will use a mailreader that supports threading - or alternatively go to
the list archives and read the old postings.
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--hl1kWnBARzJiTscN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Rh7QXaXGVTD0i/8RAlRhAJ9tYYZnlIjjiwRdkT1QPunF2aj6pwCglYe1
LQKb0LC7o1OwtaizAF/KSO4=
=8Qa0
-----END PGP SIGNATURE-----

--hl1kWnBARzJiTscN--
