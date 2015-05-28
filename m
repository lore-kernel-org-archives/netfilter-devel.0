From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 -next 2/2] netfilter: store rules per NUMA node
 instead of per cpu
Date: Thu, 28 May 2015 14:38:13 -0700
Message-ID: <1432849093.7456.32.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
	 <1432846296-26396-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33790 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbbE1ViP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 17:38:15 -0400
Received: by igbpi8 with SMTP id pi8so790967igb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 14:38:15 -0700 (PDT)
In-Reply-To: <1432846296-26396-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2015-05-28 at 22:51 +0200, Florian Westphal wrote:
> We store rule blob per (possible) cpu.  Unfortunately this means we can
> waste lot of memory on big smp machines. ipt_entry structure ('rule head')
> is 112 byte, so e.g. with maxcpu=64 one single rule eats close to 8k RAM.
> 
> Since previous patch moved counters to separate percpu blob, it appears
> there is nothing left in the rule blob that must be percpu.
> 
> Thus only duplicate the rule blob for each NUMA node.
> 
> On my test system (144 possible cpus, one numa node, 400k dummy rules) this
> change saves close to 9 Gigabyte of RAM.
> 
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Really if the program is now readonly, I would keep a single copy in
memory.

Are we copying kernel text to each NUMA node ? ;)



