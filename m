From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Wed, 17 Mar 2004 18:08:41 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079564920.2112.4.camel@localhost>
References: <Pine.LNX.4.44.0403172230510.11069-100000@filer.marasystems.com>
	 <4058C8C8.7030508@nk.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <4058C8C8.7030508@nk.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I use it all the time in the ISCS project -- just remember to use the -n
argument.  It is much, much faster.  However, you need to supply the
input file in the proper and not well documented format - John

On Wed, 2004-03-17 at 16:53, Victor Julien wrote:
> Hi Hendrik,
>=20
> This might be a big improvement, but it leaves me with one possible=20
> problem. When adding and removing rules on-the-fly i can't use this=20
> method, right?
>=20
> Wouldn't it be nice if there was an c function which i could call, which=20
> would do all the checking and other stuff the commandline iptables does,=20
>   but, because its a c-function, way faster? Would it be easy (or even=20
> possible) to implement such a function?
>=20
> Regards,
> Victor
>=20
> Henrik Nordstrom wrote:
> > On Wed, 17 Mar 2004, Cedric Blancher wrote:
> >=20
> >=20
> >>Le mer 17/03/2004 =C3=A0 19:46, Victor Julien a =C3=A9crit :
> >>
> >>>My program (written in c) creates rules by opening a pipe to=20
> >>>/sbin/iptables. However this is quite slow with large rulessets and on=
=20
> >>>slow hardware. Is there another way, like an iptables librarycall or=20
> >>>something?
> >>
> >>You could use iptables libs that stand in /usr/lib/iptables, just like
> >>iptables does.
> >=20
> >=20
> > Or actually the preferred interface for this type of operations is to u=
se=20
> > iptables-restore, the batch version of iptables. The speed difference f=
rom=20
> > using iptables-restore and direct calls is pretty minimal by any means.
> >=20
> > libiptc is an internal interface of the iptables source tree and is
> > subject to change at any time. This should not be used directly unless =
you=20
> > have very good reasons.
> >=20
> > Regards
> > Henrik
> >=20
--=20
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
