From: Justin Yaple <yaplej@gmail.com>
Subject: Re: Sending packets from netfilter modules
Date: Thu, 19 Nov 2009 18:25:05 -0800
Message-ID: <8363055a0911191825g286103cm3ed0bbf35163f13d@mail.gmail.com>
References: <932717060@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60410 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbZKTCZH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:25:07 -0500
Received: by yxe17 with SMTP id 17so2597600yxe.33
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2009 18:25:12 -0800 (PST)
In-Reply-To: <932717060@web.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Nils,

I am pretty new to this stuff, but if you would like your packet to
travel through all the paths an inbound packet would take maybe you
can insert it into the stack using ip_rcv()?  I think that should
treat it just like any other inbound packet.

Justin.

On Tue, Nov 17, 2009 at 7:13 AM, Nils Rennebarth <Nils.Rennebarth@web.d=
e> wrote:
> Hi,
>
> I want to send a new packet that was created from scratch from within=
 a netfilter module.
>
> There are already examples in the kernel tree, e.g. in net/ipv4/netfi=
lter/ipt_REJECT.c, so I modeled my code after these and got it working:=
 The packets appear on the wire and are received by other hosts.
>
> However, the packet is finally sent using ip_local_out, so from a fir=
ewall perspective, the packet appears out of thin air and then travels =
through the OUTPUT chain and out to the network device. What I want ins=
tead, is for the packet to take the same way as an incoming packet, i.e=
=2E travel through the PREROUTING chain, gets routed, travels through F=
ORWARD, routed again travels through POSTROUTING and be sent out.
>
> The reason is that my netfilter module acts as a man-in-the-middle in=
 a router, and the self-generated packets should not circumvent the fir=
ewall or need a duplicated ruleset in the OUTPUT chain, etc.
>
> I thought, something like netif_receive_skb or netif_rx may do what I=
 want, but those rely on a prepared skb. Can someone point me into the =
right direction?
> ______________________________________________________
> GRATIS f=FCr alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
> Jetzt freischalten unter http://movieflat.web.de
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
