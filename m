From: manuprivat@gmx.de
Subject: Re: Add new target in mangle table
Date: Mon, 14 Apr 2008 10:19:23 +0200
Message-ID: <20080414081923.293260@gmx.net>
References: <1207899903.8402.31.camel@mscheub-lapi.Simpsons>
 <alpine.LNX.1.10.0804111029500.21182@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41828 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755222AbYDNIT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:19:27 -0400
In-Reply-To: <alpine.LNX.1.10.0804111029500.21182@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Excuse me, but I didn=E2=80=99t get the solution for the RAWNAT issue.
Maybe it refers to that I'm not so familiar with the netfilter stuff.

Is it possible to realize my issue, or do I have problems with the conn=
track?

Where can I find the source code for the RAWNAT target.

Regards,
Manu

-------- Original-Nachricht --------
> Datum: Fri, 11 Apr 2008 10:32:05 +0200 (CEST)
> Von: Jan Engelhardt <jengelh@computergmbh.de>
> An: Manu <manuprivat@gmx.de>
> CC: netfilter-devel@vger.kernel.org
> Betreff: Re: Add new target in mangle table

>=20
> On Friday 2008-04-11 09:45, Manu wrote:
>=20
> >Hi developers,
> >
> >I encountered difficulties during integrating a new target in mangle
> >table (iptables-1.4.0 (from www.netfilter.org), kernel-2.6.23 (from
> >www.kernel.org)).=20
> >I have a master from iptables-1.2.9 and kernel-2.6.3. But there were=
 too
> >many differences and changes be made.
> >The idea behind to add the target is, that a user who has a fix-ip e=
ntry
> >in his network settings can be handled from a gateway, for which the=
 new
> >targets should be implemented. for example:
> >
> ># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
> >--to-source 10.0.19.2
>=20
>=20
> This looks pretty much like RAWNAT, as posted in=20
> http://marc.info/?l=3Dnetfilter-devel&m=3D120024054521550&w=3D2 .


Hi developers,

I encountered difficulties during integrating a new target in mangle ta=
ble
(iptables-1.4.0 (from www.netfilter.org), kernel-2.6.23 (from
www.kernel.org)).=20
I have a master from iptables-1.2.9 and kernel-2.6.3. But there were to=
o
many differences and changes be made.
The idea behind to add the target is, that a user who has a fix-ip entr=
y in
his network settings can be handled from a gateway, for which the new
targets should be implemented. for example:

# iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
--to-source 10.0.19.2
iptables: Target problem

-> dmesg shows:
=2E..
SADDR: targinfosize 3290890384 !=3D 4
=2E..

There should be a user request management in the gateway, that nobody s=
hould
care about the network-settings. It should doesn't matter if a user has=
 dhcp
activated or a fix IP entry.
It works with the iptables-1.2.9 and kernel-2.6.3:
Code posted:

kernel-sources 2.6.3:
ipt_SADDR.h
ipt_SADDR.c
iptables-sources 1.2.9:
libipt_SADDR.c

kernel-sources 2.6.23:
ipt_SADDR.h
ipt_SADDR.c
iptables-sources 1.4.0:
libipt_SADDR.c

nearly the same for DADDR-target! I have attached all the important fil=
es -
I think!?

Any help would be greatly appreciated!
Thanks in advance.

Regards
Manu


kernel-sources 2.6.3:
ipt_SADDR.h:
------------------------------
#ifndef _IPT_SADDR_H_target
#define _IPT_SADDR_H_target

struct ipt_saddr_target_info {
        u_int32_t saddr;
};

#endif /*_IPT_SADDR_H_target*/

------------------------------

