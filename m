From: "Jorge Garcia" <anarkophobia@latinmail.com>
Subject: RE:Re: netfilter programming
Date: Mon, 29 Mar 2004 08:08:56 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329130856.ED26B3BA3E9@smtp.latinmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="latinmail.com_linux02100.dn.net_72c97bf9697fe300548dc0d656e0a117"
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


--latinmail.com_linux02100.dn.net_72c97bf9697fe300548dc0d656e0a117
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

hi, and thanx for answer me, im sorry if i didnt explain well on my las=
t post.
for educational and intelectual satisfaction i want to make a module th=
at do this:
iptables -A INPUT -i eth0 -s 192.168.100.7 -p tcp --dport 23 -j DROP
So i search the internet and i find very little stuff about this but i =
make the following code :

#define __KERNEL__

#define MODULE



#include <linux/ip.h>=09=09=09

#include <linux/kernel.h>=09=09

#include <linux/module.h>=09=09

#include <linux/netdevice.h>=09=09

#include <linux/netfilter.h>=09=09

#include <linux/netfilter_ipv4.h>=09

#include <linux/skbuff.h>=09=09

#include <linux/tcp.h>=09=09=09/* Para la cabecera TCP */

static struct nf_hook_ops nfho;=09=09/* Registramos la funcion */

static unsigned char *direccion_ip =3D "xC0xA8x64x07";  =09/* 192.168.1=
00.7en Network Byte Order */

static char *interface =3D "eth0"; =09=09=09=09=09=09=09/* Interface et=
h0 */

unsigned char *puerto =3D "x00x17";=09=09=09=09                /* Puert=
o 23 (Telnet) */

struct sk_buff *sock_buff;=09=09=09=09=09=09=09=09/* Socket Kernel Buff=
er */

struct tcphdr *cabecera_tcp;=09                                        =
        /* Cabecera TCP */

/* La funcion */

unsigned int hook_func(unsigned int hooknum,
                        struct sk_buff **skb,
                        const struct net_device *in,
                        const struct net_device *out,
                        int (*okfn)(struct sk_buff *))
{

=09if(strcmp(in->name,interface) =3D=3D 0){          /*  Filtrado por i=
nterface */
            return NF_DROP;=20
        }                                                              =
    =20

=09sock_buff =3D *skb;

=09

=09if(!sock_buff){
           return NF_ACCEPT;=09=09=09/* Chequea un paquete IP valido */=

        }

=09if(!(sock_buff->nh.iph)){=20
            return NF_ACCEPT;=20
        }=09=09=09



=09/* Descarta paquetes si vienen de la direccion 192.168.100.7 */ =09

=09if(sock_buff->nh.iph->saddr =3D=3D *(unsigned int*)direccion_ip){
            return NF_DROP;=20
        }

=09=09

=09if(sock_buff->nh.iph->protocol !=3D 17){=09/* Nos aseguramos de que =
el paquete sea tcp */
           return NF_ACCEPT;=20
        }  =09

=09cabecera_tcp =3D (struct tcphdr *)(sock_buff->data   (sock_buff->nh.=
iph->ihl *4));=09/* Descartamos por puerto */

=09if((cabecera_tcp->dest) =3D=3D *(unsigned short*)puerto){
            return NF_DROP;=20
        } =20

return NF_ACCEPT;=09=09=09/* Si todo lo anterior falla, se acepta el pa=
quete */

} =20

/* Rutina de inicializacion */
int init_module()
{
    /* LLenamos la estructura de la funcion  gancho */
    nfho.hook     =3D hook_func;         /* Manejador de funcion*/
    nfho.hooknum  =3D NF_IP_PRE_ROUTING; /* Primer gancho para  IPv4 */=

    nfho.pf       =3D PF_INET; /* famila */
    nfho.priority =3D NF_IP_PRI_FIRST;   /* Hacer nuestra funcion prime=
ra */
 =20
    nf_register_hook(&nfho);
   =20
    return 0;
}
=09
/* Rutina de limpieza */
void cleanup_module()
{
    nf_unregister_hook(&nfho);
}

Comments are in spanish becouse i speak that lenguaje :)
The problemas are the followings:
I dont understand how it drops from source port, i only copy and paste =
from a code i found in the net, please explain me something about how t=
o programming that part.
The other problem is that this module is this:
This code showld drop incomming connections to port 23 from 192.168.100=
7, but its drop connections to port 23 from all the addresses in the l=
ocal network, like 192.168.100.12
The code must have an error and please if anyone can find me please tel=
l me as soon as u can.
I hope this clar the situation of what i want and if anyone have a ques=
tion please ask me .
Excuse my english and please understand me :)
FrediX



http://www.latinmail.com - La forma m=E1s c=F3moda de enviar y recibir =
tus e-mails
--latinmail.com_linux02100.dn.net_72c97bf9697fe300548dc0d656e0a117--
