From: Harald Welte <laforge@netfilter.org>
Subject: Re: ipq_set_verdict problem in bridge+iptables
Date: Mon, 14 Jul 2003 10:07:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714080728.GF6538@naboo>
References: <20030712222620.28732.48265.Mailman@kashyyyk> <001901c348ec$6dbbc5d0$e84ce9db@win2ken>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yong Li <sdssly@sina.com>
Content-Disposition: inline
In-Reply-To: <001901c348ec$6dbbc5d0$e84ce9db@win2ken>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2003 at 11:11:16AM +0800, Yong Li wrote:
> Hello All,
>=20
> I encountered a problem with the ipq_set_verdict function. I want to modi=
fy
> the packet content and size using the ipq_set_verdict function. However, I
> found I cannot change the IP packet size more than 400+ bytes. Is it a kn=
own
> issue?

what do you mean by 'I cannot' ? What happens?  Is an error returned to
the ipq_set_verdict() call?  Is the packet silently discarded?  Is the
packet truncated?

Anyway, it should work.  But if you exceed the outgoing interface's MTU,
I could imagine that no fragmentation happens...

> Thanks in advance!
> Yong

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/EmTAXaXGVTD0i/8RAiuRAJ9cS4YVCKqCbDq1RfTpZrZ9sJxCVgCeNRXs
Hevk0ofvvdieiqPzv3TEUgw=
=Qin4
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
