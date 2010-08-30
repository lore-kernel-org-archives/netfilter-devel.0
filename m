From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 17:15:45 +0200
Message-ID: <AANLkTinrWU1bZXxuBSr5aTALV1=WzR_K0xtvBXED+jtz@mail.gmail.com>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
	<AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
	<4C7BB8DF.7040208@kaleco.net>
	<AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
	<alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: justin@kaleco.net,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36911 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0H3PPq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:15:46 -0400
Received: by fxm13 with SMTP id 13so3296101fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 08:15:45 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan, it's ok now...i've found the complete version of your book!!!
now i just read it.
thank you!

On Mon, Aug 30, 2010 at 4:59 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> On Monday 2010-08-30 16:21, Nicola Padovano wrote:
>
>>ok justin thank you!
>>for now I only need standalone package (to test my code, in future i
>>will see how xtables-addons works).
>>but (there is always a "but") =A0the problem, justin, isn't the copy =
of
>>libxt_foo.so in /lib/xtables, but it is the creation of this library.
>>as i said before, when i compile the module i don't have no
>>lixt_foo.so file. So, how i can create it?
>
> It's all in the 'Writing Netfilter Modules' PDF. You just need to rea=
d
> it...
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
