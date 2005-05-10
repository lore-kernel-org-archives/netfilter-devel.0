From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: 3896 pom-ng broken
Date: Tue, 10 May 2005 15:15:25 -0400
Message-ID: <debc30fc050510121564dd0703@mail.gmail.com>
References: <d5q4mb$fmo$1@sea.gmane.org> <20050510154354.GB28833@linuxace.com>
	<4280DBB3.9070905@ufomechanic.net>
	<debc30fc0505101214699d85b8@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <debc30fc0505101214699d85b8@mail.gmail.com>
Content-Disposition: inline
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

On 5/10/05, J=E9r=F4me Poulin <jeromepoulin@gmail.com> wrote:
> See my e-mail, posted the same problem / solution and got no answer,
> only 3 patchs apply with that new snapshot, other patch with no
> requirements or even with a valid requirement won't apply, only set,
> h323, goto and another apply, anyway see my other mails.
>=20
> On 5/10/05, Amin Azez <azez@ufomechanic.net> wrote:
> > Phil Oester wrote:
> >
> > >On Tue, May 10, 2005 at 12:15:19PM +0100, Amin Azez wrote:
> > >
> > >
> > >>This change
> > >>
> > >>http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/N=
etfilter_POM.pm?rev=3D3896&r1=3D3820&r2=3D3896
> > >>
> > >>breaks pom-ng for me, such that it fails to apply most of the pom
> > >>patches because 2.6.11 seems to be the wrong source version.
> > >>
> > >>
> > >Perhaps this was intentional...which specific patches don't work, and =
did you verify
> > >the 'Requires' statement in the info file fits your kernel?
> > >
> > >
> > conntrack-event-api/info
> > Title: conntrack event API
> > Author: Pablo Neira <pablo@eurodev.net>
> > Status: Testing
> > Repository: extra
> > Requires: linux >=3D 2.6.11
> >
> > I was patching 2.6.11.7
> >
> > Amin
> >
> >
>
