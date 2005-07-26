From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: lockhelp.h missing
Date: Tue, 26 Jul 2005 14:25:04 -0400
Message-ID: <debc30fc05072611255b18720f@mail.gmail.com>
References: <debc30fc050721223469bd79d6@mail.gmail.com>
	<42E08A7A.6010204@trash.net>
	<20050722125205.GA17750@zion.homelinux.com>
	<debc30fc0507230238427b0290@mail.gmail.com>
	<20050723205206.GA29011@zion.homelinux.com>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050723205206.GA29011@zion.homelinux.com>
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

Just finished testing and the 2 patches works perfectly on
2.6.13-rc3-mm1 ! Apply with no warning and works, thanks :)

On 7/23/05, Sven Schuster <schuster.sven@gmx.de> wrote:
>=20
> Hi J=E9r=F4me,
>=20
> On Sat, Jul 23, 2005 at 05:38:23AM -0400, J=E9r=F4me Poulin told us:
> > Thanks, MMS compiled without any error or warning, h323 still misses
> > the file on its side.
>=20
> here is a patch against current pom-ng svn to update h323-conntrack-nat
> for current kernels. Please apply to your pom-ng and test it. Compile-
> tested with 2.6.13-rc3-mm1.
>=20
>=20
> Kind regards,
>=20
> Sven
>=20
> --
> Linux zion 2.6.13-rc3-mm1 #6 PREEMPT Mon Jul 18 19:42:52 CEST 2005 i686 a=
thlon i386 GNU/Linux
>  22:50:36 up 1 day,  6:00,  2 users,  load average: 0.36, 0.48, 0.27
>=20
>=20
>
