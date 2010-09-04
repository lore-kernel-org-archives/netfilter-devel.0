From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: fragmented packet
Date: Sat, 4 Sep 2010 20:56:01 +0200
Message-ID: <AANLkTimZnFK+vOUTvbo9M5FmGRGBBRrSQKGmPOrcSeEx@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
 <alpine.LNX.2.01.1009042024170.7459@obet.zrqbmnf.qr> <AANLkTimGvx95bexOmJsWYcy2-_0BQuCrra0S52LumYjt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0IDS4X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Sep 2010 14:56:23 -0400
Received: by wyf22 with SMTP id 22so1339688wyf.19
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2010 11:56:22 -0700 (PDT)
In-Reply-To: <AANLkTimGvx95bexOmJsWYcy2-_0BQuCrra0S52LumYjt@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(ps: i _suppose_ that i've not the defrag module because i've
"fragmented" message in my output: i've checked MF bit and fragment
offset field and they "say" to me that the packet is
fragmented...so...)

On Sat, Sep 4, 2010 at 8:31 PM, Nicola Padovano
<nicola.padovano@gmail.com> wrote:
>> iptables -f? ip6tables -m frag? They already exist :)
>
> yes i know, but the mine is only an exercise...
>
>> The mangle table does already receive defragmented packets (if defrag
>> module is loaded).
>>
> i don't load the defrag module, so the packet is not you defragmented:
> infact the output says "fragmented"...
> the problem is: why there are some frag with the same frag off?
>
>
> --
> Nicola Padovano
> e-mail: nicola.padovano@gmail.com
> web: http://npadovano.altervista.org
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
