From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Re: TCP-packet with PUSH flag with wrong payload data in
 LOCAL_OUT
Date: Thu, 22 Jan 2009 15:27:16 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr>
References: <7031232632416@webmail11.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?UTF-8?B?0JrQvtCx0YvQu9GP0L3RgdC60LjQuSDQktC70LDQtNC40LzQuNGA?=
	<kentlinux@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57967 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZAVO1T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:27:19 -0500
In-Reply-To: <7031232632416@webmail11.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-22 14:53, =D0=9A=D0=BE=D0=B1=D1=8B=D0=BB=D1=8F=D0=BD=
=D1=81=D0=BA=D0=B8=D0=B9 =D0=92=D0=BB=D0=B0=D0=B4=D0=B8=D0=BC=D0=B8=D1=80=
 wrote:
>Sorry.=20
>There are my sources.
>(As I undestood mail-list don't support attachments. Am I write?)

Inline is easier to reply on:


># define IP_PRINTF(addr) ((addr) & 0xff), (((addr) >> 8) & 0xff), (((a=
ddr) >> 16) & 0xff), (((addr) >> 24) & 0xff)

Use NIPQUAD and NIPQUAD_FMT.


>int ip_packet_from_local_host(struct iphdr *iph)
>{
>	struct net_device *dev   =3D NULL;
>	struct in_device *in_dev =3D NULL;
>	struct in_ifaddr *ifaddr =3D NULL;
>=09
>	for (dev =3D dev_base; dev; dev =3D dev->next)
>	{
>		if (!dev->ip_ptr)
>		{
>			continue;
>		}
>		in_dev =3D (struct in_device *)dev->ip_ptr;

Don't cast this.

>		ifaddr =3D in_dev->ifa_list;
>		while (ifaddr)
>		{
>			if (iph->saddr =3D=3D ifaddr->ifa_address)
>			{
>				return 1;
>			}
>			ifaddr =3D ifaddr->ifa_next;
>		}
>	}
>=09
>	return 0;
>}
>
>struct net_device* ip_packet_to_local_host(struct iphdr *iph)
>{
>	struct net_device *dev   =3D NULL;
>	struct in_device *in_dev =3D NULL;
>	struct in_ifaddr *ifaddr =3D NULL;
>=09
>	for (dev =3D dev_base; dev; dev =3D dev->next)
>	{
>		if (!dev->ip_ptr)
>		{
>			continue;
>		}
>		in_dev =3D (struct in_device *)dev->ip_ptr;

Nor this.

>		ifaddr =3D in_dev->ifa_list;
>		while (ifaddr)
>		{
>			if (iph->daddr =3D=3D ifaddr->ifa_address)
>			{
>				return dev;
>			}
>			ifaddr =3D ifaddr->ifa_next;
>		}
>	}
>	return NULL;
>}
>
>static unsigned int check_packet(struct sk_buff	*skb, short in_out)
>{
>    if(skb->nh.iph->protocol =3D=3D IPPROTO_TCP)
>    {
>	    struct tcphdr	*tcp;
>	    char		*tcp_data=3DNULL;
>	    char		tcp_flags[4];
>	    unsigned int	tcp_data_off=3D0;
>	   =20
>	    tcp =3D (struct tcphdr *)((char*)skb->nh.iph + skb->nh.iph->ihl *=
 4);
>	    tcp_data_off =3D (tcp->doff)*4;
>	    tcp_data =3D (char *)tcp + tcp_data_off;
>	    tcp_flags[0]=3D' ';
>	    tcp_flags[1]=3D' ';
>	    tcp_flags[2]=3D' ';
>	    tcp_flags[3]=3D'\0';
>
>	    if(tcp->syn)
>		    tcp_flags[0] =3D 'S';
>	    if(tcp->ack)
>		    tcp_flags[1] =3D 'A';
>	    if(tcp->psh)
>		    tcp_flags[2] =3D 'P';
>	    info("=3D=3D=3D HOOK_PACKET: packet src_addr=3D%u.%u.%u.%u:%u dst=
_addr=3D%u.%u.%u.%u:%u [%s] protocol=3D%u, IN_OUT=3D%d, DATA_OFF =3D %u=
",
>			    IP_PRINTF(skb->nh.iph->saddr),ntohs(tcp->source),IP_PRINTF(skb-=
>nh.iph->daddr),ntohs(tcp->dest),=20
>			    tcp_flags, skb->nh.iph->protocol, in_out, tcp_data_off);
>	    if(tcp->psh && ntohs(tcp->dest) =3D=3D 80)
>	    {
>		    info("=3D=3D=3D HOOK_PACKET: DATA=3D%02x %02x %02x %02x %02x %02=
x", tcp_data[0],tcp_data[1],tcp_data[2],tcp_data[3],tcp_data[4],tcp_dat=
a[5]);
>//		    return NF_DROP;
>	    }
>    }

Now consider this - tcp_data[0] invokes undefined behavior when

 * there is no payload

 * or the packet is fragmented (a corner case, though)


Most likely the former is your case.

>unsigned int hook_func(unsigned int hooknum,
>                                struct sk_buff **pskb,
>                                const struct net_device *in,
>                                const struct net_device *out,
>                                int (*okfn)(struct sk_buff *))
>{
>    struct sk_buff * skb =3D * pskb;
>    int ret;
>    if(skb =3D=3D NULL){
>	info("HOOK skb=3D=3DNULL");
>	return NF_DROP;
>    }=09
>    ret =3D check_packet(skb, (short)1); //1 - out

Do not do redundant casts.

>    return(ret);
>}
>
>unsigned int hook_func_in(unsigned int hooknum,
>                                struct sk_buff **pskb,
>                                const struct net_device *in,
>                                const struct net_device *out,
>                                int (*okfn)(struct sk_buff *))
>{
>    struct sk_buff * skb =3D * pskb;
>    int ret;
>    if(skb =3D=3D NULL){
>	info("HOOK_IN skb=3D=3DNULL");
>	return NF_DROP;
>    }=09
>    if(skb->pkt_type =3D=3D PACKET_OUTGOING) =20
>        ret =3D check_packet(skb, (short)1); //1 - out
>    else
>	ret =3D check_packet(skb, (short)0); //0 - in

Stop it! >:)

>    return(ret);
>}
>
>
>Jan 22 11:35:52 FW_EXT kernel: my_fw: fw_init(): Driver my_fw started
>Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): =3D=3D=3D HOOK_P=
ACKET: packet src_addr=3D192.168.0.198:41924 dst_addr=3D192.168.0.132:8=
0 [S  ] protocol=3D6, IN_OUT=3D1, DATA_OFF =3D 40
>Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): =3D=3D=3D HOOK_P=
ACKET: packet src_addr=3D192.168.0.132:80 dst_addr=3D192.168.0.198:4192=
4 [SA ] protocol=3D6, IN_OUT=3D0, DATA_OFF =3D 40
>Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): =3D=3D=3D HOOK_P=
ACKET: packet src_addr=3D192.168.0.198:41924 dst_addr=3D192.168.0.132:8=
0 [ A ] protocol=3D6, IN_OUT=3D1, DATA_OFF =3D 32
>Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): =3D=3D=3D HOOK_P=
ACKET: packet src_addr=3D192.168.0.198:41924 dst_addr=3D192.168.0.132:8=
0 [ AP] protocol=3D6, IN_OUT=3D1, DATA_OFF =3D 32
>Jan 22 11:35:54 FW_EXT kernel: my_fw: check_packet(): =3D=3D=3D HOOK_P=
ACKET: DATA=3D02 00 01 00 01 00
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
