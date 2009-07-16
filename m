From: Luca Pesce <pesce.luca@gmail.com>
Subject: Re: xt_TCPMSS target dropping SYN packets with data: suggested mod
Date: Thu, 16 Jul 2009 09:15:32 +0200
Message-ID: <873dce860907160015n6a37715x10aae10249ece994@mail.gmail.com>
References: <873dce860907090641n31254e30g48886aefbbc6474e@mail.gmail.com>
	 <4A5DF7DD.2050908@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43228 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZGPHPd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:15:33 -0400
Received: by fxm18 with SMTP id 18so3902203fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2009 00:15:32 -0700 (PDT)
In-Reply-To: <4A5DF7DD.2050908@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,
    thanks for your answer.
I completely agree with you about the actual usefulness of such a mod:
in real life SYNs with payload are almost not present, unfortunately I
found one of those cases and I was thinking about this mod.

Apart from the real life scenarios, I do not understand your sentence:

> It doesn't seem like a very useful feature,
> considering all the stacks supporting syn cookies.

Did you mean that syn cookies would drop that SYN with data anyway? Or
that MSS mangling itself would harm syn cookies tecniques?
Thanks for your clarifications.

Luca


On Wed, Jul 15, 2009 at 5:38 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
>
> Luca Pesce wrote:
> > Hi all,
> > =A0 =A0I have a question and a possible patch/mod for target TCPMSS=
 (xt_TCPMSS.c).
> > At the very beginning of function tcpmss_mangle_packet(), the skb c=
ontaining the
> > TCP SYN packet is checked to see if it is containing data (on a sid=
e note, SYN
> > with data is quite unusual...); if so, the packet is drastically dr=
opped.
> > The reason is explained in RR's comment to the code, I am copy/past=
ing the
> > beginning of this function with the length check at the bottom of t=
his mail.
> > RR says that we cannot change MSS on a packet which is already carr=
ying data
> > (it would be too late): could we relax this check, seeing if the tc=
p payload is
> > less than the MSS we are about to set?
>
> We probably could change that. I'm wondering though, did you actually
> see this in real life? It doesn't seem like a very useful feature,
> considering all the stacks supporting syn cookies.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
