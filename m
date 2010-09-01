From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 15:20:49 +0200
Message-ID: <AANLkTi=3Zyn=h-jOd_4zN9ADMNNsbkAbXxPCZikWwiBN@mail.gmail.com>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
 <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
 <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com>
 <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com> <alpine.LNX.2.01.1009011513090.26297@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55404 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0IANVM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:21:12 -0400
Received: by wyb35 with SMTP id 35so9236516wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Sep 2010 06:21:11 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009011513090.26297@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

discard that mail :)

On Wed, Sep 1, 2010 at 3:13 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Wednesday 2010-09-01 14:18, Nicola Padovano wrote:
>
>>maybe because the packet is sent firstly to the router and then the
>>router sends to my host a ip packet in which network_header is set? i
>>hope so...
>
> NH is not stored in the packet.
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
