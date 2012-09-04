From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Tue, 4 Sep 2012 05:57:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209040539040.9352@frira.zrqbmnf.qr>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com> <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com> <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr> <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
 <20120903153121.GA19926@1984> <20120903192455.GA3527@1984> <CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.inai.de ([5.9.24.206]:38538 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab2IDD5c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:57:32 -0400
In-Reply-To: <CAHo-Ooy=fg23B5TU7vL95V_-W=Fq+qxHFiycWwPGYBwrfVFdzQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-09-04 02:14, Maciej =C5=BBenczykowski wrote:

>+<----->if (cs->target->alias =3D=3D NULL)^M
>+<-----><------>strcpy(cs->target->t->u.user.name, cs->jumpto);^M
>+<----->else^M
>+<-----><------>strcpy(cs->target->t->u.user.name, cs->target->alias);=
^M
>
>I'd have probably written if (cs->target->alias) copy(alias) else copy=
(jumpto)
>
>doesn't this all really belong in the CT files now?
>ie. libxt_CT.c not libxt_NOTRACK.c

I think so too.
=46urthermore, I have refined Pablo's patch.

0. vcurrent was not updated, now done.
1. Loading libxt_NOTRACK.so would still ask the kernel for NOTRACK.0
   (function "compatible_revision"), now addressed.
2. NOTRACK.0 can now directly map to CT.1, instead of going through CT.=
0.
3. Do away with libxt_NOTRACK.c, and resolve the dlopen call by
   providing a symlink.

Not solved:
4. Since NOTRACK now always maps to CT, "-j NOTRACK"
   has become unusable on sufficiently old kernels.
   Should we even bother?

[ Agglomeration of two patches in git://git.inai.de/iptables master ]
diff --git a/configure.ac b/configure.ac
index 861f5b3..a45d9ab 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,8 +2,8 @@
 AC_INIT([iptables], [1.4.15])
=20
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=3D8
-libxtables_vage=3D1
+libxtables_vcurrent=3D9
+libxtables_vage=3D0
=20
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 218dc3a..92ac63d 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -39,6 +39,7 @@ endif
 #	Wildcard module list
 #
 pfx_build_mod :=3D $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard =
${srcdir}/libxt_*.c)))
+pfx_build_mod +=3D NOTRACK
 @ENABLE_IPV4_TRUE@ pf4_build_mod :=3D $(patsubst ${srcdir}/libipt_%.c,=
%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod :=3D $(patsubst ${srcdir}/libip6t_%.c=
,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod :=3D $(filter-out @blacklist_modules@,${pfx_build_mod})
@@ -100,6 +101,8 @@ lib%.oo: ${srcdir}/lib%.c
 xt_RATEEST_LIBADD   =3D -lm
 xt_statistic_LIBADD =3D -lm
=20
+libxt_NOTRACK.so: libxt_CT.so
+	ln -s $< $@
=20
 #
 #	Static bits
diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 27a20e2..8012a59 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -248,6 +248,13 @@ static void ct_save_v1(const void *ip, const struc=
t xt_entry_target *target)
 		printf(" --zone %u", info->zone);
 }
=20
+static void notrack_tg_init(struct xt_entry_target *target)
+{
+	struct xt_ct_target_info_v1 *info =3D (void *)target->data;
+
+	info->flags |=3D XT_CT_NOTRACK;
+}
+
 static struct xtables_target ct_target_reg[] =3D {
 	{
 		.family		=3D NFPROTO_UNSPEC,
@@ -274,6 +281,19 @@ static struct xtables_target ct_target_reg[] =3D {
 		.x6_parse	=3D ct_parse_v1,
 		.x6_options	=3D ct_opts_v1,
 	},
+	{
+		.family		=3D NFPROTO_UNSPEC,
+		.name		=3D "NOTRACK",
+		.revision	=3D 0,
+		.real_name	=3D "CT",
+		.real_rev	=3D 1,
+		.version	=3D XTABLES_VERSION,
+		.size		=3D XT_ALIGN(sizeof(struct xt_ct_target_info_v1)),
+		.userspacesize	=3D offsetof(struct xt_ct_target_info_v1, ct),
+		.print		=3D ct_print_v1,
+		.save		=3D ct_save_v1,
+		.init		=3D notrack_tg_init,
+	},
 };
=20
 void _init(void)
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
deleted file mode 100644
index ca58700..0000000
--- a/extensions/libxt_NOTRACK.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/* Shared library add-on to iptables to add NOTRACK target support. */
-#include <xtables.h>
-
-static struct xtables_target notrack_target =3D {
-	.family		=3D NFPROTO_UNSPEC,
-	.name		=3D "NOTRACK",
-	.version	=3D XTABLES_VERSION,
-	.size		=3D XT_ALIGN(0),
-	.userspacesize	=3D XT_ALIGN(0),
-};
-
-void _init(void)
-{
-	xtables_register_target(&notrack_target);
-}
diff --git a/include/xtables.h.in b/include/xtables.h.in
index db69c03..7993414 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -280,11 +280,13 @@ struct xtables_target
=20
 	struct xtables_target *next;
=20
-
 	const char *name;
=20
+	/* Real target behind this, if any. */
+	const char *real_name;
+
 	/* Revision of target (0 by default). */
-	u_int8_t revision;
+	u_int8_t revision, real_rev;
=20
 	u_int16_t family;
=20
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b191d5d..f0ebe15 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1286,8 +1286,17 @@ static void command_jump(struct iptables_command=
_state *cs)
=20
 	cs->target->t =3D xtables_calloc(1, size);
 	cs->target->t->u.target_size =3D size;
-	strcpy(cs->target->t->u.user.name, cs->jumpto);
-	cs->target->t->u.user.revision =3D cs->target->revision;
+	if (cs->target->real_name =3D=3D NULL) {
+		strcpy(cs->target->t->u.user.name, cs->jumpto);
+		cs->target->t->u.user.revision =3D cs->target->revision;
+	} else {
+		strcpy(cs->target->t->u.user.name, cs->target->real_name);
+		cs->target->t->u.user.revision =3D cs->target->real_rev;
+		fprintf(stderr, "WARNING: The %s target is obsolete. "
+		        "Use %s instead.\n",
+		        cs->jumpto, cs->target->real_name);
+	}
+
 	xs_init_target(cs->target);
 	if (cs->target->x6_options !=3D NULL)
 		opts =3D xtables_options_xfrm(ip6tables_globals.orig_opts, opts,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 03ac63b..5d8698d 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1295,8 +1295,18 @@ static void command_jump(struct iptables_command=
_state *cs)
=20
 	cs->target->t =3D xtables_calloc(1, size);
 	cs->target->t->u.target_size =3D size;
-	strcpy(cs->target->t->u.user.name, cs->jumpto);
-	cs->target->t->u.user.revision =3D cs->target->revision;
+	if (cs->target->real_name =3D=3D NULL) {
+		strcpy(cs->target->t->u.user.name, cs->jumpto);
+		cs->target->t->u.user.revision =3D cs->target->revision;
+	} else {
+		/* Alias support for userspace side */
+		strcpy(cs->target->t->u.user.name, cs->target->real_name);
+		cs->target->t->u.user.revision =3D cs->target->real_rev;
+		fprintf(stderr, "WARNING: The %s target is obsolete. "
+		        "Use %s instead.\n",
+		        cs->jumpto, cs->target->real_name);
+	}
+
 	xs_init_target(cs->target);
=20
 	if (cs->target->x6_options !=3D NULL)
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d818579..4758ddc 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -944,6 +944,10 @@ void xtables_register_target(struct xtables_target=
 *me)
 			xt_params->program_name, me->name);
 		exit(1);
 	}
+	if (me->real_name =3D=3D NULL) {
+		me->real_name =3D me->name;
+		me->real_rev  =3D me->revision;
+	}
=20
 	if (me->x6_options !=3D NULL)
 		xtables_option_metavalidate(me->name, me->x6_options);
@@ -976,16 +980,16 @@ static void xtables_fully_register_pending_target=
(struct xtables_target *me)
 		}
=20
 		/* Now we have two (or more) options, check compatibility. */
-		if (compatible_target_revision(old->name, old->revision)
-		    && old->revision > me->revision)
+		if (compatible_target_revision(old->real_name, old->real_rev)
+		    && old->real_rev > me->real_rev)
 			return;
=20
 		/* See if new target can be used. */
-		if (!compatible_target_revision(me->name, me->revision))
+		if (!compatible_target_revision(me->real_name, me->real_rev))
 			return;
=20
 		/* Prefer !AF_UNSPEC over AF_UNSPEC for same revision. */
-		if (old->revision =3D=3D me->revision && me->family =3D=3D AF_UNSPEC=
)
+		if (old->real_rev =3D=3D me->real_rev && me->family =3D=3D AF_UNSPEC=
)
 			return;
=20
 		/* Delete old one. */
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
