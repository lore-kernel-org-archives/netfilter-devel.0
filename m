From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: Strange behaviors: tcp header and id flag
Date: Thu, 16 Sep 2010 17:37:45 +0200
Message-ID: <AANLkTikX_gxj-Ze84=KoXJydwn4vD3B7-2GpiG2EkDnw@mail.gmail.com>
References: <AANLkTik0Ay6W=XcOzuE-eUBN6DnCjLks_UPdt20EkCMr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59275 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0IPPiG convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:38:06 -0400
Received: by wwb18 with SMTP id 18so1366wwb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2010 08:38:05 -0700 (PDT)
In-Reply-To: <AANLkTik0Ay6W=XcOzuE-eUBN6DnCjLks_UPdt20EkCMr@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

to all who are interested: the problem was that hping3 use raw socket,
and a raw socket isn't handled by kernel stack protocol!!
(in fact, with netcat it's all ok)

On Thu, Sep 9, 2010 at 6:50 PM, Nicola Padovano
<nicola.padovano@gmail.com> wrote:
> Hi guys! I've two (and..too) big problems.
>
> What I want is only get packet information in the way showed below
>
> -----CODE----
> this is my code (new target extension)
>
> [CODE]
> ...
> tcp_header =3D skb_transport_header(skb);
> ip_header =A0=3D skb_network_header(skb);
> eth_header =3D skb_mac_header(skb);
>
> printk(KERN_INFO "xt_TAR-----> data =A0 =A0 =A0: %p\n",skb->data);
> printk(KERN_INFO "xt_TAR-----> tail =A0 =A0 =A0: %p\n",skb->tail);
> printk(KERN_INFO "xt_TAR-----> mac header: %p\n",eth_header);
> printk(KERN_INFO "xt_TAR-----> ip =A0header: %p\n",ip_header);
> printk(KERN_INFO "xt_TAR-----> tcp header: %p\n",tcp_header);
> printk(KERN_INFO "xt_TAR-----> id: %d\n",ntohs(ip_header->id));
> ...
> [/CODE]
>
> --------FIRST PROBLEM-------
> Let's suppose i digit this iptables line
>
> [IPTABLES_FIRST]
> iptables -A OUTPUT -d www.google.it -j TAR
> #where TAR is my target
> [/IPTABLES_FIRST]
>
> then i use hping in this way:
>
> [HPING_FIRST]
> hping3 -c 1 -d 100 www.google.it
> #i send only one tcp packet with 100bytes of data (+40 headers) to ww=
w.google.it
> [/HPING_FIRST]
>
> this is the output:
>
> [OUTPUT_FIRST]
> xt_TAR-----> sk_buff len: 140
> xt_TAR-----> data =A0 =A0 =A0: f5df2850
> xt_TAR-----> tail =A0 =A0 =A0: f5df28dc
> xt_TAR-----> mac header: (null)
> xt_TAR-----> ip =A0header: f5df2850
> xt_TAR-----> tcp header: f5df2850
> xt_TAR-----> id: 11733
> [/OUTPUT_FIRST]
>
> the id flag is the right one because i've checked it with wireshark,
> so this is right packet.
> But, as i said in the last mail, tcp and ip header have the same
> value! why? i'm on the output path and i should have the transport
> header's right value
> Note: mac header is, rightly, pointing to null (in the output path, w=
e
> have catch the packet before that it is processed by layer2 function)
>
>
> -------SECOND PROBLEM------
> Now let's suppose i digit this iptables line
>
> [IPTABLES_SECOND]
> iptables -A OUTPUT -d localhost -j TAR
> #where TAR is my target, note: -d LOCALHOST
> [/IPTABLES_SECOND]
>
> then i use hping in this way:
>
> [HPING_SECOND
> hping3 -c 1 -d 100 localhost
> #i send only one tcp packet with 100bytes of data (+40 headers) to
> localhost (127.0.0.1)
> [/HPING_SEND]
>
> now the output is:
>
> [OUTPUT_SECOND]
> xt_TAR-----> sk_buff len: 40
> xt_TAR-----> data =A0 =A0 =A0: c3ff3210
> xt_TAR-----> tail =A0 =A0 =A0: c3ff3238
> xt_TAR-----> mac header: (null)
> xt_TAR-----> ip =A0header: c3ff3210
> xt_TAR-----> tcp header: c3ff3224
> xt_TAR-----> id: 0
> [OUTPUT_SECOND]
>
> damn! Note:
> 1. the skbuff len is 40 bytes (remember that i've sent 140
> bytes=3D100data+40headers)
> 2. id flag is 0
> this means (i've checked again with wireshark) that this isn't the
> packet i've sent, but it's the response packet!!!
> and, to futher complicate things, in this case the ip and tcp header
> have the right values (their diff is 20 bytes, in fact ip header len
> is 20 bytes)
>
>
> solutions?
>



--=20
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
