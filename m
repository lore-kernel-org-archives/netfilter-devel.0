From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 20:20:10 +0100
Message-ID: <4DA5F76A.5040504@googlemail.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr> <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com> <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr> <4DA59881.1050501@wildgooses.com> <alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr> <4DA5D346.5030303@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	=?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3c=?= =?UTF-8?B?c2tp?=
	<zenczykowski@gmail.com>, netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38874 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab1DMTUS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:20:18 -0400
Received: by wwa36 with SMTP id 36so1115035wwa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2011 12:20:17 -0700 (PDT)
In-Reply-To: <4DA5D346.5030303@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Hmm, for the moment I'm happy to simply patch out all modprobe calls in
> xtables.c, but there may come a time when I need more flexibility.  Does
> anyone care enough about this to consider a more clever solution?
>   
I've been following this with great interest as I also intend to compile 
and use iptables in one of my embedded devices (603e/G2-based) and will, 
most probably, have similar problems to what you have experienced, so if 
there is a better solution to the (proposed) patches I'd like to know 
about it too!

