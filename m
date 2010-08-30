From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Tue, 31 Aug 2010 01:17:19 +0200
Message-ID: <AANLkTikfMSLqPHMbC64S2_xmUw3j206yG0XPHMYa25js@mail.gmail.com>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
	<AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
	<4C7BB8DF.7040208@kaleco.net>
	<AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
	<alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr>
	<AANLkTi=tFWwOrjBKPf2NfT3CCE3zfjpDHnuZnFo4ugy=@mail.gmail.com>
	<alpine.LNX.2.01.1008302045310.1164@obet.zrqbmnf.qr>
	<AANLkTinD1+AmaB=n3zofaxSv4Q5h44zxzFrK8441-qUq@mail.gmail.com>
	<alpine.LNX.2.01.1008302107030.2418@obet.zrqbmnf.qr>
	<AANLkTikqMSHJDDe7VsOVUc_yqCERNnHXsb7pVNXmZnGP@mail.gmail.com>
	<alpine.LNX.2.01.1008310024470.7730@obet.zrqbmnf.qr>
	<AANLkTikPW8rUi-N02Ymc4t38EX4KOraNVfzZtocMobTT@mail.gmail.com>
	<AANLkTinwvQF4xtaQZ3qveW3SqCSk3qvjoB1y2O1cSPP8@mail.gmail.com>
	<alpine.LNX.2.01.1008310107550.10766@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	jcm@jonmasters.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47249 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0H3XRW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 19:17:22 -0400
Received: by wyb35 with SMTP id 35so7182260wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 16:17:21 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1008310107550.10766@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(!!Jan you're a guru!!)

so, how the things work? why only after i digit "iptables...." and
then "insmod" i've the resolutions of symbol?

(this is a great mailing list, i'm learning a lot, thank you very much)

On Tue, Aug 31, 2010 at 1:09 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Tuesday 2010-08-31 01:02, Nicola Padovano wrote:
>
>>something new:
>>the things work in this way:
>>
>>- reboot the machine, so my system is "clear"
>>- if i do insmod before iptables i've "unknown symbol"
>
> insmod does not do automatic symbol resolution like modprobe. modprobe
> on the other hand only looks in /lib/modules/... (That sucks.)
>
> Maybe Jon Masters can do something about this misalignmennt of features
> in module-init-tools.
>
>
>>- but if i do first iptables (i've the error message saying that
>>doesn't exist the target TAR) and then insmod, the insmod works
>>well!!!
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
