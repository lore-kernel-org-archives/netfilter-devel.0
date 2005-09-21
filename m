From: JC <bikkit@gmail.com>
Subject: How to change the source address of a tcp packet
Date: Wed, 21 Sep 2005 06:04:33 +0100
Message-ID: <a60102c305092022044e76b204@mail.gmail.com>
Reply-To: JC <bikkit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

netfilter hook function called at NF_IP_PRE_ROUTING:

unsigned int in_hook(unsigned int hooknum,
struct sk_buff **skb,
const struct net_device *in,
const struct net_device *out,
int (*okfn)(struct sk_buff *))
{
  struct iphdr *my_ipheader;
  struct tcphdr *my_tcpheader;
  struct udphdr *my_udpheader;

  unsigned char *my_ip1;
  unsigned char *my_ip2;
  unsigned char *my_ip3;
  unsigned char *my_ip4;
  my_ip1 =3D "SOMETHING_IN_HEX";  //
  my_ip2 =3D "SOMETHING_IN_HEX";  //
  my_ip3 =3D "SOMETHING_IN_HEX";  //
  my_ip4 =3D "SOMETHING_IN_HEX";  //

  if (out)
    {
      if(out->name)
=09{
=09  // We do NOT want to handle a "weird" null packet
=09  if(skb =3D=3D NULL)
=09    {
=09=09  print_string("NULL skb!!!");
=09=09  return NF_ACCEPT;
=09    }
=09
=09    my_ipheader =3D (struct iphdr*)((*skb)->nh.iph);
=09    if (my_ipheader->protocol =3D=3D IPPROTO_TCP)
=09      {
=09=09  print_string("This is a tcp packet");
=09=09  if (my_ipheader->saddr =3D=3D *(unsigned int *)my_ip3)
=09=09    {
=09=09       print_string("with source IP xxx.xxx.xxx.xxx");
=09=09      ((struct iphdr*)((*skb)->nh.iph))->saddr =3D my_ip2;
=09=09      ((struct sk_buff*)(*skb))->proto_csum_blank =3D 1;
=09=09      return NF_ACCEPT;
=09=09    }
=09      }
=09}
      else
=09{
=09  print_string("out is null");
=09}
    }

  print_string("packet is being accepted!");
  return NF_ACCEPT;
}

Apparently, these two steps are not sufficient to change the source
address of an skb:
   ((struct iphdr*)((*skb)->nh.iph))->saddr =3D my_ip2;
   ((struct sk_buff*)(*skb))->proto_csum_blank =3D 1;

All packets that are treated by these are actually dropped.
What *IS* required so that the source address of the skb is changed to
another that is on another interface of the machine?

J
