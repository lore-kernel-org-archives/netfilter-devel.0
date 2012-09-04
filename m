From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Tue, 4 Sep 2012 15:58:10 +0200
Message-ID: <20120904135810.GA12207@1984>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com>
 <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
 <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
 <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
 <20120903153121.GA19926@1984>
 <20120903192455.GA3527@1984>
 <CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com>
 <alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Sep 04, 2012 at 05:57:28AM +0200, Jan Engelhardt wrote:
>=20
> On Tuesday 2012-09-04 02:14, Maciej =C5=BBenczykowski wrote:
>=20
> >+<----->if (cs->target->alias =3D=3D NULL)^M
> >+<-----><------>strcpy(cs->target->t->u.user.name, cs->jumpto);^M
> >+<----->else^M
> >+<-----><------>strcpy(cs->target->t->u.user.name, cs->target->alias=
);^M
> >
> >I'd have probably written if (cs->target->alias) copy(alias) else co=
py(jumpto)
> >
> >doesn't this all really belong in the CT files now?
> >ie. libxt_CT.c not libxt_NOTRACK.c
>=20
> I think so too.
> Furthermore, I have refined Pablo's patch.
>=20
> 0. vcurrent was not updated, now done.
> 1. Loading libxt_NOTRACK.so would still ask the kernel for NOTRACK.0
>    (function "compatible_revision"), now addressed.
> 2. NOTRACK.0 can now directly map to CT.1, instead of going through C=
T.0.
> 3. Do away with libxt_NOTRACK.c, and resolve the dlopen call by
>    providing a symlink.
>=20
> Not solved:
> 4. Since NOTRACK now always maps to CT, "-j NOTRACK"
>    has become unusable on sufficiently old kernels.
>    Should we even bother?
>=20
> [ Agglomeration of two patches in git://git.inai.de/iptables master ]
> diff --git a/configure.ac b/configure.ac
> index 861f5b3..a45d9ab 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -2,8 +2,8 @@
>  AC_INIT([iptables], [1.4.15])
> =20
>  # See libtool.info "Libtool's versioning system"
> -libxtables_vcurrent=3D8
> -libxtables_vage=3D1
> +libxtables_vcurrent=3D9
> +libxtables_vage=3D0
> =20
>  AC_CONFIG_AUX_DIR([build-aux])
>  AC_CONFIG_HEADERS([config.h])
> diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
> index 218dc3a..92ac63d 100644
> --- a/extensions/GNUmakefile.in
> +++ b/extensions/GNUmakefile.in
> @@ -39,6 +39,7 @@ endif
>  #	Wildcard module list
>  #
>  pfx_build_mod :=3D $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcar=
d ${srcdir}/libxt_*.c)))
> +pfx_build_mod +=3D NOTRACK
>  @ENABLE_IPV4_TRUE@ pf4_build_mod :=3D $(patsubst ${srcdir}/libipt_%.=
c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
>  @ENABLE_IPV6_TRUE@ pf6_build_mod :=3D $(patsubst ${srcdir}/libip6t_%=
=2Ec,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
>  pfx_build_mod :=3D $(filter-out @blacklist_modules@,${pfx_build_mod}=
)
> @@ -100,6 +101,8 @@ lib%.oo: ${srcdir}/lib%.c
>  xt_RATEEST_LIBADD   =3D -lm
>  xt_statistic_LIBADD =3D -lm
> =20
> +libxt_NOTRACK.so: libxt_CT.so
> +	ln -s $< $@
> =20
>  #
>  #	Static bits
> diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
> index 27a20e2..8012a59 100644
> --- a/extensions/libxt_CT.c
> +++ b/extensions/libxt_CT.c
> @@ -248,6 +248,13 @@ static void ct_save_v1(const void *ip, const str=
uct xt_entry_target *target)
>  		printf(" --zone %u", info->zone);
>  }
> =20
> +static void notrack_tg_init(struct xt_entry_target *target)
> +{
> +	struct xt_ct_target_info_v1 *info =3D (void *)target->data;
> +
> +	info->flags |=3D XT_CT_NOTRACK;
> +}
> +
>  static struct xtables_target ct_target_reg[] =3D {
>  	{
>  		.family		=3D NFPROTO_UNSPEC,
> @@ -274,6 +281,19 @@ static struct xtables_target ct_target_reg[] =3D=
 {
>  		.x6_parse	=3D ct_parse_v1,
>  		.x6_options	=3D ct_opts_v1,
>  	},
> +	{
> +		.family		=3D NFPROTO_UNSPEC,
> +		.name		=3D "NOTRACK",
> +		.revision	=3D 0,
> +		.real_name	=3D "CT",
> +		.real_rev	=3D 1,
> +		.version	=3D XTABLES_VERSION,
> +		.size		=3D XT_ALIGN(sizeof(struct xt_ct_target_info_v1)),
> +		.userspacesize	=3D offsetof(struct xt_ct_target_info_v1, ct),
> +		.print		=3D ct_print_v1,
> +		.save		=3D ct_save_v1,
> +		.init		=3D notrack_tg_init,
> +	},

We also need to add support for real_rev 0 of the CT target. Just to
make sure that we don't break with old kernels.

I've pulled this and pushed out to the notrack-removal branch of
iptables. The idea would be to fix this issue above and to merge that
that couple of patches once 3.7-rc1 is released.
