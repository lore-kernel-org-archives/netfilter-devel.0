From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] linux-next: Tree for May 21 - build failure with
 netfilter on __nf_ct_helper_find()
Date: Thu, 22 May 2008 10:11:48 +1000
Message-ID: <20080522101148.fbabee96.sfr@canb.auug.org.au>
References: <20080521155936.466bbe86.sfr@canb.auug.org.au>
	<20080521113230.GA10830@linux.vnet.ibm.com>
	<20080521225214.507eb400.sfr@canb.auug.org.au>
	<4834239D.90500@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, apw@shadowen.org,
	Franck Bui-Huu <fbuihuu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4834239D.90500@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

On Wed, 21 May 2008 18:59:01 +0530 Kamalesh Babulal <kamalesh@linux.vne=
t.ibm.com> wrote:
>
> Stephen Rothwell wrote:
> >=20
> > Thanks for the report and patch.  This looks like it is probably br=
oken in
> > Linus' kernel.  What config did you use to get the error?
>=20
> Please find the .config file used to reproduce this build failure att=
ached.

Actually this is caused by the splitting out of the rcu stuff from list=
=2Eh
that is in linux-next, sorry.

Your patch looks good to me (reproduced below for new cc's).

Ingo, this should probably go into the rcu tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

Date: Wed, 21 May 2008 17:02:30 +0530
=46rom: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH] linux-next: Tree for May 21 - build failure with netfi=
lter on __nf_ct_helper_find()

The next-20080521 kernel build fails, on x86_64 machine=20

CC net/netfilter/nf_conntrack_helper.o
net/netfilter/nf_conntrack_helper.c: In function =E2=80=98__nf_ct_helpe=
r_find=E2=80=99:
net/netfilter/nf_conntrack_helper.c:58: error: implicit declaration of =
function =E2=80=98hlist_for_each_entry_rcu=E2=80=99
net/netfilter/nf_conntrack_helper.c:58: error: =E2=80=98hnode=E2=80=99 =
undeclared (first use in this function)
net/netfilter/nf_conntrack_helper.c:58: error: (Each undeclared identif=
ier is reported only once
net/netfilter/nf_conntrack_helper.c:58: error: for each function it app=
ears in.)
net/netfilter/nf_conntrack_helper.c:58: error: expected =E2=80=98;=E2=80=
=99 before =E2=80=98{=E2=80=99 token
net/netfilter/nf_conntrack_helper.c:50: warning: unused variable =E2=80=
=98mask=E2=80=99
net/netfilter/nf_conntrack_helper.c: In function =E2=80=98__nf_conntrac=
k_helper_find_byname=E2=80=99:
net/netfilter/nf_conntrack_helper.c:74: error: =E2=80=98hnode=E2=80=99 =
undeclared (first use in this function)
net/netfilter/nf_conntrack_helper.c:74: error: expected =E2=80=98;=E2=80=
=99 before =E2=80=98{=E2=80=99 token
net/netfilter/nf_conntrack_helper.c: In function =E2=80=98nf_conntrack_=
helper_register=E2=80=99:
net/netfilter/nf_conntrack_helper.c:117: error: implicit declaration of=
 function =E2=80=98hlist_add_head_rcu=E2=80=99
net/netfilter/nf_conntrack_helper.c: In function =E2=80=98nf_conntrack_=
helper_unregister=E2=80=99:
net/netfilter/nf_conntrack_helper.c:133: error: implicit declaration of=
 function =E2=80=98hlist_del_rcu=E2=80=99
make[2]: *** [net/netfilter/nf_conntrack_helper.o] Error 1
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2

This build error is because of the missing include file.I have tested
the patch for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.26-rc3/net/netfilter/nf_conntrack_helper.c	2008-05-20 20:=
24:14.000000000 +0530
+++ linux-2.6.26-rc3/net/netfilter/~nf_conntrack_helper.c	2008-05-22 00=
:17:32.000000000 +0530
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/rculist.h>
=20
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
--
To unsubscribe from this list: send the line "unsubscribe linux-next" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
