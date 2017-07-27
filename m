From: Florian Westphal <fw@strlen.de>
Subject: Re: libnetfilter_queue & "dropping packets"
Date: Thu, 27 Jul 2017 12:23:27 +0200
Message-ID: <20170727102327.GD28392@breakpoint.cc>
References: <20170727085704.GA4681@legohost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oleg <lego12239@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35524 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbdG0KZR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 06:25:17 -0400
Content-Disposition: inline
In-Reply-To: <20170727085704.GA4681@legohost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oleg <lego12239@yandex.ru> wrote:
>   Hi, all.
> 
> What is happen with packets which are dropped by nfqueue with the next
> message:
> 
>  nf_queue: full at 1024 entries, dropping packets(s)
> 
> Are this packets disappeared from netfilter/network_stack(the same
> behaviour like DROP target somewhere in the iptables rules)?

Yes.
