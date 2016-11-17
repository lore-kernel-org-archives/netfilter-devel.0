From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter question
Date: Wed, 16 Nov 2016 18:34:05 -0800
Message-ID: <1479350045.8455.236.camel@edumazet-glaptop3.roam.corp.google.com>
References: <cad49557-7c7a-83c9-d2b6-71d9624f0d52@miromedia.ca>
         <CANn89iLr-Zf2W5MW47QtKo17915UoryZentihKt1SMv7NP_dOw@mail.gmail.com>
         <20161116150200.GH30581@breakpoint.cc>
         <1479309789.8455.194.camel@edumazet-glaptop3.roam.corp.google.com>
         <20161117000725.GK30581@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <edumazet@google.com>,
        Eric Desrochers <ericd@miromedia.ca>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35417 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753531AbcKQCeI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 21:34:08 -0500
Received: by mail-pf0-f195.google.com with SMTP id i88so10743921pfk.2
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 18:34:07 -0800 (PST)
In-Reply-To: <20161117000725.GK30581@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2016-11-17 at 01:07 +0100, Florian Westphal wrote:

Seems very nice !

> +
> +void xt_percpu_counter_free(struct xt_counters *counters)
> +{
> +	unsigned long pcnt = counters->pcnt;
> +
> +	if (nr_cpu_ids > 1 && (pcnt & (PAGE_SIZE - 1)) == 0)
> +		free_percpu((void __percpu *) (unsigned long)pcnt);
> +}


pcnt is already an "unsigned long"

This packing might also speed up "iptables -nvL" dumps ;)


