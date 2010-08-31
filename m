From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: get tcp header
Date: Tue, 31 Aug 2010 20:42:21 +0200
Message-ID: <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
	<alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47701 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0HaSmX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:42:23 -0400
Received: by wyb35 with SMTP id 35so8201004wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2010 11:42:21 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

thank you Jan. I know, I'm not very respectful, sorry. I will
carefully read your pdf. and only after the reading I uso this mailing
list: i think that this is the way.
Good book, Jan, great work.

On Tue, Aug 31, 2010 at 8:35 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> On Tuesday 2010-08-31 20:26, Nicola Padovano wrote:
>
>>Hi guys! i know the skb_transport_header to grab the tcp header of a
>>packet...so i can write:
>>struct tcphdr *tcp_header1 =3D (struct
>>tcphdr*)skb_transport_header(skb), where skb is a certain packet.
>>
>>now, studying some source code that i've found some days ago, i've se=
en this:
>>
>>struct tcphdr *tcp_header2 =A0=3D (void*)ip_hdr(skb) + ip_hdrlen(skb)=
;
>>
>>I immediately thought that the two lines were identical, but but I wa=
s
>>mistaken...in fact if i write this:
>>
>>printk(KERN_INFO "diff: %d\n",(int)((void*)tcp_header2 - (void*)tcp_h=
eader1));
>>
>>i see, "diff: 20"
>>
>>so my question is: what's the difference between the two code lines?
>
>
> skb_transport_header is also explained in the PDF, especially when it
> can not be used.
>



--=20
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
