From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ip_nat_irc or ip_conntrack_irc
Date: Fri, 14 Feb 2003 08:26:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030214072636.GH14794@sunbeam.de.gnumonks.org>
References: <001601c2d3f4$931b0e20$0201a8c0@muska>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: turbobee <turbobee@cox.net>
Content-Disposition: inline
In-Reply-To: <001601c2d3f4$931b0e20$0201a8c0@muska>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2003 at 11:44:51PM -0700, turbobee wrote:
> hi there, I've been using both of those modules for a while and they
> work quite well, but I noticed a small problem while using them that I
> don't think any one has found yet.  Using mIRC (I havn't tested this
> with another client), if you send a file with spaces and the "Fill
> Spaces" option is off (meaning the file spaces wont be compensated
> with under scores when sent), it wont go through.  Normally I would
> take the easy route out of this and just turn on fill spaces, but I
> serve with a channel that requires it to be off, I hope you can find
> time to help me iwth this issue, maybe it isnt even a bug, maybe its
> the fact that somethign is misconfigured.  I'm not sure, anyways, I
> hope to hear from your soon, thanks for yoru time.

Why doesn't anybody read http://www.netfilter.org/contact.html? We _do_
have a development mailinglist for this kind of stuff

Anyway, I don't see how spaces in filenames could affect conntrack or
NAT at all.  The conntrack/nat helpers don't deal with the filename at
all. =20

The only way for me to dig into this isue is:  Please send me some pcap
(tcpdump/tethereal) packet dumps of an IRC session.  I need one session
without spaces and one session with spaces to determine where the
difference in the packet format is.

> From
> Patrick Bostwick
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+TJosXaXGVTD0i/8RApPfAJ4syzJqJpinj7K8QwEWybVFlOjVrwCePpqq
KQOSpD04HWZ4xRgw2prqcv8=
=R3AP
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--
