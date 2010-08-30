From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: write a new simple target for netfilter
Date: Tue, 31 Aug 2010 01:09:18 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1008310107550.10766@obet.zrqbmnf.qr>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com> <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com> <4C7BB8DF.7040208@kaleco.net> <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
 <alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr> <AANLkTi=tFWwOrjBKPf2NfT3CCE3zfjpDHnuZnFo4ugy=@mail.gmail.com> <alpine.LNX.2.01.1008302045310.1164@obet.zrqbmnf.qr> <AANLkTinD1+AmaB=n3zofaxSv4Q5h44zxzFrK8441-qUq@mail.gmail.com>
 <alpine.LNX.2.01.1008302107030.2418@obet.zrqbmnf.qr> <AANLkTikqMSHJDDe7VsOVUc_yqCERNnHXsb7pVNXmZnGP@mail.gmail.com> <alpine.LNX.2.01.1008310024470.7730@obet.zrqbmnf.qr> <AANLkTikPW8rUi-N02Ymc4t38EX4KOraNVfzZtocMobTT@mail.gmail.com>
 <AANLkTinwvQF4xtaQZ3qveW3SqCSk3qvjoB1y2O1cSPP8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	jcm@jonmasters.org
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41648 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab0H3XJT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 19:09:19 -0400
In-Reply-To: <AANLkTinwvQF4xtaQZ3qveW3SqCSk3qvjoB1y2O1cSPP8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-08-31 01:02, Nicola Padovano wrote:

>something new:
>the things work in this way:
>
>- reboot the machine, so my system is "clear"
>- if i do insmod before iptables i've "unknown symbol"

insmod does not do automatic symbol resolution like modprobe. modprobe 
on the other hand only looks in /lib/modules/... (That sucks.)

Maybe Jon Masters can do something about this misalignmennt of features 
in module-init-tools.


>- but if i do first iptables (i've the error message saying that
>doesn't exist the target TAR) and then insmod, the insmod works
>well!!!