ipt_SADDR.c:
------------------------------
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <net/tcp.h>
#include <net/checksum.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Uli Konrad");
MODULE_DESCRIPTION("iptables IP Source Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const void *targinfo,
       void *userinfo)
{
        const struct ipt_saddr_target_info *saddrinfo =3D targinfo;

        if ((*pskb)->nh.iph->saddr !=3D saddrinfo->saddr) {
                u_int32_t diffs[2];

                if (!skb_ip_make_writable(pskb, sizeof(struct iphdr)))
                        return NF_DROP;

                diffs[0] =3D ~((*pskb)->nh.iph->saddr);
                (*pskb)->nh.iph->saddr =3D saddrinfo->saddr;
                diffs[1] =3D saddrinfo->saddr;

                (*pskb)->nh.iph->check
                        =3D csum_fold(csum_partial((char *)diffs,
                                                 sizeof(diffs),
                                                 (*pskb)->nh.iph->check
                                                 ^0xFFFF));

        if ((*pskb)->nh.iph->protocol =3D=3D 0x06) {
                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

                iph =3D (*pskb)->nh.iph;
                tcph =3D (void *)iph + iph->ihl*4;

                datalen =3D (*pskb)->len - iph->ihl*4;
                tcph->check =3D 0;
                tcph->check =3D tcp_v4_check(tcph, datalen, iph->saddr,
iph->daddr,
                                   csum_partial((char *)tcph, datalen, =
0));
        }
        if ((*pskb)->nh.iph->protocol =3D=3D 0x11) {
                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

                iph =3D (*pskb)->nh.iph;
                udph =3D (void *)iph + iph->ihl*4;

                datalen =3D (*pskb)->len - iph->ihl * 4;
                udph->check =3D 0;
                udph->check =3D csum_tcpudp_magic(iph->saddr, iph->dadd=
r,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char *)ud=
ph,
                                                             datalen, 0=
));
        }


                (*pskb)->nfcache |=3D NFC_ALTERED;
        }

        return IPT_CONTINUE;
}

static int
checkentry(const char *tablename,
           const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
        if (targinfosize !=3D IPT_ALIGN(sizeof(struct
ipt_saddr_target_info))) {
                printk(KERN_WARNING "SADDR: targinfosize %u !=3D %Zu\n"=
,
                       targinfosize,
                       IPT_ALIGN(sizeof(struct ipt_saddr_target_info)))=
;
                return 0;
        }

        if (strcmp(tablename, "mangle") !=3D 0) {
                printk(KERN_WARNING "SADDR: can only be called from
\"mangle\" table, not \"%s\"\n", tablename);
                return 0;
        }

        return 1;
}

static struct ipt_target ipt_saddr_reg =3D {
        .name           =3D "SADDR",
        .target         =3D target,
        .checkentry     =3D checkentry,
        .me             =3D THIS_MODULE,
};

static int __init init(void)
{
        return ipt_register_target(&ipt_saddr_reg);
}

static void __exit fini(void)
{
        ipt_unregister_target(&ipt_saddr_reg);
}

module_init(init);
module_exit(fini);

----------------------------

iptables-1.2.9:
libipt_SADDR.c:=20
----------------------------
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

struct saddrinfo {
        struct ipt_entry_target t;
        struct ipt_saddr_target_info saddr; };

/* Function which prints out usage message. */ static void
help(void)
{
        printf(
"SADDR target v%s options:\n"
"  --to-source ip-address       set source address\n",
IPTABLES_VERSION);
}

static struct option opts[] =3D {
        { "to-source", 1, 0, '1' },
        { 0 }
};

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache) { }

static void
parse_saddr(const unsigned char *s, struct ipt_saddr_target_info *info)=
 {
        struct in_addr *ip;

        ip =3D dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n", =
s);

        info->saddr =3D ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
        struct ipt_saddr_target_info *saddrinfo
                =3D (struct ipt_saddr_target_info *)(*target)->data;

        switch (c) {
        case '1':
                if (*flags)
                        exit_error(PARAMETER_PROBLEM,
                                   "SADDR target: Cant specify --to-sou=
rce
twice");
                parse_saddr(optarg, saddrinfo);
                *flags =3D 1;
                break;

        default:
                return 0;
        }

        return 1;
}

