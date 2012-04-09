From: Adel Kodmani <mpcadel@gmail.com>
Subject: I fail to correctly modify ICMP traffic in a kernel module
Date: Mon, 9 Apr 2012 12:42:22 +0300
Message-ID: <CA+=80Ci+m88m+833dUX4_1T8WspMbk4vJ2fUbnZMLo7KheL0cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab2DIJmW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Apr 2012 05:42:22 -0400
Received: by iagz16 with SMTP id z16so5661271iag.19
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Apr 2012 02:42:22 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So here's what I am trying to do(trivial, I know; I am doing this to
learn something for a project): I've built this module to catch all
outgoing traffic, check if it's ICMP echo message traffic. If it is,
it simply re-calculates the checksum of the ICMP packet and then let
it go on its way.

Every time I insmod this module, all PING traffic fails >.< Can you
please tell me what I am doing wrong here?


/*
        Coder: Adel *. *******
    Creation Date: April/7th/2012
    Last Modification Date: April/9th/2012
    Purpose: This module is merely a prototype on how to change the
IP/ICMP pakcet information and still let it go without problems
    Testing: This module is being tested on a machine running the
Linux kernel 2.6.32-33 on a 64bits Intel Processor
    Notes: N/A
 */


#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

#include <linux/inet.h>
#include <linux/ip.h>
#include <linux/icmp.h>
#include <linux/tcp.h>
#include <linux/in.h>

#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>

static struct nf_hook_ops nfho;
static void printICMPHeader(struct icmphdr *icmph);

/*
 * in_cksum --
 * Checksum routine for Internet Protocol
 * family headers (C Version)
 */
unsigned short in_cksum(unsigned short *addr, int len)
{
    register int sum =3D 0;
        u_short answer =3D 0;
        register u_short *w =3D addr;
        register int nleft =3D len;
        /*
        * Our algorithm is simple, using a 32 bit accumulator (sum), we=
 add
        * sequential 16 bit words to it, and at the end, fold back all =
the
        * carry bits from the top 16 bits into the lower 16 bits.
        */
        while (nleft > 1)
        {
          sum +=3D *w++;
          nleft -=3D 2;
        }
        /* mop up an odd byte, if necessary */
        if (nleft =3D=3D 1)
        {
          *(u_char *) (&answer) =3D *(u_char *) w;
          sum +=3D answer;
        }
        /* add back carry outs from top 16 bits to low 16 bits */
        sum =3D (sum >> 16) + (sum & 0xffff);     /* add hi 16 to low 1=
6 */
        sum +=3D (sum >> 16);             /* add carry */
        answer =3D ~sum;              /* truncate to 16 bits */
        return (answer);
}

static unsigned int icmp_check(unsigned int hooknum,
                   struct sk_buff *skb,
                   const struct net_device *in,
                   const struct net_device *out,
                   int (*okfn)(struct sk_buff *))
{
    struct iphdr *iph;
    struct icmphdr *icmph;
    struct tcphdr *tcph;

    if(skb =3D=3D NULL)
        return -1;
    iph =3D ip_hdr(skb);
    if(iph->protocol =3D=3D IPPROTO_ICMP){
        printk(KERN_DEBUG"ICMP traffic!\n");
        icmph =3D icmp_hdr(skb);
        if(icmph->type =3D=3D ICMP_ECHO){
            printICMPHeader(icmph);
            icmph->checksum =3D in_cksum((unsigned short *)icmph,
sizeof(struct icmphdr));
            printICMPHeader(icmph);
        }
    }/* If IPPROTO_ICMP */
    return NF_ACCEPT;
}


static void printICMPHeader(struct icmphdr *icmph)
{
    printk(KERN_DEBUG "ICMP print function begin \n");
    printk(KERN_DEBUG "ICMP type =3D %d\n", icmph->type);
    printk(KERN_DEBUG "ICMP code =3D %d\n", icmph->code);
    printk(KERN_DEBUG "ICMP checksum =3D %d\n", icmph->checksum);
    printk(KERN_DEBUG "ICMP id =3D %d\n", icmph->un.echo.id);
    printk(KERN_DEBUG "ICMP sequence =3D %d\n", icmph->un.echo.sequence=
);
    printk(KERN_DEBUG "ICMP print function exit \n");
}


static int __init startup(void)
{
        printk(KERN_INFO "Loading Test module...\n");
        printk(KERN_ALERT "Hello world\n");

        /* Fill in our hook structure */
        nfho.hook =3D icmp_check;         /* Handler function */
        nfho.hooknum  =3D NF_INET_POST_ROUTING; /* Just before it hits =
the wire */
        nfho.pf       =3D PF_INET;
        nfho.priority =3D NF_IP_PRI_FILTER;
        nf_register_hook(&nfho);
    //pinger();
    return 0;
}

static void __exit cleanup(void)
{
    nf_unregister_hook(&nfho);
    printk(KERN_ALERT "Goodbye Mr.\n");
}

module_init(startup);
module_exit(cleanup);


=A0To debug the code a little bit, I've made my own user-space ping
utility and I've filled all of its IP and ICMP headers using
RAW_SOCKETS

icmp->type         =3D ICMP_ECHO;
    icmp->code          =3D 0;
    icmp->un.echo.id        =3D 0;
    icmp->un.echo.sequence  =3D 0;
    icmp-> checksum     =3D in_cksum((unsigned short *)icmp,
sizeof(struct icmphdr));


This utility works perfectly fine as long as my Module is not loaded.
Weirdly enough, when I load my module and check the Kernel Debug file,
look at what I get:

Apr  9 10:42:10 DHS-1022CYB kernel: [ 2521.862356] ICMP traffic!
Apr  9 10:42:58 DHS-1022CYB kernel: [ 2569.572346] ICMP traffic!
Apr  9 10:43:22 DHS-1022CYB kernel: [ 2593.317201] ICMP traffic!
Apr  9 10:43:56 DHS-1022CYB kernel: [ 2627.331320] ICMP traffic!
Apr  9 10:44:05 DHS-1022CYB kernel: [ 2636.802236] ICMP traffic!
Apr  9 10:44:08 DHS-1022CYB kernel: [ 2639.876490] ICMP traffic!
Apr  9 10:45:27 DHS-1022CYB kernel: [ 2718.422229] ICMP traffic!

This basically means that I, for some odd reason, am not even able to
catch the ECHO traffic in my module! (When I cannot catch it, it
simply goes out and works perfectly fine) P.S I tried to change the
hook to LOCAL_OUT and got the same result

Note however that this is the result of the Linux utility ping, not my
hand-written PING(Which I still for some reason cannot intercept). And
the Linux ping is not working as long as my Module is loaded.

Apr  9 10:57:24 DHS-1022CYB kernel: [ 3435.916336] ICMP print function =
exit
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922656] ICMP traffic!
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922665] ICMP print function =
begin
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922670] ICMP type =3D 8
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922674] ICMP code =3D 0
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922677] ICMP checksum =3D 50=
252
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922681] ICMP id =3D 3673
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922685] ICMP sequence =3D 51=
2
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922688] ICMP print function =
exit
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922691] ICMP print function =
begin
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922695] ICMP type =3D 8
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922698] ICMP code =3D 0
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922702] ICMP checksum =3D 11=
090
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922705] ICMP id =3D 3673
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922709] ICMP sequence =3D 51=
2
Apr  9 10:57:25 DHS-1022CYB kernel: [ 3436.922712] ICMP print function =
exit

And no, my hand-written PING is not broken, I've tested its reply and
it's ECHO_REPLY, the checksum function in that program is exactly =A0th=
e
same as the one I have in the module
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
