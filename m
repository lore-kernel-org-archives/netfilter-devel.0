From: "Carl Farrington" <carl@compsup.net>
Subject: RE: ip_conntrack_pptp
Date: Thu, 22 Jan 2004 19:14:41 -0000
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <739652C2AFA4834AAB5986A215F68CEC01654B@svr1.home.compsup.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>,
	"Netfilter Mailinglist" <netfilter@lists.netfilter.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

> -----Original Message-----
> From: Harald Welte [mailto:laforge@netfilter.org]
> Sent: 22 January 2004 17:54
> To: Jan Kaastrup
> Cc: 'Netfilter Development Mailinglist'; 'Netfilter Mailinglist'
> Subject: Re: ip_conntrack_pptp
>=20
> On Thu, Jan 22, 2004 at 04:57:26PM +0100, Jan Kaastrup wrote:
> > Hi Harald and all on this list.
> >
> > I have problems with ip_conntrack_pptp patch from POM-20031219
> > Does anyone know of this, or is it just me being stupid ?
>=20
> *sigh* *sigh* *sigh*.
>=20
> Does anybody actually ponder reading the 'README' file included in the
> patch-o-matic package?
>=20

I did and it works a treat thanks! (for nat) except that poptop doesn't
work properly anymore :-(. Suspect the ip_nat_pptp and ip_contrack_pptp
are grabbing the incoming pptp/gre stuff that's supposed to be going to
poptop. Any tips?


> --
> - Harald Welte <laforge@netfilter.org>
> http://www.netfilter.org/
