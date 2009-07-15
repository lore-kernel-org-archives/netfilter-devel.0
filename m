From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TCPMSS target dropping SYN packets with data: suggested mod
Date: Wed, 15 Jul 2009 17:38:05 +0200
Message-ID: <4A5DF7DD.2050908@trash.net>
References: <873dce860907090641n31254e30g48886aefbbc6474e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Luca Pesce <pesce.luca@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57915 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZGOPiL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:38:11 -0400
In-Reply-To: <873dce860907090641n31254e30g48886aefbbc6474e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Pesce wrote:
> Hi all,
>    I have a question and a possible patch/mod for target TCPMSS (xt_TCPMSS.c).
> At the very beginning of function tcpmss_mangle_packet(), the skb containing the
> TCP SYN packet is checked to see if it is containing data (on a side note, SYN
> with data is quite unusual...); if so, the packet is drastically dropped.
> The reason is explained in RR's comment to the code, I am copy/pasting the
> beginning of this function with the length check at the bottom of this mail.
> RR says that we cannot change MSS on a packet which is already carrying data
> (it would be too late): could we relax this check, seeing if the tcp payload is
> less than the MSS we are about to set?

We probably could change that. I'm wondering though, did you actually
see this in real life? It doesn't seem like a very useful feature,
considering all the stacks supporting syn cookies.
