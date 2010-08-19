From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
Date: Thu, 19 Aug 2010 11:59:42 +0800
Message-ID: <AANLkTinqQ9wXK9Ed3VYTWj_trYJiU+=uTV-FnCxqFvNU@mail.gmail.com>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
 <1282033817.2448.18.camel@edumazet-laptop> <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
 <1282035715.2448.24.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58238 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0HSEAE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Aug 2010 00:00:04 -0400
In-Reply-To: <1282035715.2448.24.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 17, 2010 at 5:01 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> I am not sure we must use a long (we really need 4 bytes only), and last
> time I tried to use cmpxchg(), I was being told it was not available on
> all arches.
>
> But seeing it used in kernel/pid.c, maybe its not true anymore (that is,
> __HAVE_ARCH_CMPXCHG is always defined to 1)
>
> Since its a recent change (in kernel/pid.c), I would wait a bit and see
> if an arch maintainer complains ;)
>
>

I searched the code, and found ext4, btrfs, lockdep, perf and trace
all use cmpxchg(). And after this patch serial
(http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-08/msg05032.html)
was merged, maybe cmpxchg() is generic. Is there an SMP processor
doesn't support cmpxchg()?

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
