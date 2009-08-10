From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 017/103] netfilter: xtables: use better unconditional
 check
Date: Mon, 10 Aug 2009 11:27:44 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908101117010.23752@fbirervta.pbzchgretzou.qr>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-18-git-send-email-jengelh@medozas.de> <4A7FE031.3090506@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57523 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZHJJ1o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:27:44 -0400
In-Reply-To: <4A7FE031.3090506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-08-10 10:54, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> The use of memcmp should enable architecture-preferred comparison
>> methods, for example 64-bit comparisons that would complete in [more
>> than] half the time than inspecting just each u32/char.
>
>I don't object to the change as cleanup, but that reasoning makes
>no sense. memcmp can't assume alignment,

Right, memcmp itself cannot, and there is usually a prealignment check
in libcs that clears a few bytes and advances the pointer until it is
aligned.

>so unless there's a
>version checking for compile-time known alignment, this won't happen.

	static void func(int r)
	{
		static int q = 1234;
		memcmp(&q, &r, sizeof(q));
	}

There is GCC's __builtin_memcmp, which should generally have
knowledge about alignment. q and r are known here.

>Please fix up the changelog and label this as cleanup.

Will do.
