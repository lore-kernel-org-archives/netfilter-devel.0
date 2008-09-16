From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik-X3B1VOXEql0@public.gmane.org>
Subject: Re: netfilter kernel crash in ip_ct_refresh_acct /
	ip_conntrack with centos 5.x
Date: Tue, 16 Sep 2008 19:51:59 +0300
Message-ID: <20080916165159.GP13941@edu.joroinen.fi>
References: <20080916073821.GL13941@edu.joroinen.fi>
	<alpine.LNX.1.10.0809161211140.24547@fbirervta.pbzchgretzou.qr>
Reply-To: CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Return-path: <centos-bounces-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0809161211140.24547-vVwEwcwQeYFPkBl3ERsXe1l1cybopEuJUBSOeVevoDU@public.gmane.org>
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

On Tue, Sep 16, 2008 at 12:12:45PM -0400, Jan Engelhardt wrote:
>=20
> On Tuesday 2008-09-16 03:38, Pasi K=E4rkk=E4inen wrote:
> >
> >Has anyone seen this netfilter kernel crash?=20
> >
> >Images from the console of the crashed firewall:
> >http://pasik.reaktio.net/centos5-kernel-crash/
>=20
> There have been some crashes reported; and some even fixed.
> As such you are encouraged to try a (much) newer kernel
> because 2.6.18 is outside the scope of the -stable team.
>

Yeah I know it's old.. but it's the only standard/supported kernel in=20
Redhat Enterprise Linux 5 (and CentOS 5).

I guess the best option would be to somehow figure out what the actual bu=
g
is, get (or make) a patch for it, and sent it for inclusion in RHEL 5.x e=
rrata
kernels..=20

-- Pasi
