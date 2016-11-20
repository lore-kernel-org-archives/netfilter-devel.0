From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter question
Date: Sat, 19 Nov 2016 22:33:03 -0800
Message-ID: <1479623583.8455.358.camel@edumazet-glaptop3.roam.corp.google.com>
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
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33568 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbcKTGdF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Nov 2016 01:33:05 -0500
Received: by mail-pf0-f193.google.com with SMTP id 144so16156050pfv.0
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Nov 2016 22:33:05 -0800 (PST)
In-Reply-To: <20161117000725.GK30581@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2016-11-17 at 01:07 +0100, Florian Westphal wrote:

> +	if (state->mem == NULL) {
> +		state->mem = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
> +		if (!state->mem)
> +			return false;
> +	}

This will fail on arches where PAGE_SIZE=65536

percpu allocator limit is PCPU_MIN_UNIT_SIZE  ( 32 KB )

So maybe use a smaller value like 4096 ?

#define XT_PCPU_BLOC_SIZE 4096


