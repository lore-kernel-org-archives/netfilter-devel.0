From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Writing ALGs for protocols
Date: Fri, 18 Jun 2004 15:24:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040618132416.GA23490@obroa-skai.de.gnumonks.org>
References: <20040617044343.25563.qmail@web40804.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ashutosh Naik <a7ash@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20040617044343.25563.qmail@web40804.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 16, 2004 at 09:43:43PM -0700, Ashutosh Naik wrote:
> Hi Herald,

Hi!

I took the liberty to Cc the netfilter-devel mailinglist, so other
developers know what you are [planning to be]  working on.

> It was great listening to your talk in Bangalore not
> too long time ago. And I have been following your work
> in the kernel space for a long time.

Thanks a lot, you are welcome :)

> What I am particularly interested in, is writing ALGs
> for a lot of protocols and making them GPL. The FTP
> conntrack and nat modules are of tremendous help to me
> right now. I would like to implement a lot more.

great.

> Could you tell me a few links where I could get
> information about the protocols which fail behind a
> NAT, due to information in their payloads.. Could u
> send me the wish list, of protocols for which NAT
> modules have to be written ?

Just a list, off my head without further research:

SIP=20
	very complex, very difficult, already somebody working on it
	(see list archives, don't remember his name, works for epygi.de)

DirectX8=20
	already some code by USRobotics/Broadcom [from wlan router], but
	extremely insecure implementation.

X11=20
	already some insecure code in gnumonks.org CVS, needs improvement

ipsec/esp
	something like ip_masq_ipsec for 2.2.x (some code on the net)
	for passing on IKE+ESP sessions that don't support nat-traversal

h.323
	already in CVS, working, , but with a 'brute force'
	implementation.  This needs a real ASN.1 parser.

directplay
	Some unfinished work by Aristeu <aris@cathedrallabs.org>

icq
	Some unfinished work by Aristeu <aris@cathedrallabs.org>

smb/cifs
	There's a Microsoft Knowledge Base article about what to do
	to make it NAT-aware.

> I really want to get into this in a big way

this is great news! I'm looking forward to the results.

> Thanks a lot, and I hope U come again to Bangalore
> really soon

I was just Talking to Atul Chitnis yesterday.  Apparently there are
chances I will be able to attend LB/2004 in November/December.

> Regards
> Ashutosh
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA0u0AXaXGVTD0i/8RAmDTAJ99Dx78fMLfTo4hfpi6cU+gNjQLwQCfaIiU
UPxo4RLgswBUqKyiYftPMPM=
=gMhB
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
