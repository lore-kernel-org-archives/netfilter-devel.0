From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: register an hook
Date: Sat, 24 Apr 2010 13:39:51 +0200
Message-ID: <q2yede9a9eb1004240439q6026727dw48cc9900543717ba@mail.gmail.com>
References: <z2uede9a9eb1004230155oe674c584m2ca2d0b4ba3490c0@mail.gmail.com>
	 <alpine.LSU.2.01.1004231227410.30678@obet.zrqbmnf.qr>
	 <i2iede9a9eb1004230350gfa9279bej12902ff2b6522664@mail.gmail.com>
	 <alpine.LSU.2.01.1004231423530.11467@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51284 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0DXLjx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Apr 2010 07:39:53 -0400
Received: by wwg30 with SMTP id 30so455570wwg.19
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Apr 2010 04:39:52 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1004231423530.11467@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ok jan, thank you! i'm sorry but i'm a very newbie in this field.
anyway i've have some questions.

first of all: if i program a new target i don't have interest in the
management of the hooks? is it right? and why?

second question: when the checkentry function is used?

thank you again :)

On Fri, Apr 23, 2010 at 2:25 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Friday 2010-04-23 12:50, Nicola Padovano wrote:
>
>>what's the difference? what is a target?
>>I'm analyzing the tarpit patch
>>(http://enterprise.bih.harvard.edu/pub/tarpit-updates/tarpit-2.6.29.patch)
>>and i've found only the registration of that target. and so, how it
>>works, if there isn't an hook registration?
>>
>>help me, please :(
>
> Targets are invoked via Xtables which is a hook user.
>
> targets: http://en.wikipedia.org/wiki/Iptables
> tarpit: http://xtables-addons.sf.net/
> and subsequently: http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
