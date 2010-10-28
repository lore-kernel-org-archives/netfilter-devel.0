From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: netfilter: nf_nat: make find/put static
Date: Thu, 28 Oct 2010 20:42:21 +0200
Message-ID: <AANLkTikuvBb79Q-mKK-u3tL=f433Om4T3NqJUynv=8=w@mail.gmail.com>
References: <201010231923.o9NJN2oc012438@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>,
	Patrick McHardy <kaber@trash.net>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50752 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab0J1SmX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:42:23 -0400
In-Reply-To: <201010231923.o9NJN2oc012438@hera.kernel.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 23, 2010 at 21:23, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb: =C2=A0 =C2=A0 http://git.kernel.org/linus/0c200d935346fe0ebde=
9b6dffbb683dddd166fb9
> Commit: =C2=A0 =C2=A0 0c200d935346fe0ebde9b6dffbb683dddd166fb9
> Parent: =C2=A0 =C2=A0 758ff03387228824617cef9507e5682488bf9e0c
> Author: =C2=A0 =C2=A0 Stephen Hemminger <shemminger@vyatta.com>
> AuthorDate: Mon Oct 4 20:53:18 2010 +0200
> Committer: =C2=A0Patrick McHardy <kaber@trash.net>
> CommitDate: Mon Oct 4 20:53:18 2010 +0200
>
> =C2=A0 =C2=A0netfilter: nf_nat: make find/put static
>
> =C2=A0 =C2=A0The functions nf_nat_proto_find_get and nf_nat_proto_put=
 are
> =C2=A0 =C2=A0only used internally in nf_nat_core. This might break so=
me out
> =C2=A0 =C2=A0of tree NAT module.
>
> =C2=A0 =C2=A0Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> =C2=A0 =C2=A0Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
> =C2=A0include/net/netfilter/nf_nat_protocol.h | =C2=A0 =C2=A03 ---
> =C2=A0net/ipv4/netfilter/nf_nat_core.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 =C2=A06 ++----
> =C2=A02 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/ne=
tfilter/nf_nat_protocol.h
> index df17bac..93cc90d 100644
> --- a/include/net/netfilter/nf_nat_protocol.h
> +++ b/include/net/netfilter/nf_nat_protocol.h
> @@ -45,9 +45,6 @@ struct nf_nat_protocol {
> =C2=A0extern int nf_nat_protocol_register(const struct nf_nat_protoco=
l *proto);
> =C2=A0extern void nf_nat_protocol_unregister(const struct nf_nat_prot=
ocol *proto);
>
> -extern const struct nf_nat_protocol *nf_nat_proto_find_get(u_int8_t =
protocol);
> -extern void nf_nat_proto_put(const struct nf_nat_protocol *proto);
> -
> =C2=A0/* Built-in protocols. */
> =C2=A0extern const struct nf_nat_protocol nf_nat_protocol_tcp;
> =C2=A0extern const struct nf_nat_protocol nf_nat_protocol_udp;
> diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf=
_nat_core.c
> index 2c084b3..e2e00c4 100644
> --- a/net/ipv4/netfilter/nf_nat_core.c
> +++ b/net/ipv4/netfilter/nf_nat_core.c
> @@ -47,7 +47,7 @@ __nf_nat_proto_find(u_int8_t protonum)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return rcu_dereference(nf_nat_protos[proto=
num]);
> =C2=A0}
>
> -const struct nf_nat_protocol *
> +static const struct nf_nat_protocol *
> =C2=A0nf_nat_proto_find_get(u_int8_t protonum)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct nf_nat_protocol *p;
> @@ -60,14 +60,12 @@ nf_nat_proto_find_get(u_int8_t protonum)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return p;
> =C2=A0}
> -EXPORT_SYMBOL_GPL(nf_nat_proto_find_get);
>
> -void
> +static void
> =C2=A0nf_nat_proto_put(const struct nf_nat_protocol *p)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0module_put(p->me);
> =C2=A0}
> -EXPORT_SYMBOL_GPL(nf_nat_proto_put);
>
> =C2=A0/* We keep an extra hash for each conntrack, for fast searching=
=2E */
> =C2=A0static inline unsigned int

They should be moved inside the
"#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODU=
LE)",
as I now get:

net/ipv4/netfilter/nf_nat_core.c:52: warning: =E2=80=98nf_nat_proto_fin=
d_get=E2=80=99
defined but not used
net/ipv4/netfilter/nf_nat_core.c:66: warning: =E2=80=98nf_nat_proto_put=
=E2=80=99
defined but not used

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
