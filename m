From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 16:59:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com> <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com> <4C7BB8DF.7040208@kaleco.net> <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: justin@kaleco.net,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38772 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab0H3O7o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:59:44 -0400
In-Reply-To: <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-08-30 16:21, Nicola Padovano wrote:

>ok justin thank you!
>for now I only need standalone package (to test my code, in future i
>will see how xtables-addons works).
>but (there is always a "but")  the problem, justin, isn't the copy of
>libxt_foo.so in /lib/xtables, but it is the creation of this library.
>as i said before, when i compile the module i don't have no
>lixt_foo.so file. So, how i can create it?

It's all in the 'Writing Netfilter Modules' PDF. You just need to read 
it...
