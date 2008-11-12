From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 1/2 v2] New netfilter target to trigger LED devices
Date: Wed, 12 Nov 2008 21:10:43 +1000
Message-ID: <491AB9B3.5060207@shikadi.net>
References: <49196D12.1030803@shikadi.net> <alpine.LNX.1.10.0811111318020.19024@fbirervta.pbzchgretzou.qr> <491AB0C5.9030305@shikadi.net> <alpine.LNX.1.10.0811121157200.17100@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4805 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYKLLKp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:10:45 -0500
In-Reply-To: <alpine.LNX.1.10.0811121157200.17100@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Ah bummer, I forgot about that.  Is this the best order?
> 
> No, that will break offsetof() in .userspacesize, as it will
> become 0.

Oh, double bummer, I forgot about that also.

> add id - 27 bytes.
> add always_blink - 28 bytes.
> 28? That's good for alignment of a u32. Add delay.
> 32? That's good for alignment of a potentially-ptr64.

Ah okay, that works out quite well then.

> And it's solved, even without thinking of NULs or prefixes.

Sorry, I thought you meant "please explain where the 26 comes from"

> Just use [27] - the struct will be hardcoded forever,
> and putting #defines somewhere gives a wrong illusion it might be changeable.

Will do.

Cheers,
Adam.

