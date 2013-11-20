From: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Subject: Re: [PATCH] add hash:ip,mark data type to ipset
Date: Wed, 20 Nov 2013 14:08:16 +0000
Message-ID: <CACUMwTndacLOrfwNaXgOuKaqnorJOsn3jWkZ74SgA97mfgAfRg@mail.gmail.com>
References: <1383146590-4626-1-git-send-email-vytas.dauksa@smoothwall.net>
	<alpine.DEB.2.10.1311112106200.8236@blackhole.kfki.hu>
	<CACUMwTmRbK=tMMNhGe3BmhS4Fm76njtDPE=ez8TvO0HHBJ-bww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:54603 "HELO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751133Ab3KTOIS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:08:18 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so3781798eek.41
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2013 06:08:16 -0800 (PST)
In-Reply-To: <CACUMwTmRbK=tMMNhGe3BmhS4Fm76njtDPE=ez8TvO0HHBJ-bww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for your feedback, revised patch will follow right after this,
you can find my comments bellow

On 11 November 2013 20:48, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> =
wrote:
>
> Hi,
>
> On Wed, 30 Oct 2013, Vytas Dauksa wrote:
>
> > Introduce packet mark support with new ip,mark hash set. This inclu=
des
> > userspace and kernelspace code, hash:ip,mark set tests and updates =
man
> > page.
>
> Please give an example which demonstrates the usefulness of the set t=
ype.

The intended use is similar to the ip:port type, but for protocols
which don't use
a predictable port number. Instead of port number it matches a firewall=
 mark
determined by a layer 7 filtering program like opendpi, which will be c=
alled
by an earlier iptables rule.

As well as allowing or blocking traffic it will also be used for accoun=
ting
packets and bytes sent for each protocol.

