From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 nf-next 1/2] netfilter: xtables: use percpu rule
 counters
Date: Wed, 10 Jun 2015 22:32:08 -0700
Message-ID: <1434000728.27504.30.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1433979295-7747-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:33205 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbFKFcK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2015 01:32:10 -0400
Received: by igdj8 with SMTP id j8so8928155igd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 22:32:10 -0700 (PDT)
In-Reply-To: <1433979295-7747-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2015-06-11 at 01:34 +0200, Florian Westphal wrote:
> The binary arp/ip/ip6tables ruleset is stored per cpu.
> 
> The only reason left as to why we need percpu duplication are the rule
> counters embedded into ipt_entry et al -- since each cpu has its own copy
> of the rules, all counters can be lockless.
> 
> The downside is that the more cpus are supported, the more memory is
> required.  Rules are not just duplicated per online cpu but for each
> possible cpu, i.e. if maxcpu is 144, then rule is duplicated 144 times,
> not for the e.g. 64 cores present.
> 
> To save some memory and also improve utilization of shared caches it
> would be preferable to only store the rule blob once.
> 
> So we first need to separate counters and the rule blob.
> 
> Instead of using entry->counters, allocate this percpu and store the
> percpu address in entry->counters.pcnt on CONFIG_SMP.
> 
> This change makes no sense as-is; it is merely an intermediate step to
> remove the percpu duplication of the rule set in a followup patch.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !


