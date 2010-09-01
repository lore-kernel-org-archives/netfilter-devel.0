From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 12:53:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com> <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com> <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51084 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0IAKxG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:53:06 -0400
In-Reply-To: <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-01 11:57, Nicola Padovano wrote:

>"If a packet is handled by a bridge, that is, a component that does not
>deal with layer 3 or 4, there is no point in spending time to find the
>start of the layer 3/4 header."
>
>Ok, well: great. but in this case (bridge) also the skb_network_header
>function is senseless because we don't have to find layer3 header.
>isn't it?

Correct.

>in general: when i can use the skb_transport_header function?

When a transport header pointer has been set. Which is when the 
appropriate layer-X function has processed it. (After ip_rcv for 
example)
On the output path, since it goes in the reverse direction, it will 
always be set.

