From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 14:15:58 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009011415180.23062@obet.zrqbmnf.qr>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com> <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com> <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42636 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0IAMP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:15:59 -0400
In-Reply-To: <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-01 13:48, Nicola Padovano wrote:

>ok, Jan! Perfect.
>
>But there is a last question: i've seen a source code that get a
>packet just received from the Net: so -if I understand correctly- it
>can't use skb_network_header (IP header) because when i get a packet
>just received from the net i should have only the mac_header set.
>isn't it?
>But, i've seen the usage of skb_network_header...

By the time ebtables is run, skb_mac_header is valid, by the time 
ip/6tables runs, skb_network_header is valid, and once tcp_rcv gets its 
turn to run (but then there is no more Xtables to do), 
skb_transport_header becomes valid.

