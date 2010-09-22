From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: don't disable BH again in BH disabled context
Date: Wed, 22 Sep 2010 18:20:04 +0800
Message-ID: <AANLkTi=r23zwZpO=Y++a608=K6f7-FvcL2d-gY+foggm@mail.gmail.com>
References: <1282027297-9998-1-git-send-email-xiaosuo@gmail.com> <1282028127.2487.754.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52628 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0IVKUZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:20:25 -0400
In-Reply-To: <1282028127.2487.754.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 17, 2010 at 2:55 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Its a thing that might change in a future version. Not a hard fact.
>
> You can probably change iptables to allow softirqs while processing
> OUTPUT chains.
>
> We had some attempts in the past to switch to RCU.
>
> It failed at that time because of some RCU implementation details, but
> with recent RCU changes, we might try again, and have a clean
> implementation, allowing softirqs.
>
> So your patch would need to be reverted.
>

So the smp_processor_id() in xt_cpu.c should be replaced with
raw_smp_processor_id()?

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
