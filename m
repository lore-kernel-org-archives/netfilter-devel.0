From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_rpfilter: add translation to
 nft
Date: Mon, 16 Jan 2017 14:14:55 +0100
Message-ID: <20170116131455.GA19709@salvia>
References: <1483799206-59857-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbdAPNPF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 08:15:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4FF9303D03
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:15:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B55E9961DA
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:15:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F6A5961E5
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:15:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1483799206-59857-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 07, 2017 at 10:26:46PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> For example:
>   # iptables-translate -t mangle -A PREROUTING -m rpfilter
>   nft add rule ip mangle PREROUTING fib saddr . iif oif != 0 counter
> 
>   # iptables-translate -t mangle -A PREROUTING -m rpfilter --validmark \
>   --loose
>   nft add rule ip mangle PREROUTING fib saddr . mark oif != 0 counter
> 
>   # ip6tables-translate -t mangle -A PREROUTING -m rpfilter --validmark \
>   --invert
>   nft add rule ip6 mangle PREROUTING fib saddr . mark . iif oif 0 counter
> 
> Finally, when the "--accept-local" option is specified, we can combine
> with "fib saddr type" to simulate it.
> 
> But when it is used like this: "-m rpfilter --accept-local", it means "||"
> relationship, so we cannot translate it to one single nft rule,
> translation is not supported yet:
>   # iptables-translate -t mangle -A PREROUTING -m rpfilter --accept-local
>   nft # -t mangle -A PREROUTING -m rpfilter --accept-local
> 
> When "--accpet-local" is combined with "--invert", it means "&&"
> relationship, so translation can be:
>   # iptables-translate -t mangle -A PREROUTING -m rpfilter \
>   --accept-local --invert
>   nft add rule ip mangle PREROUTING fib saddr type != local fib saddr \
>   . iif oif 0 counter

Also applied, thanks.
