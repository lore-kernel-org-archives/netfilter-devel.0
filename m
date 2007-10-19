From: Jozef Hamar <hamar@jozef.name>
Subject: Re: NF_IP_POST_ROUTING hook question (2.4)
Date: Fri, 19 Oct 2007 10:46:39 +0200
Message-ID: <20071019104639.1ebl44pdk4ooo4ck@mail.krutibrko.sk>
References: <f36b08ee0710160328h3a45d18k41a32dcb8f6f3d4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from majka.z.gurunu.krutibrko.sk ([217.67.19.221]:34855 "EHLO
	krutibrko.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXJSIvp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2007 04:51:45 -0400
In-Reply-To: <f36b08ee0710160328h3a45d18k41a32dcb8f6f3d4e@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

frankly, I'm also surprised that the 'net_device *in' is NULL.

Probably there is much simpler way to do that than my idea, but have =20
you tried to mark somehow those packets in NF_IP_FORWARD and in =20
NF_IP_POST_ROUTING matching only those packets?

Another think... why do you want to match forwarded packets in =20
NF_IP_POST_ROUTING? I don't see the point, but presume that you know =20
what you are doing...

  ---
  Jozef Hamar

  _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _
   `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=
=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=B4 `-=C2=
=B4 `-=C2=B4 `-=C2=B4

  I must not fear. Fear is the mind-killer. Fear is the little-death th=
at
  brings total obliteration. I will face my fear. I will permit it to p=
ass
  over me and through me. And when it has gone past I will turn the inn=
er
  eye to see its path. Where the fear has gone there will be nothing.
  Only  I will remain.


Quoting Yakov Lerner <iler.ml@gmail.com>:

> In the NF_IP_POST_ROUTING hook function, how can I
> tell that packet originated locally vs was forwarded ?
> I need to hook NF_IP_POST_ROUTING not NF_IP_FORWARD.
>
> I'd expect that 'net_device *in' argument to be  not NULL for
> forwarded packets.
>
> But what I see is NULL for both forwarded  and locally sent packets
> (in NF_IP_POST_ROUTING hook).
> Which field of skb can  tell me that packet originated locally ?
>
> Yakov
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
