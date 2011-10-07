From: ratheesh kannoth <ratheesh.ksz@gmail.com>
Subject: track the icmp packet.
Date: Fri, 7 Oct 2011 12:43:31 +0530
Message-ID: <CAGZFCEET5wkfC_W+8mHYt6W5YnyhWsM8OcXU60NsP4x9AGW49g@mail.gmail.com>
References: <CAGZFCEH59K7gFs5uNVdY_XQrAea+DT5Mes4OzOaxCOdnCtTWKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38149 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1JGHNd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:13:33 -0400
Received: by iakk32 with SMTP id k32so3890925iak.19
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Oct 2011 00:13:32 -0700 (PDT)
In-Reply-To: <CAGZFCEH59K7gFs5uNVdY_XQrAea+DT5Mes4OzOaxCOdnCtTWKw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have a =A0linux machine (2.6.32 kernel )
ip address is 192.168.0.102 and default gw is 192.168.0.1


I want to do some "printk " when an echo request is sent from the
machine to the gateway
ie ...
# ping =A0192.168.0.1 =A0 =A0 =A0 // command should do some printk.

I found a program at
http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO.tx=
t.
I modified a little for my purpose. But it is not working. Could you
please guide me.



@@@@@@@ =A0conn-track-01.c @@@@@@@@@@@@
// copied from http://www.netfilter.org/documentation/HOWTO/netfilter-h=
acking-HOWTO.txt
// and modified

#define FOO_PORT =A0 =A0 =A0 =A0111
#include <linux/module.h>
#include <linux/kernel.h>
#include <net/netfilter/nf_conntrack.h>
#include <net/netfilter/nf_conntrack_helper.h>
#include <linux/ip.h>
#include <net/netfilter/nf_conntrack_expect.h>


static char * dst_ipaddress =3D "192.168.0.1" ; // my gateway ip addres=
s
is 192.168.0.1
module_param(dst_ipaddress, charp, 0000);

static const struct nf_conntrack_expect_policy my_expect_policy =3D {
=A0 =A0 =A0 =A0.max_expected =A0 =A0 =A0 =A0 =A0 =3D 3,
=A0 =A0 =A0 =A0.timeout =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 180,
};


static int foo_expectfn(struct nf_conntrack *new)
{

=A0 =A0 =A0 =A0return 0;
}

static int foo_help(struct sk_buff *skb,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int protoff,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nf_conn *ct,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum ip_conntrack_info conntrack=
info)
{
=A0 =A0 =A0 =A0printk (KERN_INFO "RAT: called the =A0helper \n");
=A0 =A0 =A0 =A0return NF_ACCEPT;
}

static struct nf_conntrack_helper foo;

int init_conntrack_module(void)
{
=A0 =A0 =A0 =A0memset(&foo, 0, sizeof(struct nf_conntrack_helper));

=A0 =A0 =A0 =A0foo.name =3D "foo";
=A0 =A0 =A0 =A0foo.me =3D THIS_MODULE;

=A0 =A0 =A0 =A0foo.tuple.dst.protonum =3D IPPROTO_ICMP;
=A0 =A0 =A0 =A0foo.tuple.dst.u.icmp.type =3D 8;
=A0 =A0 =A0 =A0foo.tuple.dst.u.icmp.code =A0=3D 0;
=A0 =A0 =A0 =A0foo.tuple.src.l3num =3D AF_INET;
=A0 =A0 =A0 =A0foo.help =3D foo_help;
=A0 =A0 =A0 =A0foo.expect_policy =3D &my_expect_policy;
=A0 =A0 =A0 =A0{
=A0 =A0 =A0 =A0 =A0int i =3D 0;
=A0 =A0 =A0 =A0 =A0int addr =3D 0;
=A0 =A0 =A0 =A0 =A0char *p =3D (char *)&addr;
=A0 =A0 =A0 =A0 =A0int a[4];
=A0 =A0 =A0 =A0 =A0sscanf(dst_ipaddress, "%d.%d.%d.%d", &a[3], &a[2], &=
a[1], &a[0]);
=A0 =A0 =A0 =A0 =A0while(i !=3D 4 ) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(p + i ) =3D a[i];
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i++;
=A0 =A0 =A0 =A0 =A0}
=A0 =A0 =A0 =A0 =A0foo.tuple.dst.u3.ip =3D addr;
=A0 =A0 =A0 =A0 =A0foo.tuple.src.u3.ip =3D 0xc0a80066; //my linux machi=
ne =A0ip
address is 192.168.0.102
=A0 =A0 =A0 =A0}

=A0 =A0 =A0 =A0return nf_conntrack_helper_register(&foo);
}

void =A0fini_conntrack_module(void)
{
=A0 =A0 =A0 =A0nf_conntrack_helper_unregister(&foo);
}

module_init(init_conntrack_module);
module_exit(fini_conntrack_module);

//end of program

-Ratheesh
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
