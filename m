From: Harald Welte <laforge@netfilter.org>
Subject: Re: A humble proposal
Date: Thu, 2 Oct 2003 21:51:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002195132.GA5758@sunbeam.de.gnumonks.org>
References: <7C9884991ADAE0479C14F10C858BCDF5122E46@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dx3gxGTqGHJq+217"
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
Content-Disposition: inline
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF5122E46@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dx3gxGTqGHJq+217
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 09:13:21AM -0700, Daniel Chemko wrote:
=20
> I would like to take pam_iptables and expand it beyond its simple
> structure. Features will include:
> [...]

Feel free to implement those features.

> Since PAM returns the originating IP address of the request, most of the
> rule functionality can be used to discriminate on a host level. I don't
> think many people would have a problem with this. The only side effect
> here is that a user behind a NAT'd network accessing the system opens
> the services to everyone behind that host. This is unavoidable.

I personally don't believe in this kind of 'security'.  The only way to
do this in a really secure way is to open a VPN tunnel to your firewall
and do the authentication related to the VPN protocol used.   Your
firewall ruleset can then have seperate rules for packets coming from
the VPN or packets outside of the VPN sessions.

> I have seen some of this functionality in Checkpoint, and I think that
> it would be immensely useful in the iptables community if it is adopted.

Just because a particular proprietary vendor offers a 'feature', it
doesn't necessarrily mean that we need to do a blind copy of that
feature.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dx3gxGTqGHJq+217
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fIHEXaXGVTD0i/8RAoPXAJ0fgb1np0i3DJ9mAfMsb6hRSSv/cwCeLhiZ
qpAchxyBL3Pz5KaFaMVmCGo=
=GipS
-----END PGP SIGNATURE-----

--dx3gxGTqGHJq+217--
