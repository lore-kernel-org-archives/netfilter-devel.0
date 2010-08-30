From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Tue, 31 Aug 2010 00:30:20 +0200
Message-ID: <AANLkTikPW8rUi-N02Ymc4t38EX4KOraNVfzZtocMobTT@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42374 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0H3WaW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:30:22 -0400
Received: by wyb35 with SMTP id 35so7141902wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 15:30:21 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1008310024470.7730@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(in italy it's half past midnight, i've sent the email only to jan, thi=
s is it)

jan, sorry for my impatience...but it seems a non-deterministic damn pr=
oblem!
just now, without a reason, i repeat insmoding and i don't have that
error message...

On Tue, Aug 31, 2010 at 12:25 AM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
> On Monday 2010-08-30 23:47, Nicola Padovano wrote:
>
>>i'm sorry...but i've restarted my computer and then i tried to insmod
>>the module and now i have:
>>insmod: error inserting './xt_TAR.ko': -1 Unknown symbol in module
>>with this dmesg result:
>>[ =A0413.359837] xt_TAR: Unknown symbol xt_register_target (err 0)
>>[ =A0413.360019] xt_TAR: Unknown symbol xt_unregister_target (err 0)
>>
>>wtf now? help me, please. i need to sleep. :P
>
>
> 1. Patience
> 2. Read the PDF about module licenses.
> 3. ???
> 4. Profit!
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
