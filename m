From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Mon, 18 Jul 2011 13:19:43 -0700 (PDT)
Message-ID: <20110718.131943.1892150276130348431.davem@davemloft.net>
References: <87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	<20110718.124638.30010338187296272.davem@davemloft.net>
	<87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: adobriyan@gmail.com, kaber@trash.net,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: rweikusat@mobileactivedefense.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:49274 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GRUUw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:20:52 -0400
In-Reply-To: <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Date: Mon, 18 Jul 2011 21:17:00 +0100

> David Miller <davem@davemloft.net> writes:
>> We're also specifically talking about namespace stuff, so you should have
>> at least refined your match criteria just a little bit.
> 
> The person I was replying to wrote 'We did whole networking without
> sprinkling ifdefs'.

He was talking specifically about namespace stuff.
