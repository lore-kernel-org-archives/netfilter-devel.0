From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: fix IPv6 NTP checksum calculation
Date: Thu, 24 Jan 2013 23:49:24 +0100
Message-ID: <20130124224924.GH8541@breakpoint.cc>
References: <06023CFA-4D28-43B3-8C7F-B8223F3390DD@dilly.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jean-Michel DILLY <jm@dilly.me>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38893 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982Ab3AXWt0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:49:26 -0500
Content-Disposition: inline
In-Reply-To: <06023CFA-4D28-43B3-8C7F-B8223F3390DD@dilly.me>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jean-Michel DILLY <jm@dilly.me> wrote:
> Hi all,
> This patch doesn't work as expected. I tried with few IP and each time 0x0100 were missing. csum_add seems buggy too.
> I have reimplemented csum16s functions with the Ulrich's fix. It seems to work now.
> I'm a noob, so I guess someone will propose a better patch for this.

We can't use csum_add after all, patch looks correct.

Can you re-send with proper Signoff?

[ carry detection breaks on overflow, e.g. a==1 and b=0xffff yields
  0 for csum_add (65536 < 1) and 1 for csum16_add (0 < 1) ]