static void
final_check(unsigned int flags)
{
        if (!flags)
                exit_error(PARAMETER_PROBLEM,
                           "SADDR target: Parameter --to-source is
required"); }

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
        struct in_addr a;
        const struct ipt_saddr_target_info *saddrinfo =3D
                (const struct ipt_saddr_target_info *)target->data;
        a.s_addr =3D saddrinfo->saddr;
        printf("SADDR set %s ", addr_to_dotted(&a)); }

/* Saves the union ipt_targinfo in parsable form to stdout. */ static v=
oid
save(const struct ipt_ip *ip, const struct ipt_entry_target *target) {
        struct in_addr a;
        const struct ipt_saddr_target_info *saddrinfo =3D
                (const struct ipt_saddr_target_info *)target->data;

        a.s_addr =3D saddrinfo->saddr;
        printf("--to-source %s ", addr_to_dotted(&a)); }

static
struct iptables_target saddr
=3D { NULL,
    "SADDR",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
    IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
        register_target(&saddr);
}

--------------------------------



kernel-sources 2.6.23:
ipt_SADDR.h
--------------------------------
#ifndef _IPT_SADDR_H
#define _IPT_SADDR_H

struct ipt_saddr_target_info {
        u_int8_t saddr;
};

#endif /*_IPT_SADDR_H*/
-------------------------------

ipt_SADDR.c
-------------------------------
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/in.h>
#include <linux/netfilter.h>
#include <net/checksum.h>

#include <linux/netfilter/x_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>
#include <linux/netfilter_ipv4/ip_tables.h>

#define NFC_ALTERED 0x8000

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Manuel Scheub");
MODULE_DESCRIPTION("iptables IP Source Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const struct xt_target *target,
       const void *targinfo)
{
        const struct ipt_saddr_target_info *saddrinfo =3D targinfo;
        struct iphdr *iph =3D ip_hdr(*pskb);

        if (iph->saddr !=3D saddrinfo->saddr) {
                u_int32_t diffs[2];

                if (!skb_make_writable(pskb, sizeof(struct iphdr)))
                        return NF_DROP;

                diffs[0] =3D ~(iph->saddr);
                iph->saddr =3D saddrinfo->saddr;
                diffs[1] =3D saddrinfo->saddr;

                iph->check =3D csum_fold(csum_partial((char *)diffs,
                                                 sizeof(diffs),
                                                 iph->check
                                                 ^0xFFFF));

        if (iph->protocol =3D=3D 0x06) {
//                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

//                iph =3D (*pskb)->nh.iph;
                tcph =3D (void *)iph + iph->ihl*4;

                datalen =3D (*pskb)->len - iph->ihl * 4;
                tcph->check =3D 0;
                tcph->check =3D csum_tcpudp_magic(iph->saddr, iph->dadd=
r,
                                                datalen, IPPROTO_TCP,
                                                csum_partial((char *)tc=
ph,
                                                             datalen, 0=
));

        }

        if (iph->protocol =3D=3D 0x11) {
//                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

//                iph =3D (*pskb)->nh.iph;
                udph =3D (void *)iph + iph->ihl*4;

                datalen =3D (*pskb)->len - iph->ihl * 4;
                udph->check =3D 0;
                udph->check =3D csum_tcpudp_magic(iph->saddr, iph->dadd=
r,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char *)ud=
ph,
                                                             datalen, 0=
));
        }

//              (*pskb)->nfcache |=3D NFC_ALTERED;
        }

        return XT_CONTINUE;
}

bool
checkentry(const char *tablename,
           const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
        if (targinfosize !=3D IPT_ALIGN(sizeof(struct
ipt_saddr_target_info))) {
                printk(KERN_WARNING "SADDR: targinfosize %u !=3D %Zu\n"=
,
                       targinfosize,
                       IPT_ALIGN(sizeof(struct ipt_saddr_target_info)))=
;
                return 0;
        }

        if (strcmp(tablename, "mangle") !=3D 0) {
                printk(KERN_WARNING "SADDR: can only be called from
\"mangle\" table, not \"%s\"\n", tablename);
                return 0;
        }

        return 1;
}

