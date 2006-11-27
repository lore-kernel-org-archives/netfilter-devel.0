From: Alan Ezust <alan.ezust@presinet.com>
Subject: Re: [PATCH 1/2]: conntrack: fix refcount leak when
	findingexpectation
Date: Mon, 27 Nov 2006 11:32:15 -0800
Message-ID: <200611271132.21563.alan.ezust@presinet.com>
References: <200611232315.kANNFVi3006773@toshiba.co.jp>
	<456B214A.5090207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1290757.CbPSEiulQ7";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <456B214A.5090207@trash.net>
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

--nextPart1290757.CbPSEiulQ7
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I noticed many messages indicating that things are being applied to conntra=
ck=20
and their related libs - but whenever I check my own checked out copy from=
=20
svn (rev 6698), it does not show me anything new to update, and it appears =
as=20
if nobody is committing to that particular part of the repo. Are you=20
committing these changes to a branch other than trunk?



On Monday 27 November 2006 09:32, Patrick McHardy wrote:
> Yasuyuki KOZAKAI wrote:
> > # Sorry, I forgot netfilter-devel, so resend.
> >
> > All users of __{ip,nf}_conntrack_expect_find() don't expect that
> > it increments the reference count of expectation.
>
> Applied, thanks.

=2D-=20
Alan Ezust            www.presinet.com
Presinet, inc         alan.ezust@presinet.com
           Victoria, BC, Canada

--nextPart1290757.CbPSEiulQ7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFaz1FsJbtw6GURksRAmOMAJ4ymyenYdkAvr073LqzuFM0KS07PACfQhoU
Al24Xq5q4SR1EK+x68/LQ8w=
=9UZh
-----END PGP SIGNATURE-----

--nextPart1290757.CbPSEiulQ7--
