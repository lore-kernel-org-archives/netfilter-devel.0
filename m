From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 15:13:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009011513090.26297@obet.zrqbmnf.qr>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com> <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com> <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com> <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40860 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab0IANNX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:13:23 -0400
In-Reply-To: <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-01 14:18, Nicola Padovano wrote:

>maybe because the packet is sent firstly to the router and then the
>router sends to my host a ip packet in which network_header is set? i
>hope so...

NH is not stored in the packet.
