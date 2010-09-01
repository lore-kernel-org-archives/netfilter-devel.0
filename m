From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 23:50:40 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009012350050.17324@obet.zrqbmnf.qr>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com> <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com> <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com> <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com> <alpine.LNX.2.01.1009011513090.26297@obet.zrqbmnf.qr>
 <AANLkTi=3Zyn=h-jOd_4zN9ADMNNsbkAbXxPCZikWwiBN@mail.gmail.com> <AANLkTimqUswK9xF-zojqsTe0e_QH3wrM_Zw4tN9jrQfj@mail.gmail.com> <alpine.LNX.2.01.1009012125230.6374@obet.zrqbmnf.qr> <AANLkTikxhnBNV0CFJN2Y4HfLwJJoZYmBw+3Qh6X5ADiE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46728 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab0IAVul (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:50:41 -0400
In-Reply-To: <AANLkTikxhnBNV0CFJN2Y4HfLwJJoZYmBw+3Qh6X5ADiE@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-01 23:34, Nicola Padovano wrote:

>> It merely means that the function is only designed to be executed by
>> ip4tables.
>yes, but this also means that when i receive a packet (=the skb
>pointer of target function) its data pointer points to the beginning
>of ip header (remember that skb->data and skb->tail mark the beginning
>and the end of header+payload of the layer X).
>am i right?

Yes, that happens to be the case. But that's why you use 
skb_{mac,network,transport}_header anyway, because that is more 
invariant than skb->data. (Provided restrictions on its use are obeyed.)
