From: Harald Welte <laforge@netfilter.org>
Subject: Re: Re : Re: Logging conntrack with ip_conntrack_destroyed
Date: Tue, 17 Jun 2003 18:22:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030617162212.GK936@naboo>
References: <941489777.1055339533302.JavaMail.root@mailhost.elitecore.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQ77YLfPrO/qF/pM"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
Content-Disposition: inline
In-Reply-To: <941489777.1055339533302.JavaMail.root@mailhost.elitecore.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LQ77YLfPrO/qF/pM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2003 at 07:22:13PM +0530, Sumit Pandya wrote:
> Harald,
>    Here is my code. I avoided sending code in previous mail is just in
>    the good sense of mail size.

Well, as long as it is < 40k, it's fine.

regarding to your bug/oops:  Are you aware that you are trying to invoke
the filesystem layer from within a softirq?  I don't think that it's
safe to use filesystem operations outside system call or kernel thread=20
context.

>    Also this list has got many request of per connection accounting
>    support. Are you interested to support such a development? Could
>    you take this RFP for the developers concern?  Thanks,

I very much prefer a solution in userspace.  Something based on
ctnetlink notifiers and a logging daemon in userspace should be fine.

> -- Sumit
> P.S. Whenever I'm hopeless, Harald is there ;)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LQ77YLfPrO/qF/pM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+70AzXaXGVTD0i/8RAvgBAJ9aaatX42AE2//RMQAF/WrxeW4DhQCaA+Jg
l23B82tzOGyA4qOb/jd5SOs=
=eb5A
-----END PGP SIGNATURE-----

--LQ77YLfPrO/qF/pM--
