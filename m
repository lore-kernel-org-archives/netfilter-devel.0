From: "Gary W. Smith" <gary@primeexalia.com>
Subject: RE: pptp-conntrack problems
Date: Mon, 22 Aug 2005 07:10:07 -0700
Message-ID: <57F9959B46E0FA4D8BA88AEDFBE5829074D0@pxtbenexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Klavs Klavsen" <kl@vsen.dk>
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

That command is in the readme file.  But I think there was some noise
earlier this week stating that under 2.6.12+ you need to put
nf_conntrack or something in place.  I wasn't paying much attention as
I'm not there yet.

Gary

> -----Original Message-----
> From: Klavs Klavsen [mailto:kl@vsen.dk]
> Sent: Monday, August 22, 2005 7:08 AM
> To: Gary W. Smith
> Cc: netfilter-devel@lists.netfilter.org
> Subject: RE: pptp-conntrack problems
>=20
>=20
> On Mon, August 22, 2005 16:03, Gary W. Smith said:
> > Are you running "./runme extras" or just "./runme" by itself?
>=20
> Actually I didn't know about the "extras" switch - and I ven looked in
> runme - but didn't see it :(
>=20
> using that option, it shows me the pptp-conntrack - but it does not
apply
> (to 2.6.12.5):
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] Y
> newfile: 8 files in our way, unable to apply
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?]
>=20
> anyone know where to find a version for 2.6.12.5 - or perhaps this
applies
> to 2.6.13_rc6 ?
>=20
> --
> Regards,
> Klavs Klavsen, GSEC - kl@vsen.dk - http://www.vsen.dk
> PGP: 7E063C62/2873 188C 968E 600D D8F8  B8DA 3D3A 0B79 7E06 3C62
>=20
> "Those who do not understand Unix are condemned to reinvent it,
poorly."
>   --Henry Spencer
