From: Jorge Garcia <anarkophobia@latinmail.com>
Subject: RE:Re: fisrt post on the list whit a few questions
Date: Mon, 15 Mar 2004 09:55:05 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040315145505.274B93CB70@smtp.latinmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="latinmail.com_linux02100.dn.net_5e0de1b2ae81e22c79b32e4e6c7e109e"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--latinmail.com_linux02100.dn.net_5e0de1b2ae81e22c79b32e4e6c7e109e
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi, here is one of the codes from prhrack article:
/* Sample code to install a Netfilter hook function that will
 * drop all incoming packets on an interface we specify */
 #define __KERNEL__
 #define MODULE
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 /* This is the structure we shall use to register our function */
  static struct nf_hook_ops nfho;

 /* Name of the interface we want to drop packets from */
  static char *drop_if =3D "lo";

 /* This is the hook function itself */
  unsigned int hook_func(unsigned int hooknum,
                         struct sk_buff **skb,
                         const struct net_device *in,
                         const struct net_device *out,
                         int (*okfn)(struct sk_buff *))
{
    if (strcmp(in->name, drop_if) =3D=3D 0) {
        printk("Dropped packet on %s...\n", drop_if);
        return NF_DROP;
    } else {
        return NF_ACCEPT;
    }
}

/* Initialisation routine */
int init_module()
{
    /* Fill in our hook structure */
    nfho.hook     =3D hook_func;         /* Handler function */
    nfho.hooknum  =3D NF_IP_PRE_ROUTING; /* First hook for IPv4 */
    nfho.pf       =3D PF_INET;
    nfho.priority =3D NF_IP_PRI_FIRST;   /* Make our function first */
 =20
    nf_register_hook(&nfho);
   =20
    return 0;
}
=09
/* Cleanup routine */
void cleanup_module()
{
    nf_unregister_hook(&nfho);
}

OK, this filter incoming anbd outcomming connections, how do i filter f=
or example only incoming traffic??
I have more questions abouts some codes in this article but for now i w=
ant to know how to do this.
Thanx for everithing and here is the link to the phrack article that is=
 very intresting:
http://www.phrack.org/show.php?p=3D61&a=3D13




Hi Jorge,

Jorge Garcia wrote:

>Hi, Im from Montevideo Uruguay, so u have to excuse my english.
>Im using netfilter iptables for about 4 months and i really like the p=
roduct, now im reading about the netfilter programming modules that i f=
ind in a phrack article.
> =20
>
I recommend you reading the netfilter hacking-how. Those articles that=20=

you read are ok, but maybe they consider some things obvious.

>The modules dont do ehat is expected to do, like in list2.c the progra=
m filter input and output interfaces.
> =20
>
could you could post to the list the relevance section of the source=20=

code? I don't know where's that file.

>If i want to filter only incoming packets, how do i do that??
> =20
>
>My second question its about security, the security advisories on the =
page are old ones and doesnt work for new kernels.
>I want to know if is there any vulneability more new for testing becou=
se im writing a paper about netfilter security in spanish.
> =20
>
as far as I know, those are all the security asvisories. If there's=20
more, they would be published.

regards,
Pablo



http://www.latinmail.com - La forma m=E1s c=F3moda de enviar y recibir =
tus e-mails
--latinmail.com_linux02100.dn.net_5e0de1b2ae81e22c79b32e4e6c7e109e--
