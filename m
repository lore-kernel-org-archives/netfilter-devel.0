From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] SANE conntrack helper
Date: Mon, 27 Nov 2006 19:58:23 +0100
Message-ID: <456B354F.5040101@trash.net>
References: <4569F47C.2080203@stud.feec.vutbr.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
In-Reply-To: <4569F47C.2080203@stud.feec.vutbr.cz>
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

Michal Schmidt wrote:
> Hi,
>=20
> Attached is nf_conntrack_sane, a netfilter connection tracking helper
> module for the SANE protocol used by the 'saned' daemon to make scanner=
s
> available via network.
> The SANE protocol uses separate control & data connections, similar to
> passive FTP. The helper module is needed to recognize the data
> connection as RELATED to the control one.

Looks quite sane :) We have a large number of nf_conntrack patches
queued up already, some of which change or enhance the API,
so please port your helper on top of the nf_nat tree (check out
the mailing list archives of the past two weeks for details
how to clone it).

A few more comments below ..


>=20
> Signed-off-by: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
>=20
>=20
> -----------------------------------------------------------------------=
-
>=20
> diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linu=
x/netfilter/nf_conntrack_sane.h
> new file mode 100644
> index 0000000..3119173
> --- /dev/null
> +++ b/include/linux/netfilter/nf_conntrack_sane.h
> @@ -0,0 +1,21 @@
> +#ifndef _NF_CONNTRACK_SANE_H
> +#define _NF_CONNTRACK_SANE_H
> +/* SANE tracking. */
> +
> +#ifdef __KERNEL__
> +
> +#define SANE_PORT	6566
> +
> +enum sane_state {
> +	SANE_STATE_NORMAL,
> +	SANE_STATE_START_REQUESTED,
> +};
> +
> +/* This structure exists only once per master */
> +struct ip_ct_sane_master {
> +	enum sane_state state;
> +};
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* _NF_CONNTRACK_SANE_H */
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilt=
er/nf_conntrack.h
> index 1fbd819..a4fbdcb 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -41,11 +41,13 @@ union nf_conntrack_expect_proto {
> =20
>  /* Add protocol helper include file here */
>  #include <linux/netfilter/nf_conntrack_ftp.h>
> +#include <linux/netfilter/nf_conntrack_sane.h>
> =20
>  /* per conntrack: application helper private data */
>  union nf_conntrack_help {
>  	/* insert conntrack helper private data (master) here */
>  	struct ip_ct_ftp_master ct_ftp_info;
> +	struct ip_ct_sane_master ct_sane_info;

These are renamed to nf_ ... in the current code.

> +config NF_CONNTRACK_SANE
> +	tristate "SANE support on new connection tracking (EXPERIMENTAL)"

The "new" connection tracking will soon be standard, please remove
this so we don't have to change all Kconfig entries again.
=C2=B4
> diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_connt=
rack_sane.c
> new file mode 100644
> index 0000000..129fffb
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_sane.c
> @@ -0,0 +1,286 @@
> +/* SANE connection tracking helper
> + * (SANE =3D Scanner Access Now Easy)
> + */
> +
> +/* (C) 2006 Michal Schmidt
> + * Based on the FTP conntrack helper (net/netfilter/nf_conntrack_ftp.c=
)
> + * (C) 1999-2001 Paul `Rusty' Russell
> + * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
> + * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
> + * (C) 2003 Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/*
> + * For documentation about the SANE network protocol see
> + * http://www.sane-project.org/html/doc015.html

Maybe merge in the comment at the top.

> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/netfilter.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/ctype.h>
> +#include <linux/inet.h>
> +#include <net/checksum.h>
> +#include <net/tcp.h>

The last 6 look unnecessary. And you should use linux/tcp.h for
struct tcphdr.

> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_helper.h>
> +#include <linux/netfilter/nf_conntrack_sane.h>
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Michal Schmidt <xschmi00@stud.feec.vutbr.cz>");
> +MODULE_DESCRIPTION("SANE connection tracking helper");
> +
> +static char *sane_buffer;
> +
> +static DEFINE_SPINLOCK(nf_sane_lock);
> +
> +#define MAX_PORTS 8
> +static u_int16_t ports[MAX_PORTS];
> +static unsigned int ports_c;
> +module_param_array(ports, ushort, &ports_c, 0400);
> +
> +#if 0
> +#define DEBUGP printk
> +#else
> +#define DEBUGP(format, args...)
> +#endif
> +
> +#define SANE_NET_START      7   /* RPC code */
> +#define SANE_STATUS_SUCCESS 0   /* RPC reply */
> +
> +static int help(struct sk_buff **pskb,
> +		unsigned int protoff,
> +		struct nf_conn *ct,
> +		enum ip_conntrack_info ctinfo)
> +{
> +	unsigned int dataoff, datalen;
> +	struct tcphdr _tcph, *th;
> +	char *sb_ptr;
> +	int ret;
> +	u32 seq;
> +	int dir =3D CTINFO2DIR(ctinfo);
> +	struct ip_ct_sane_master *ct_sane_info =3D &nfct_help(ct)->help.ct_sa=
ne_info;
> +	struct nf_conntrack_expect *exp;
> +
> +	u32 sane_command;
> +	u32 sane_status;
> +	u32 sane_port;
> +
> +	/* Until there's been traffic both ways, don't look in packets. */
> +	if (ctinfo !=3D IP_CT_ESTABLISHED
> +	    && ctinfo !=3D IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
> +		DEBUGP("sane: Conntrackinfo =3D %u\n", ctinfo);

This useless debugging statement gets copied to every new helper :)
Please remove it, I've already done so with all the new connection
tracking helper ports.

> +		return NF_ACCEPT;
> +	}
> +
> +	th =3D skb_header_pointer(*pskb, protoff, sizeof(_tcph), &_tcph);
> +	if (th =3D=3D NULL)
> +		return NF_ACCEPT;
> +
> +	dataoff =3D protoff + th->doff * 4;
> +	/* No data? */
> +	if (dataoff >=3D (*pskb)->len) {
> +		return NF_ACCEPT;
> +	}

No parens around single line expressions please.

> +	datalen =3D (*pskb)->len - dataoff;
> +
> +	spin_lock_bh(&nf_sane_lock);
> +	sb_ptr =3D skb_header_pointer(*pskb, dataoff, datalen, sane_buffer);
> +	BUG_ON(sb_ptr =3D=3D NULL);
> +
> +	seq =3D ntohl(th->seq) + datalen;
> +
> +	if (dir =3D=3D IP_CT_DIR_ORIGINAL) {
> +		if (datalen < 4) {
> +			if (net_ratelimit())
> +				printk(KERN_NOTICE "conntrack_sane: data "
> +				       "too short (%u bytes)\n", datalen);

Mhh .. the port might be used by a different application as dynamically
assigned port number, I think this should be removed.

> +			ret =3D NF_DROP;
> +			goto out;
> +		}
> +
> +		sane_command =3D ntohl(*(u32 *)sb_ptr);

There are quite a few of these below, maybe add a header definition.

> +
> +		if (sane_command !=3D SANE_NET_START) {
> +			/* Not an interesting command */
> +			ct_sane_info->state =3D SANE_STATE_NORMAL;
> +			ret =3D NF_ACCEPT;
> +			goto out;
> +		}
> +
> +		/* We're interested in the next reply */
> +		ct_sane_info->state =3D SANE_STATE_START_REQUESTED;
> +		ret =3D NF_ACCEPT;
> +		goto out;
> +	}
> +
> +	/* It's a reply ... */
> +
> +	if (ct_sane_info->state !=3D SANE_STATE_START_REQUESTED) {
> +		/* ... to an uninteresting command. */
> +		ret =3D NF_ACCEPT;
> +		goto out;
> +	}
> +
> +	/* It's a reply to SANE_NET_START */
> +	if (datalen < 8) {
> +		if (net_ratelimit())
> +			printk(KERN_NOTICE "conntrack_sane: reply "
> +			       "too short (%u bytes)\n", datalen);

Same here, please no ringbuffer spamming.

> +		ret =3D NF_DROP;

Dropping is quite unfriendly too. You should only do it if it is
necessary for accurate tracking, f.e. in the FTP newline case.

> +		goto out;
> +	}
> +
> +	/* OK, we're picking it up. Reset the state. */
> +	ct_sane_info->state =3D SANE_STATE_NORMAL;
> +
> +	sane_status =3D ntohl(*(u32 *)sb_ptr);
> +	if (sane_status !=3D SANE_STATUS_SUCCESS) {
> +		/* saned refused the command */
> +		DEBUGP("sane: unsuccessful SANE_STATUS =3D %u\n",
> +			sane_status);
> +		ret =3D NF_ACCEPT;
> +		goto out;
> +	}
> +
> +	sane_port =3D ntohl(*(u32 *)(sb_ptr+4));
> +	if (sane_port > 0xffff)	{

32 bit port numbers? :)

> +		if (net_ratelimit())
> +			printk(KERN_NOTICE "conntrack_sane: invalid port "
> +			                   "in reply: %u\n", sane_port);
> +		ret =3D NF_ACCEPT;
> +		goto out;
> +	}
> +	DEBUGP("sane: Expecting data connection to port %u.\n", sane_port);
> +
> +	exp =3D nf_conntrack_expect_alloc(ct);
> +	if (exp =3D=3D NULL) {
> +		ret =3D NF_DROP;
> +		goto out;
> +	}
> +
> +	exp->tuple.dst.u3 =3D ct->tuplehash[!dir].tuple.dst.u3;
> +	exp->tuple.src.u3 =3D ct->tuplehash[!dir].tuple.src.u3;
> +	exp->tuple.src.l3num =3D ct->tuplehash[dir].tuple.src.l3num;
> +	exp->tuple.src.u.tcp.port =3D 0;
> +	exp->tuple.dst.u.tcp.port =3D htons(sane_port);
> +	exp->tuple.dst.protonum =3D IPPROTO_TCP;
> +
> +	exp->mask =3D (struct nf_conntrack_tuple)
> +		    { .src =3D { .l3num =3D 0xFFFF,
> +			       .u =3D { .tcp =3D { 0 }},
> +			     },
> +		      .dst =3D { .protonum =3D 0xFF,
> +			       .u =3D { .tcp =3D { 0xFFFF }},
> +			     },
> +		    };
> +	if (ct->tuplehash[dir].tuple.src.l3num =3D=3D PF_INET) {
> +		exp->mask.src.u3.ip =3D 0xFFFFFFFF;
> +		exp->mask.dst.u3.ip =3D 0xFFFFFFFF;
> +	} else {
> +		memset(exp->mask.src.u3.ip6, 0xFF,
> +		       sizeof(exp->mask.src.u3.ip6));
> +		memset(exp->mask.dst.u3.ip6, 0xFF,
> +		       sizeof(exp->mask.src.u3.ip6));
> +	}

The nf_nat tree has a helper function to avoid doing this in
every helper (nf_conntrack_expect_init). It also has a bug
BTW, the upper 12 byte of the IPv4 mask are uninitialized.

> +
> +	exp->expectfn =3D NULL;
> +	exp->flags =3D 0;
> +
> +	/* Can't expect this?  Best to drop packet now. */
> +	if (nf_conntrack_expect_related(exp) !=3D 0)
> +		ret =3D NF_DROP;
> +	else
> +		ret =3D NF_ACCEPT;
> +
> +
> +	/* TODO: NAT */
> +
> +	nf_conntrack_expect_put(exp);
> +
> +out:
> +	spin_unlock_bh(&nf_sane_lock);
> +	return ret;
> +}
> +
> +static struct nf_conntrack_helper sane[MAX_PORTS][2];
> +static char sane_names[MAX_PORTS][2][sizeof("sane-65535")];
> +
> +/* don't make this __exit, since it's called from __init ! */
> +static void nf_conntrack_sane_fini(void)
> +{
> +	int i, j;
> +	for (i =3D 0; i < ports_c; i++) {
> +		for (j =3D 0; j < 2; j++) {
> +			if (sane[i][j].me =3D=3D NULL)
> +				continue;

This is a bug copied from the FTP helper, in case of a static build
.me can be NULL, which means we might use the freed sane_buffer
for the already registered helpers.

> +
> +			DEBUGP("nf_ct_sane: unregistering helper for pf: %d "
> +			       "port: %d\n",
> +				sane[i][j].tuple.src.l3num, ports[i]);
> +			nf_conntrack_helper_unregister(&sane[i][j]);
> +		}
> +	}
> +
> +	kfree(sane_buffer);
> +}
> +
> +static int __init nf_conntrack_sane_init(void)
> +{
> +	int i, j =3D -1, ret =3D 0;
> +	char *tmpname;
> +
> +	sane_buffer =3D kmalloc(65536, GFP_KERNEL);
> +	if (!sane_buffer)
> +		return -ENOMEM;
> +
> +	if (ports_c =3D=3D 0)
> +		ports[ports_c++] =3D SANE_PORT;
> +
> +	/* FIXME should be configurable whether IPv4 and IPv6 SANE connection=
s
> +		 are tracked or not - YK */
> +	for (i =3D 0; i < ports_c; i++) {
> +		sane[i][0].tuple.src.l3num =3D PF_INET;
> +		sane[i][1].tuple.src.l3num =3D PF_INET6;
> +		for (j =3D 0; j < 2; j++) {
> +			sane[i][j].tuple.src.u.tcp.port =3D htons(ports[i]);
> +			sane[i][j].tuple.dst.protonum =3D IPPROTO_TCP;
> +			sane[i][j].mask.src.u.tcp.port =3D 0xFFFF;
> +			sane[i][j].mask.dst.protonum =3D 0xFF;
> +			sane[i][j].max_expected =3D 1;
> +			sane[i][j].timeout =3D 5 * 60;	/* 5 Minutes */
> +			sane[i][j].me =3D THIS_MODULE;
> +			sane[i][j].help =3D help;
> +			tmpname =3D &sane_names[i][j][0];
> +			if (ports[i] =3D=3D SANE_PORT)
> +				sprintf(tmpname, "sane");
> +			else
> +				sprintf(tmpname, "sane-%d", ports[i]);
> +			sane[i][j].name =3D tmpname;
> +
> +			DEBUGP("nf_ct_sane: registering helper for pf: %d "
> +			       "port: %d\n",
> +				sane[i][j].tuple.src.l3num, ports[i]);
> +			ret =3D nf_conntrack_helper_register(&sane[i][j]);
> +			if (ret) {
> +				printk(KERN_ERR "nf_ct_sane: failed to "
> +				       "register helper for pf: %d port: %d\n",
> +					sane[i][j].tuple.src.l3num, ports[i]);
> +				nf_conntrack_sane_fini();
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +module_init(nf_conntrack_sane_init);
> +module_exit(nf_conntrack_sane_fini);
