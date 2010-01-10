From: Xiong Wu <xiong.wu1981@gmail.com>
Subject: Re: Question about ipt_REJECT
Date: Sun, 10 Jan 2010 21:24:40 +0800
Message-ID: <c794cd671001100524g2700b23crb8fa31e9d1f8e293@mail.gmail.com>
References: <c794cd670912282337v5a57508cwbc4c815cf53d363b@mail.gmail.com>
	 <4B41E5B2.1080609@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:7486 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0AJNYl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jan 2010 08:24:41 -0500
Received: by ey-out-2122.google.com with SMTP id 4so473528eyf.5
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Jan 2010 05:24:40 -0800 (PST)
In-Reply-To: <4B41E5B2.1080609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have to reject some connection which are confirmed, therefor I apply
the following patch to solve this problem. Please help me to review
this patch.

--- linux-2.6.32.3/net/ipv4/netfilter/ipt_REJECT.c      2010-01-07
07:07:45.000000000 +0800
+++ linux-2.6.32.3-new/net/ipv4/netfilter/ipt_REJECT.c  2010-01-10
21:18:11.000000000 +0800
@@ -23,6 +23,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
+#include <include/net/netfilter/nf_conntrack.h>
 #ifdef CONFIG_BRIDGE_NETFILTER
 #include <linux/netfilter_bridge.h>
 #endif
@@ -40,6 +41,9 @@
        const struct tcphdr *oth;
        struct tcphdr _otcph, *tcph;
        unsigned int addr_type;
+       enum ip_conntrack_info ctinfo;
+       const struct nf_conn *ct;
+

        /* IP header checks: fragment. */
        if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
@@ -120,7 +124,12 @@
        if (nskb->len > dst_mtu(skb_dst(nskb)))
                goto free_nskb;

-       nf_ct_attach(nskb, oldskb);
+       /*only when the ct isn't confirmed, attach it to reset packet*/
+       ct =3D nf_ct_get(skb, &ctinfo);
+       if((ct !=3D NULL) && (!nf_ct_is_confirmed(ct)))
+       {
+               nf_ct_attach(nskb, oldskb);
+       }

        ip_local_out(nskb);
        return;

Thanks,
Xiong

2010/1/4 Patrick McHardy <kaber@trash.net>:
> Xiong Wu wrote:
>> Hi All,
>>
>> I found the TCP RST packet sent from ipt_REJECT target isn't able to
>> update related conntrack state.
>>
>> I install a 2.6.30.10 kernel as a router and add a iptables rule wit=
h
>> REJECT target to reset specific connections. =A0However =A0I found =A0=
when
>> the packets is handled by the ipt_REJECT and the TCP RST packet is
>> sent, the related conntrack state isn't updated to CLOSE state.
>>
>> Then I review the ipt_REJECT codes. I found the target attach the ol=
d
>> conntrack to RST packet as:
>> {
>> =A0 =A0nf_ct_attach(nskb, oldskb);
>> =A0 =A0ip_local_out(nskb);
>> }
>>
>> Therefor the nf_conntrack_in() will ignore this RST packet due to th=
e
>> nfct is valid in skb.
>> {
>> =A0 =A0 =A0if (skb->nfct) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NF_CT_STAT_INC_ATOMIC(net, i=
gnore);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NF_ACCEPT;
>> =A0 =A0 =A0}
>> }
>>
>>
>> Is there any reason to attach the old conntrack to new RST skb? =A0I
>> think let the RST packet lookup and update related conntrack is
>> better.
>
> The packet that is rejected might be half-way mangled by NAT (DNAT
> performed, SNAT not yet performed). In this state conntrack is
> be unable to associate the generated RST packet with the conntrack
> entry. The same applies when you reject the first packet of a
> connection which hasn't entered the hash tables yet.
>
> Usually this shouldn't be a problem exactly because you would
> normally reject the first packet of a connection, so it wouldn't
> be placed in the conntrack hash.
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
