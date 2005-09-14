From: swapnil surve <surve.swapnil@gmail.com>
Subject: Help needed!!!!!!!!!!
Date: Wed, 14 Sep 2005 15:18:18 +0530
Message-ID: <c8af84e0050914024860d89464@mail.gmail.com>
Reply-To: surve.swapnil@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi=20
I m  new to kernel developement=20
I m trying to send ICMP_ECHOREPLY in responce to ICMP_ECHO from the
kernel itself using netfilter hooks
I m using dev_queue_xmit() to send packets where I dont get a negative
value in return
But for some reason my reply is not received by requester.
please help mehere is my code::
=20
#define __KERNEL__
#define MODULE
#include<linux/module.h>
#include<linux/kernel.h>
#include<linux/netdevice.h>
#include<linux/netfilter.h>
#include<linux/netfilter_ipv4.h>
#include<linux/in.h>
//#include<linux/tcp.h>
=20
#include <linux/ip.h>
#include <linux/tcp.h>
#include<linux/icmp.h>
#include<linux/if_ether.h>
#include<linux/if_packet.h>
#include<linux/if_arp.h>
#include<net/checksum.h>


 /* This is the structure we shall use to register our function */
=20
static struct nf_hook_ops nfho;
static struct nf_hook_ops nfho1;

/* Name of the interface we want to drop packets from */
struct icmphdr *icmp; =20
 /* This is the hook function itself */
=20
=09
in_cksum (addr, len)
     u_short *addr;
     int len;
{
  register int nleft =3D len;
  register u_short *w =3D addr;
  register int sum =3D 0;
  u_short answer =3D 0;

  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
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
  sum =3D (sum >> 16) + (sum & 0xffff); /* add hi 16 to low 16 */
  sum +=3D (sum >> 16); /* add carry */
  answer =3D ~sum; /* truncate to 16 bits */
  return (answer);
}=20


unsigned int hook_func(unsigned int hooknum,
                       struct sk_buff **skb,
                       const struct net_device *in,
                       const struct net_device *out,
                       int (*okfn)(struct sk_buff *))
{
=09unsigned int temp;
=09int error;
=09struct sk_buff *sb =3D *skb;
=09struct device *ndev=3D NULL;
=09int sum;
=09if (sb->nh.iph->protocol =3D=3D IPPROTO_ICMP)=20
=09{
/*=09=09printk("\n%d",sb->nh.iph->saddr);
=09=09printk("%d",sb->nh.iph->daddr);
=09=09printk("ICMP PACKET");=09        */
=09=09icmp =3D (struct icmphdr *)(sb->data + sb->nh.iph->ihl * 4);
=09=09//printk("\n checksum before : %x",sb->csum);
=09=09if(icmp->type =3D=3D ICMP_ECHO)
=09=09{
=09=09=09
=09=09=09temp=3Dsb->nh.iph->saddr;
=09=09=09sb->nh.iph->saddr=3Dsb->nh.iph->daddr;
=09=09=09sb->nh.iph->daddr=3Dtemp;
=09=09=09sb->pkt_type=3DPACKET_OUTGOING;
=09=09=09//icmp_send(sb,ICMP_ECHOREPLY,0,out);
=09=09=09//ip_send_check(sb->nh.iph);
=09=09=09//sb->pkt_type=3DPACKET_OUTGOING;
=09=09=09icmp->type=3DICMP_ECHOREPLY;
=09=09=09
=09=09=09icmp->code=3D0x0;
=09=09=09icmp->checksum=3D0;
=09=09=09
=09=09=09icmp->checksum=3Din_cksum((unsigned short
*)icmp,(sb->len-sb->nh.iph->ihl * 4));
=09=09=09//printk("\nICMP ECHO RECIVED FROM %d",sb->nh.iph->saddr);
=09=09=09sb->pkt_type=3DPACKET_OUTGOING;
=09=09=09
=09=09=09switch (sb->dev->type)=20
=09=09=09{
=09=09=09=09case ARPHRD_PPP:=09=09      =20
=09=09=09=09break;
=09=09=09=09case ARPHRD_LOOPBACK:
=09=09=09=09case ARPHRD_ETHER:
=09=09=09=09{
=09=09=09=09=09unsigned char t_hwaddr[ETH_ALEN];
=09=09=09=09=09//printk("\nchnging mac");
=09   =09=09=09=09//printk("\n%s",sb->data);
=09=09=09=09=09//sb->len +=3D ETH_HLEN; //sizeof(sb->mac.ethernet);
=09=09=09=09=09memcpy(t_hwaddr, (sb->mac.ethernet->h_dest), ETH_ALEN);
=09=09=09=09=09memcpy((sb->mac.ethernet->h_dest), (sb->mac.ethernet->h_sour=
ce),ETH_ALEN);
=09=09=09=09=09memcpy((sb->mac.ethernet->h_source), t_hwaddr, ETH_ALEN);
=09=09=09=09=09break;
=09=09=09=09}
=09=09=09}
=09=09=09
=09=09=09=09dev_queue_xmit(sb);
=09=09=09return NF_STOLEN;
=09=09=09
=09=09}=20
=09=09=09
=09}
return NF_ACCEPT;
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

    return 0;
}
=09
/* Cleanup routine */
void cleanup_module()
{
    nf_unregister_hook(&nfho);

}
