From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: xtables: avoid percpu ruleset
 duplication
Date: Wed, 10 Jun 2015 22:32:53 -0700
Message-ID: <1434000773.27504.31.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1433979295-7747-1-git-send-email-fw@strlen.de>
	 <1433979295-7747-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34671 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbFKFcz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2015 01:32:55 -0400
Received: by igdh15 with SMTP id h15so8917457igd.1
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 22:32:55 -0700 (PDT)
In-Reply-To: <1433979295-7747-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2015-06-11 at 01:34 +0200, Florian Westphal wrote:
> We store the rule blob per (possible) cpu.  Unfortunately this means we can
> waste lot of memory on big smp machines. ipt_entry structure ('rule head')
> is 112 byte, so e.g. with maxcpu=64 one single rule eats
> close to 8k RAM.
> 
> Since previous patch made counters percpu it appears there is nothing
> left in the rule blob that needs to be percpu.
> 
> On my test system (144 possible cpus, 400k dummy rules) this
> change saves close to 9 Gigabyte of RAM.
> 
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Very happy to see this happening, thanks Florian.

Acked-by: Eric Dumazet <edumazet@google.com>


