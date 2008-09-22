From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik-X3B1VOXEql0@public.gmane.org>
Subject: Re: netfilter kernel crash in ip_ct_refresh_acct /
	ip_conntrack with centos 5.x
Date: Mon, 22 Sep 2008 13:46:51 +0300
Message-ID: <20080922104651.GF13941@edu.joroinen.fi>
References: <012c01c91a91$a6962e50$4f0e3d95@DDQ3KCF1JDH>
	<20080922085336.GD13941@edu.joroinen.fi>
Reply-To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Return-path: <centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080922085336.GD13941-IaEqojUT1geFMl4oFT7ALQ@public.gmane.org>
List-Unsubscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.centos.org/pipermail/centos>
List-Post: <mailto:centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request-IFYaIzF+flcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Sender: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
Errors-To: centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Sep 22, 2008 at 11:53:36AM +0300, Pasi K=E4rkk=E4inen wrote:
> On Fri, Sep 19, 2008 at 03:55:22PM -0400, Jake Holmquist wrote:
> > > Hello!
> > >
> > > Has anyone seen this netfilter kernel crash?
> > >
> > > Images from the console of the crashed firewall:
> > > http://pasik.reaktio.net/centos5-kernel-crash/
> > >
> > > Firewall is HP DL360 G4 server running CentOS 5.x 32 bit.
> > >
> > > I've seen this firewall crashing multiple times, but I only started
> > investigating it lately..
> > >
> > > It has happened using CentOS 5.0, 5.1 and now also with 5.2. I'm no=
t sure
> > if
> > > it was the same bug earlier, but at least the last two times (with =
CentOS
> > 5.2)
> > > it has been the same, see screenshots.
> > >
> > > Last lines of the console output:
> > >
> > > EIP: [<f8af2c5c>] __ip_ct_refresh_acct+0xa1/0x129 [ip_conntrack] SS=
:ESP
> > 0068:c0724e4c
> > >  <0>Kernel panic - not syncing: Fatal exception in interrupt
> > >
> > > At the moment firewall is running CentOS 5.2, Linux kernel
> > 2.6.18-92.1.10.el5.centos.plus.
> > >
> > > Any tips how to resolve this?
> >=20
> >=20
> > Take a look here:
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D433661
> >=20
> > Looks like a test kernel is available....
> >=20
> >=20
> > We've been having this problem for quite some time - actually moved o=
ur
> > production box to RHEL 4.x
> >=20
>=20
> Thanks! This looks like a same bug I'm seeing..=20
>=20
> I think I'll try latest RHEL 5.3 test kernel on that fw box..
>=20

Just a followup to netfilter-devel too.. as it was missing from CC field.

So this seems to be Redhat/RHEL bug: https://bugzilla.redhat.com/show_bug=
.cgi?id=3D433661

-- Pasi
