From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter dev kit
Date: Fri, 14 Feb 2003 09:34:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030214083436.GP14794@sunbeam.de.gnumonks.org>
References: <4F140198A7238B4088720E1E8A654ED2238B64@ice.merunetworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z1OTrj3C7qypP14j"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulas Kirazci <ukirazci@merunetworks.com>
Content-Disposition: inline
In-Reply-To: <4F140198A7238B4088720E1E8A654ED2238B64@ice.merunetworks.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Z1OTrj3C7qypP14j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2003 at 10:43:59AM -0800, Ulas Kirazci wrote:
> hi all.  is there an iptables developer kit out there for developing
> matchers as kernel modules?  the one i found (libiptq) seems only
> suited for developing user-level filters.  thank you.

You don't need any development kit. All you need is the netfilter
hacking HOWTO and the dozens of exaples present in the source code
(kernel as well as iptables and patch-o-matic). It is extremely easy to
write iptables extensions.

So the answer is: no.

> ulas

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--Z1OTrj3C7qypP14j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+TKocXaXGVTD0i/8RAv+/AJ48mHo8g2oMY02K+IVANCALO3imiACdGS1N
L2f3p/4F0eWkGuRmNsuwnjc=
=t372
-----END PGP SIGNATURE-----

--Z1OTrj3C7qypP14j--
