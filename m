From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: RE: [PATCH 3/3] netfilter: x_tables: fix ordering of jumpstack
 allocation and table update
Date: Wed, 23 Oct 2013 05:13:33 -0700
Message-ID: <1382530413.7572.8.camel@edumazet-glaptop.roam.corp.google.com>
References: <1382519724-3953-1-git-send-email-pablo@netfilter.org>
	 <1382519724-3953-4-git-send-email-pablo@netfilter.org>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73A2@saturn3.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40412 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3JWMNh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:13:37 -0400
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B73A2@saturn3.aculab.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2013-10-23 at 10:45 +0100, David Laight wrote:

> Those writes were in the wrong order on all systems.
> Also gcc needs to be told not to reorder the writes even on non-smp
> systems (if the code might be pre-empted).
> So an asm volatile (:::"memory") is needed there even if no specific
> synchronisation instruction is needed.

smp_wmb() contains this compiler barrier already.