static struct xt_target ipt_saddr_reg __read_mostly =3D {
        .name           =3D "SADDR",
        .family         =3D AF_INET,
        .target         =3D target,
        .targetsize     =3D sizeof(struct ipt_saddr_target_info),
        .table          =3D "mangle",
        .checkentry     =3D checkentry,
        .me             =3D THIS_MODULE,
};

static int __init ipt_saddr_init(void)
{
        return xt_register_target(&ipt_saddr_reg);
}

static void __exit ipt_saddr_fini(void)
{
        xt_unregister_target(&ipt_saddr_reg);
}

module_init(ipt_saddr_init);
module_exit(ipt_saddr_fini);
-----------------------------------

iptables-sources 1.4.0
libipt_SADDR.c:
----------------------------------#include <stdio.h> #include <string.h=
>
#include <stdlib.h> #include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

struct saddrinfo {
        struct xt_entry_target t;
        struct ipt_saddr_target_info saddr; };

/* Function which prints out usage message. */ static void SADDR_help(v=
oid)
{
        printf(
"SADDR target v%s options:\n"
"  --to-source ip-address       set source address\n",
IPTABLES_VERSION);
}

static const struct option SADDR_opts[] =3D {
        { "to-source", 1, NULL, '1' },
        { 0 }
};

static void
parse_saddr(const char *s, struct ipt_saddr_target_info *info) {
        struct in_addr *ip;

        ip =3D dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n", =
s);

        info->saddr =3D ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int SADDR_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
                     const void *entry, struct xt_entry_target **target=
) {
        struct ipt_saddr_target_info *saddrinfo
                =3D (struct ipt_saddr_target_info *)(*target)->data;

        switch (c) {
        case '1':
                if (*flags)
                        exit_error(PARAMETER_PROBLEM,
                                   "SADDR target: Cant specify --to-sou=
rce
twice");
                parse_saddr(optarg, saddrinfo);
                *flags =3D 1;
                break;

        default:
                return 0;
        }

        return 1;
}

static void SADDR_check(unsigned int flags) {
        if (!flags)
                exit_error(PARAMETER_PROBLEM,
                           "SADDR target: Parameter --to-source is
required"); }

static void
print_saddr(u_int8_t saddr, int numeric) {
        unsigned int i;

        if (!numeric) {
                for (i =3D 0; i<sizeof(SADDR_values)/sizeof(struct
SADDR_value); i++)
                        if (SADDR_values[i].SADDR =3D=3D saddr) {
                                printf("%s ", SADDR_values[i].name);
                                return;
                        }
        }
        printf("0x%02x ", saddr);
}

/* Prints out the targinfo. */
static void SADDR_print(const void *ip, const struct xt_entry_target
*target,
                      int numeric)
{
        const struct ipt_saddr_target_info *saddrinfo =3D
                (const struct ipt_saddr_target_info *)target->data;
        printf("SADDR set ");
        print_saddr(saddrinfo->saddr, numeric); }

/* Saves the union ipt_targinfo in parsable form to stdout. */ static v=
oid
SADDR_save(const void *ip, const struct xt_entry_target
*target)
{
        const struct ipt_saddr_target_info *saddrinfo =3D
                (const struct ipt_saddr_target_info *)target->data;

        printf("--to-source 0x%02x ", saddrinfo->saddr); }

static struct iptables_target saddr_target =3D {
        .name           =3D "SADDR",
        .version        =3D IPTABLES_VERSION,
        .size           =3D IPT_ALIGN(sizeof(struct
ipt_saddr_target_info)),
        .userspacesize  =3D IPT_ALIGN(sizeof(struct ipt_saddr_target_in=
fo)),
        .help           =3D SADDR_help,
        .parse          =3D SADDR_parse,
        .final_check    =3D SADDR_check,
        .print          =3D SADDR_print,
        .save           =3D SADDR_save,
        .extra_opts     =3D SADDR_opts,
};

void _init(void)
{
        register_target(&saddr_target);
}
----------------------------------------




--=20
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games=
!=20
http://games.entertainment.gmx.net/de/entertainment/games/free
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
