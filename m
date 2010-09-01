From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 17:23:33 +0200
Message-ID: <AANLkTimqUswK9xF-zojqsTe0e_QH3wrM_Zw4tN9jrQfj@mail.gmail.com>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
 <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
 <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com>
 <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com>
 <alpine.LNX.2.01.1009011513090.26297@obet.zrqbmnf.qr> <AANLkTi=3Zyn=h-jOd_4zN9ADMNNsbkAbXxPCZikWwiBN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51796 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab0IAPX5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:23:57 -0400
Received: by wwj40 with SMTP id 40so97758wwj.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Sep 2010 08:23:55 -0700 (PDT)
In-Reply-To: <AANLkTi=3Zyn=h-jOd_4zN9ADMNNsbkAbXxPCZikWwiBN@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These are my last questions.

- i've specified in my code NFPROTO_IPV4 (family field in xt_target
struct), this means that my packet is at layer 3? i.e. the layer 2
function has already processed it?

- suppose that we are in layer N: skb->data and skb->tail mark the
beginning and the end of header+data of layer N?

thank you all guys, in primis Jan.
