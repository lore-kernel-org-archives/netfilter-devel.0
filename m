From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Sun, 24 Oct 2010 14:49:17 -0700
Message-ID: <AANLkTi=t9x9viXUFM-wp_rEU5giAjZ-yqhcR3eTUz76V@mail.gmail.com>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
	<20101024182508.GM15247@Chamillionaire.breakpoint.cc>
	<1287947511.2658.1678.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>, Changli Gao <xiaosuo@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35993 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985Ab0JXVuB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:50:01 -0400
Received: by wyf28 with SMTP id 28so2707499wyf.19
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Oct 2010 14:50:00 -0700 (PDT)
In-Reply-To: <1287947511.2658.1678.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Absolutely not. total is a 32bit number, using full range.

Strictly speaking I think you mean 'hash' here, which as a hash
should indeed be a random value across a full 32-bit range.
Total might very well be pretty small.

Anyway, without having tested, the change looks fine to me.
