From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nf 02/17] netfilter: x_tables: validate targets of
 jumps
Date: Fri, 1 Apr 2016 14:24:06 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1604011421300.30219@nerf40.vanv.qr>
References: <1459513057-30652-1-git-send-email-fw@strlen.de> <1459513057-30652-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:34986 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbcDAMYI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:24:08 -0400
In-Reply-To: <1459513057-30652-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2016-04-01 14:17, Florian Westphal wrote:

>The extra overhead is negible, even with absurd cases.
>
>300k custom rules, 300k jumps to 'next' user chain:
>[ plus one jump from INPUT to first userchain ]:
>
>sys     0m16.076s
>sys     0m18.840s

I wouldn't call a 17% increase negligible. But, correctness before speed, I'm
onboard even with a 200% jump.

