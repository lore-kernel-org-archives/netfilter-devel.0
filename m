From: "bdschuym@pandora.be" <bdschuym@telenet.be>
Subject: Re: ebtables
Date: Thu, 07 Aug 2008 10:36:44 +0000
Message-ID: <W44746677271881218105404@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>, bdschuym@pandora.be
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:44724 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbYHGMdI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:33:08 -0400
Received: from hoboi3bl4.telenet-ops.be (unknown [195.130.137.79])
	by yergi.telenet-ops.be (Postfix) with ESMTP id EA2BF5C89F7
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2008 12:37:40 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>----- Oorspronkelijk bericht -----
>Van: Jan Engelhardt [mailto:jengelh@medozas.de]
>Verzonden: woensdag, augustus 6, 2008 10:44 PM
>Aan: bdschuym@pandora.be
>CC: 'Netfilter Developer Mailing List'
>Onderwerp: ebtables "|&" mixup
>
>Hi,
>
>
>I have just spotted
>
>        if (BASE_CHAIN && (natinfo->target | ~EBT_VERDICT_BITS) == 
>EBT_RETURN) 
>
>in ebtables's ebt_nat.c (there may be other places), I think this should 
>be & ~EBT_VERDICT_BITS instead, should not it?

Hi Jan,

Bits from the 'target' member can be used for other purposes, since the number of targets is limited. The checks you mention were added when support for writing the ip address to an arp header were added (keeping full backwards compatibility). They are correct.

See http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d12cdc3ccf140bd2febef1c1be92284571da983f

cheers,
Bart



