From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: fragmented packet
Date: Sat, 4 Sep 2010 20:31:28 +0200
Message-ID: <AANLkTimGvx95bexOmJsWYcy2-_0BQuCrra0S52LumYjt@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com> <alpine.LNX.2.01.1009042024170.7459@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52772 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0IDSbu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Sep 2010 14:31:50 -0400
Received: by wwj40 with SMTP id 40so4386136wwj.1
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2010 11:31:49 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009042024170.7459@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> iptables -f? ip6tables -m frag? They already exist :)

yes i know, but the mine is only an exercise...

> The mangle table does already receive defragmented packets (if defrag
> module is loaded).
>
i don't load the defrag module, so the packet is not you defragmented:
infact the output says "fragmented"...
the problem is: why there are some frag with the same frag off?


-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