>
> > diff --git a/include/libipset/data.h b/include/libipset/data.h
> > index b6e75e8..c3a8ac4 100644
> > --- a/include/libipset/data.h
> > +++ b/include/libipset/data.h
> > @@ -22,6 +22,7 @@ enum ipset_opt {
> >       IPSET_OPT_IP_FROM =3D IPSET_OPT_IP,
> >       IPSET_OPT_IP_TO,
> >       IPSET_OPT_CIDR,
> > +     IPSET_OPT_MARK,
> >       IPSET_OPT_PORT,
> >       IPSET_OPT_PORT_FROM =3D IPSET_OPT_PORT,
> >       IPSET_OPT_PORT_TO,
> > @@ -80,6 +81,7 @@ enum ipset_opt {
> >       | IPSET_FLAG(IPSET_OPT_IP)      \
> >       | IPSET_FLAG(IPSET_OPT_IP_TO)   \
> >       | IPSET_FLAG(IPSET_OPT_CIDR)    \
> > +     | IPSET_FLAG(IPSET_OPT_MARK)    \
> >       | IPSET_FLAG(IPSET_OPT_PORT)    \
> >       | IPSET_FLAG(IPSET_OPT_PORT_TO) \
> >       | IPSET_FLAG(IPSET_OPT_TIMEOUT) \
>
> The MARK option is not valid as a create flag: there's no such data t=
o
> pass to the kernel when creating the set type.
>

Removed.

I wasn't sure if it's best to set mark on individual entry within a
set or for whole set with or without mask.
What are your views on it? For now it's set on individual entries witho=
ut mask.

>
> > diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel=
/include/linux/netfilter/ipset/ip_set.h
> > index 7cde1cf..f5cb44f 100644
> > --- a/kernel/include/linux/netfilter/ipset/ip_set.h
> > +++ b/kernel/include/linux/netfilter/ipset/ip_set.h
> > @@ -40,11 +40,13 @@ enum ip_set_feature {
> >       IPSET_TYPE_NAME =3D (1 << IPSET_TYPE_NAME_FLAG),
> >       IPSET_TYPE_IFACE_FLAG =3D 5,
> >       IPSET_TYPE_IFACE =3D (1 << IPSET_TYPE_IFACE_FLAG),
> > -     IPSET_TYPE_NOMATCH_FLAG =3D 6,
> > +     IPSET_TYPE_MARK_FLAG =3D 6,
> > +     IPSET_TYPE_MARK =3D (1 << IPSET_TYPE_MARK_FLAG),
> > +     IPSET_TYPE_NOMATCH_FLAG =3D 7,
> >       IPSET_TYPE_NOMATCH =3D (1 << IPSET_TYPE_NOMATCH_FLAG),
> >       /* Strictly speaking not a feature, but a flag for dumping:
> >        * this settype must be dumped last */
> > -     IPSET_DUMP_LAST_FLAG =3D 7,
> > +     IPSET_DUMP_LAST_FLAG =3D 8,
> >       IPSET_DUMP_LAST =3D (1 << IPSET_DUMP_LAST_FLAG),
> >  };
>
> The features member of struct ip_set_type is u8, so you must change i=
t to
> at least u16. At the same time reorder the members so that features c=
omes
> after revision_max.

Done

>
> > diff --git a/kernel/net/netfilter/ipset/Kbuild b/kernel/net/netfilt=
er/ipset/Kbuild
> > index 5564cb5..9e52ef8 100644
> > --- a/kernel/net/netfilter/ipset/Kbuild
> > +++ b/kernel/net/netfilter/ipset/Kbuild
> > @@ -1,10 +1,11 @@
> >  NOSTDINC_FLAGS +=3D -I$(KDIR)/include
> > -EXTRA_CFLAGS :=3D -DIP_SET_MAX=3D$(IP_SET_MAX)
> > +EXTRA_CFLAGS :=3D -DCONFIG_IP_SET_MAX=3D$(IP_SET_MAX)
>
> Why do you want to change this back? Config settings are handled in
> kernel/include/linux/netfilter/ipset/ip_set_compat.h.in.
>

=46ixed, that was mistake.

>
> > + *
> > + * This program is free software; you can redistribute it and/or m=
odify
> > + * it under the terms of the GNU General Public License version 2 =
as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +/* Kernel module implementing an IP set type: the hash:ip,mark typ=
e */
> > +
> > +#include <linux/jhash.h>
> > +#include <linux/module.h>
> > +#include <linux/ip.h>
> > +#include <linux/skbuff.h>
> > +#include <linux/errno.h>
> > +#include <linux/random.h>
> > +#include <net/ip.h>
> > +#include <net/ipv6.h>
> > +#include <net/netlink.h>
> > +#include <net/tcp.h>
> > +
> > +#include <linux/netfilter.h>
> > +#include <linux/netfilter/ipset/pfxlen.h>
> > +#include <linux/netfilter/ipset/ip_set.h>
> > +#include <linux/netfilter/ipset/ip_set_hash.h>
> > +
> > +#define IPSET_TYPE_REV_MIN   0
> > +#define IPSET_TYPE_REV_MAX   0
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Vytas Dauksa <vytas.dauksa@smoothwall.net>");
> > +IP_SET_MODULE_DESC("hash:ip,mark", IPSET_TYPE_REV_MIN, IPSET_TYPE_=
REV_MAX);
> > +MODULE_ALIAS("ip_set_hash:ip,mark");
> > +
> > +/* Type specific function prefix */
> > +#define HTYPE                hash_ipmark
> > +
> > +/* IPv4 variant */
> > +
> > +/* Member elements */
> > +struct hash_ipmark4_elem {
> > +     __be32 ip;
> > +     __be32 mark;
>
> Mark is in host order, so __u32 is more appropriate.
>

Agree. Fixed.

>
> > +static int
> > +hash_ipmark4_kadt(struct ip_set *set, const struct sk_buff *skb,
> > +               const struct xt_action_param *par,
> > +               enum ipset_adt adt, struct ip_set_adt_opt *opt)
> > +{
> > +     ipset_adtfn adtfn =3D set->variant->adt[adt];
> > +     struct hash_ipmark4_elem e =3D { };
> > +     struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
> > +
> > +     e.mark =3D ntohl(skb->mark);
>
> If mark in struct hash_ipmark4_elem is __u32, no conversion is needed=
 at
> all.
>

=46ixed

>
> > +
> > +     ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
> > +     return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
> > +}
> > +
> > +static int
> > +hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
> > +               enum ipset_adt adt, u32 *lineno, u32 flags, bool re=
tried)
> > +{
> > +     const struct hash_ipmark *h =3D set->data;
> > +     ipset_adtfn adtfn =3D set->variant->adt[adt];
> > +     struct hash_ipmark4_elem e =3D { };
> > +     struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
> > +     u32 ip, ip_to =3D 0;
> > +     int ret;
> > +
> > +     if (unlikely(!tb[IPSET_ATTR_IP] ||
> > +                  !tb[IPSET_ATTR_MARK] ||
>
> Wrap tb[IPSET_ATTR_MARK] in ip_set_attr_netorder() call above.
>

=46ixed

>
> > +                  !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT)=
 ||
> > +                  !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS)=
 ||
> > +                  !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
> > +             return -IPSET_ERR_PROTOCOL;
> > +
> > +     if (tb[IPSET_ATTR_LINENO])
> > +             *lineno =3D nla_get_u32(tb[IPSET_ATTR_LINENO]);
> > +
> > +     ret =3D ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip) ||
> > +           ip_set_get_extensions(set, tb, &ext);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (tb[IPSET_ATTR_MARK])
> > +             e.mark =3D nla_get_be32(tb[IPSET_ATTR_MARK]);
> > +     else
> > +             return -IPSET_ERR_PROTOCOL;
>
> tb[IPSET_ATTR_MARK] is checked above, so there's no need for the cond=
ition
> here.
>

=46ixed

>
> > +     if (adt =3D=3D IPSET_TEST ||
> > +         !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR] ||
> > +           tb[IPSET_ATTR_MARK])) {
> > +             ret =3D adtfn(set, &e, &ext, &ext, flags);
> > +             return ip_set_eexist(ret, flags) ? 0 : ret;
> > +     }
> > +
> > +     ip_to =3D ip =3D ntohl(e.ip);
> > +     if (tb[IPSET_ATTR_IP_TO]) {
> > +             ret =3D ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], =
&ip_to);
> > +             if (ret)
> > +                     return ret;
> > +             if (ip > ip_to)
> > +                     swap(ip, ip_to);
> > +     } else if (tb[IPSET_ATTR_CIDR]) {
> > +             u8 cidr =3D nla_get_u8(tb[IPSET_ATTR_CIDR]);
> > +
> > +             if (!cidr || cidr > 32)
> > +                     return -IPSET_ERR_INVALID_CIDR;
> > +             ip_set_mask_from_to(ip, ip_to, cidr);
> > +     }
> > +
> > +     if (retried)
> > +             ip =3D ntohl(h->next.ip);
> > +     for (; !before(ip_to, ip); ip++) {
> > +             e.ip =3D htonl(ip);
> > +             ret =3D adtfn(set, &e, &ext, &ext, flags);
> > +
> > +             if (ret && !ip_set_eexist(ret, flags))
> > +                     return ret;
> > +             else
> > +                     ret =3D 0;
> > +     }
> > +     return ret;
> > +}
> > +
> > +/* IPv6 variant */
> > +
> > +struct hash_ipmark6_elem {
> > +     union nf_inet_addr ip;
> > +     __be32 mark;
>
> The same comments go here and below as for the IPv4 variant above.
>

=46ixed

>
> > diff --git a/lib/debug.c b/lib/debug.c
> > index a204940..56196ab 100644
> > --- a/lib/debug.c
> > +++ b/lib/debug.c
> > @@ -29,6 +29,7 @@ static const struct ipset_attrname createattr2nam=
e[] =3D {
> >       [IPSET_ATTR_IP]         =3D { .name =3D "IP" },
> >       [IPSET_ATTR_IP_TO]      =3D { .name =3D "IP_TO" },
> >       [IPSET_ATTR_CIDR]       =3D { .name =3D "CIDR" },
> > +     [IPSET_ATTR_MARK]       =3D { .name =3D "MARK" },
>
> This is unnecessary here too: no MARK option at create.

=46ixed

>
> > diff --git a/lib/libipset.map b/lib/libipset.map
> > index 1080f0d..fc7ac95 100644
> > --- a/lib/libipset.map
> > +++ b/lib/libipset.map
> > @@ -28,6 +28,7 @@ global:
> >    name_to_icmpv6;
> >    ipset_get_nlmsg_type;
> >    ipset_parse_ether;
> > +  ipset_parse_mark;
> >    ipset_parse_port;
> >    ipset_parse_tcpudp_port;
> >    ipset_parse_tcp_port;
> > @@ -69,6 +70,7 @@ global:
> >    ipset_print_ipaddr;
> >    ipset_print_number;
> >    ipset_print_name;
> > +  ipset_print_mark;
> >    ipset_print_port;
> >    ipset_print_iface;
> >    ipset_print_proto;
>
> You have to add a new library revision, which is just an extension of=
 the
> previous one with the new functions.
>

=46ixed

>
> Also, the API version must be adjusted in Make_global.am.

Done

>
> > diff --git a/lib/session.c b/lib/session.c
> > index 6f89281..673b440 100644
> > --- a/lib/session.c
> > +++ b/lib/session.c
> > @@ -349,6 +349,10 @@ static const struct ipset_attr_policy create_a=
ttrs[] =3D {
> >               .type =3D MNL_TYPE_U8,
> >               .opt =3D IPSET_OPT_CIDR,
> >       },
> > +     [IPSET_ATTR_MARK] =3D {
> > +             .type =3D MNL_TYPE_U32,
> > +             .opt =3D IPSET_OPT_MARK,
> > +     },
>
> No needed again.
>

=46ixed

>
> >       [IPSET_ATTR_PORT] =3D {
> >               .type =3D MNL_TYPE_U16,
> >               .opt =3D IPSET_OPT_PORT,
> > @@ -424,6 +428,10 @@ static const struct ipset_attr_policy adt_attr=
s[] =3D {
> >               .type =3D MNL_TYPE_U8,
> >               .opt =3D IPSET_OPT_CIDR,
> >       },
> > +     [IPSET_ATTR_MARK] =3D {
> > +             .type =3D MNL_TYPE_U32,
> > +             .opt =3D IPSET_OPT_MARK,
> > +     },
> >       [IPSET_ATTR_PORT] =3D {
> >               .type =3D MNL_TYPE_U16,
> >               .opt =3D IPSET_OPT_PORT,
> > diff --git a/src/ipset.8 b/src/ipset.8
> [...]
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sc=
iences
>           H-1525 Budapest 114, POB. 49, Hungary


--=20
Vytas Dauksa
Junior Developer
vytas.dauksa@smoothwall.net

Smoothwall Ltd
Phone: +44 (0=AD) 8701 999500
www.smoothwall.net
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
