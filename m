From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack_core: port to module_param
Date: Mon, 18 Oct 2004 15:45:50 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041018134550.GH21927@sunbeam.de.gnumonks.org>
References: <200410160010.40500.michal@rokos.info>
	<200410172131.i9HLVrVF010252@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TdkiTnkLhLQllcMS"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200410172131.i9HLVrVF010252@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--TdkiTnkLhLQllcMS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 18, 2004 at 06:31:52AM +0900, Yasuyuki Kozakai wrote:
> And, I'm changing many parts and afraid of double work. After more some
> changes and tests, I'll send the latest nf_conntrack (or commit it to tree
> in netfilter site). I use the branch for nf_conntrack in USAGI tree as
> snapshot only. Moreover, I think that almost people check nf_conntrack
> in only netfilter site.

Plese note that we have migrated from CVS to subversion meanwhile.  I
will give you a subversion key and instructions in seperate private
email laater today.

I'm looking forward to see your synchronized nf_conntrack version, let's
hope we can include it soon.

> Regards,
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TdkiTnkLhLQllcMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBc8kOXaXGVTD0i/8RAv4hAKCPVUGZgT/lOF59G7hEEjmqEJnIcQCeNHtB
/rFDnmjZ+9TJyAImiyIZceU=
=ULSy
-----END PGP SIGNATURE-----

--TdkiTnkLhLQllcMS--
