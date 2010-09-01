From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 21:26:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009012125230.6374@obet.zrqbmnf.qr>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com> <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com> <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com> <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com> <alpine.LNX.2.01.1009011513090.26297@obet.zrqbmnf.qr>
 <AANLkTi=3Zyn=h-jOd_4zN9ADMNNsbkAbXxPCZikWwiBN@mail.gmail.com> <AANLkTimqUswK9xF-zojqsTe0e_QH3wrM_Zw4tN9jrQfj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37441 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0IAT0t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:26:49 -0400
In-Reply-To: <AANLkTimqUswK9xF-zojqsTe0e_QH3wrM_Zw4tN9jrQfj@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-01 17:23, Nicola Padovano wrote:

>These are my last questions.
>
>- i've specified in my code NFPROTO_IPV4 (family field in xt_target
>struct), this means that my packet is at layer 3? i.e. the layer 2
>function has already processed it?

It merely means that the function is only designed to be executed by 
ip4tables.
