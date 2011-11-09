From: Paul Guo <ggang@tilera.com>
Subject: Re: unaligned ip header due to ip_route_me_harder()->pskb_expand_head()
Date: Wed, 9 Nov 2011 17:33:39 +0800
Message-ID: <4EBA48F3.8040906@tilera.com>
References: <4EB9449D.8020701@tilera.com> <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([206.83.70.75]:20010 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1KIJdq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:33:46 -0500
In-Reply-To: <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>




> Le mardi 08 novembre 2011 =C3=A0 23:02 +0800, Paul Guo a =C3=A9crit :
>> Hi,
>>
>> Recently on our chip (arch/tile), a panic caused by unaligned data a=
ccess was observed. The stack looks like this:
>>
>>   frame 0: 0xfd247ef0 ipt_do_table+0x240/0x850 (sp 0xf6a6fb40)
>>   frame 1: 0xfd4a44a8 nf_iterate+0xe8/0x188 (sp 0xf6a6fbd0)
>>   frame 2: 0xfd4ab850 nf_hook_slow+0xa0/0x180 (sp 0xf6a6fbf8)
>>   frame 3: 0xfd0c02a8 ip_local_out+0x28/0x88 (sp 0xf6a6fc30)
>>   frame 4: 0xfd25b778 ip_push_pending_frames+0x4f8/0x798 (sp 0xf6a6f=
c40)
>>   frame 5: 0xfd272298 icmp_send+0x670/0x700 (sp 0xf6a6fc60)
>>   frame 6: 0xfd593d28 ipv4_link_failure+0x28/0xa8 (sp 0xf6a6fd50)
>>   frame 7: 0xfd5aae90 arp_error_report+0x70/0x90 (sp 0xf6a6fd60)
>>   frame 8: 0xfd483f28 neigh_invalidate+0x128/0x1b0 (sp 0xf6a6fd70)
>>   frame 9: 0xfd3b5410 neigh_timer_handler.cold+0x2a0/0x2e0 (sp 0xf6a=
6fd98)
>>   frame 10: 0xfd028cd8 run_timer_softirq+0x2d8/0x4a8 (sp 0xf6a6fdb0)
>>   frame 11: 0xfd02bfe0 __do_softirq+0x1e0/0x330 (sp 0xf6a6fe08)
>>   frame 12: 0xfd034808 do_softirq+0xc8/0x160 (sp 0xf6a6fe50)
>>   frame 13: 0xfd034658 irq_exit+0x98/0x130 (sp 0xf6a6fe60)
>>   frame 14: 0xfd031cc0 do_timer_interrupt+0xc0/0xf8 (sp 0xf6a6fe68)
>>   frame 15: 0xfd3b1da8 handle_interrupt+0x2d8/0x2e0 (sp 0xf6a6fe80)
>>   <interrupt 25 while in kernel mode>
>>   frame 16: 0xfd5cb350 _cpu_idle_nap+0x0/0x10 (sp 0xf6a6ffd0)
>>   frame 17: 0xfd06b020 cpu_idle+0x1a0/0x3b8 (sp 0xf6a6ffd0)
>>
>> int ip_route_me_harder(struct sk_buff *skb, unsigned addr_type)
>> {
>>         ......
>> 	/* Change in oif may mean change in hh_len. */
>> 	hh_len =3D skb_dst(skb)->dev->hard_header_len;
>> 	if (skb_headroom(skb) < hh_len &&
>> 	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC=
))
>> 		return -1;
>> }
>>
>> During testing, our chip acts as NAT. the interface for internal hos=
ts are configured with vlan. When we try to ping a unknown external hos=
t from internal hosts, it panic immediately due to unaligned data acces=
s. In this case, hh_len is equal to 18 (vlan mac header length), headro=
om (skb_headroom(skb)) for this packet is 16 so after calling pskb_expa=
nd_head() the ip header becomes to be unaligned.  This seems to be a bu=
g in netfilter. Modifying pskb_expand_head() like this can resolve this=
 issue.
>>
>> + pskb_expand_head(skb, LL_RESERVED_SPACE(skb_dst(skb)->dev)  - skb_=
headroom(skb), 0, GFP_ATOMIC))
>> - pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
>>
>=20
> or=20
>=20
> pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)), 0, G=
=46P_ATOMIC))

Thanks. This looks better.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
