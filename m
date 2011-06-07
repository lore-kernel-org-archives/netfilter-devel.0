From: David Miller <davem@davemloft.net>
Subject: Re: [RFC] SLOB breaks netfilter
Date: Tue, 07 Jun 2011 14:18:10 -0700 (PDT)
Message-ID: <20110607.141810.2159514423065256050.davem@davemloft.net>
References: <20110607210651.GA11159@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	tglx@linutronix.de
To: sebastian@breakpoint.cc
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:36211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab1FGVVe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:21:34 -0400
In-Reply-To: <20110607210651.GA11159@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Date: Tue, 7 Jun 2011 23:06:51 +0200

> and SLOB defines:
> 
> |#ifdef ARCH_DMA_MINALIGN
> |#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
> |#else
> |#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
> |#endif

SLOB should really use "unsigned long long" I think.

An allocator needs to provide memory with the maximum
alignment that might be required for types on a given
architecture.
