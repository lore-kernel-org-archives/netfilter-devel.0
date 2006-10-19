From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] iptables: ip6table version support and
 libip6t_multiport.fix
Date: Thu, 19 Oct 2006 15:06:44 +0900 (JST)
Message-ID: <200610190606.k9J66ksI028653@toshiba.co.jp>
References: <200610120811.k9C8B4Pg002384@toshiba.co.jp>
	<200610121729.36069@auguste.remlab.net>
	<200610130050.k9D0oj3O013113@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: rdenis@simphalempin.com, netfilter-devel@lists.netfilter.org,
	ljlane@debian.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <200610130050.k9D0oj3O013113@toshiba.co.jp>
	<452A7286.3080403@trash.net>
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


Hi, Patrick,

I've found the following your mail and would I be better to commit this=

until next version of iptables ?

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 09 Oct 2006 18:02:14 +0200

> We should consider moving away from using the kernel headers directly=
.=

> Breaking compilation of old iptables versions is not too bad IMO,
> old binaries will still work and someone compiling old iptables with
> a new kernel can just as well just compile a new version.
> =

> Unfortunately 1.3.6 won't compile with 2.6.19, so we might have to pu=
t
> out a new version soon.


From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Fri, 13 Oct 2006 09:50:44 +0900 (JST)

> =

> Hello,
> =

> > Le jeudi 12 octobre 2006 11:11, Yasuyuki KOZAKAI a =E9crit :
> > > ??? Did you send intended patch ? It includes XT_MULTI_PORTS as
> > > folows.
> > =

> > Hmm, probably resent the old one accidentally then.
> > =

> > Sending the correct patch as attachment to avoid further breakages.=

> =

> Thanks,
> =

> OK, I've update your patch (please see below comments in detail), and=
 also
> tested with kernel 2.4.33.3 and 2.6 linus tree and ip6tables build wi=
th
> headers in each of them.
> =

> If no objection, I'll commit the attached patch next week.
> =

> I appreciate if you tries to build with 2.4 kernel for such changes
> from next time.
> =

> =

> From: R=E9mi Denis-Courmont <rdenis@simphalempin.com>
> Date: Thu, 12 Oct 2006 17:29:35 +0300
> =

> > Index: iptables/include/ip6tables.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- iptables/include/ip6tables.h	(r=C3=A9vision 6687)
> > +++ iptables/include/ip6tables.h	(copie de travail)
> > @@ -33,6 +33,9 @@
> >  =

> >  	ip6t_chainlabel name;
> >  =

> > +	/* Revision of match (0 by default). */
> > +	u_int8_t revision;
> > +
> >  	const char *version;
> =

> The declaration for ip6t_get_revision is missing. That doesn't exist
> in 2.4 kernel.
> =

> > Index: iptables/ip6tables.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- iptables/ip6tables.c	(r=C3=A9vision 6687)
> > +++ iptables/ip6tables.c	(copie de travail)
> > @@ -193,6 +193,8 @@
> >  const char *program_name;
> >  char *lib_dir;
> >  =

> > +int kernel_version;
> =

> This isn't used anywhere.
> =

> Regards,
> =
