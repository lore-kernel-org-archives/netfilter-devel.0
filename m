From: wzt wzt <wzt.wzt@gmail.com>
Subject: Re: [PATCH] Netfilter: Fix some coding styles and remove
	moduleparam.h
Date: Thu, 8 Apr 2010 19:44:25 +0800
Message-ID: <t2t628d1651004080444o35d537cft6fb420ecce509844@mail.gmail.com>
References: <20100326034415.GB30224@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f199.google.com ([209.85.223.199]:35328 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0DHLo0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:44:26 -0400
In-Reply-To: <20100326034415.GB30224@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi, kaber, this patch is already based on nf-next git trees.

On Fri, Mar 26, 2010 at 11:44 AM,  <wzt.wzt@gmail.com> wrote:
> Fix some coding styles and remove moduleparam.h
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>
> ---
> =C2=A0net/ipv4/netfilter/nf_nat_standalone.c | =C2=A0 =C2=A03 +--
> =C2=A0net/ipv4/netfilter/nf_nat_tftp.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =
=C2=A01 -
> =C2=A0net/netfilter/nf_conntrack_proto.c =C2=A0 =C2=A0 | =C2=A0 =C2=A0=
2 --
> =C2=A03 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfil=
ter/nf_nat_standalone.c
> index 5678e95..0b49248 100644
> --- a/net/ipv4/netfilter/nf_nat_standalone.c
> +++ b/net/ipv4/netfilter/nf_nat_standalone.c
> @@ -137,9 +137,8 @@ nf_nat_fn(unsigned int hooknum,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D nf_nat_rule_find(skb,=
 hooknum, in, out,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ct);
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ret !=3D NF_ACCEPT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ret !=3D NF_ACCEPT)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0pr_debug("Already setup manip %s for ct %p\n",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 maniptype =3D=3D IP_NAT_MANI=
P_SRC ? "SRC" : "DST",
> diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf=
_nat_tftp.c
> index b096e81..7274a43 100644
> --- a/net/ipv4/netfilter/nf_nat_tftp.c
> +++ b/net/ipv4/netfilter/nf_nat_tftp.c
> @@ -6,7 +6,6 @@
> =C2=A0*/
>
> =C2=A0#include <linux/module.h>
> -#include <linux/moduleparam.h>
> =C2=A0#include <linux/udp.h>
>
> =C2=A0#include <net/netfilter/nf_nat_helper.h>
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_co=
nntrack_proto.c
> index 1a4568b..f71cd5d 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -13,12 +13,10 @@
> =C2=A0#include <linux/netfilter.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/mutex.h>
> -#include <linux/skbuff.h>
> =C2=A0#include <linux/vmalloc.h>
> =C2=A0#include <linux/stddef.h>
> =C2=A0#include <linux/err.h>
> =C2=A0#include <linux/percpu.h>
> -#include <linux/moduleparam.h>
> =C2=A0#include <linux/notifier.h>
> =C2=A0#include <linux/kernel.h>
> =C2=A0#include <linux/netdevice.h>
> --
> 1.6.5.3
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
