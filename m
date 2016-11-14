From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Update ip_route_me_harder to consider L3
 domain
Date: Mon, 14 Nov 2016 23:59:20 +0100
Message-ID: <20161114225920.GA9221@salvia>
References: <1478715880-18952-1-git-send-email-dsa@cumulusnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org
To: David Ahern <dsa@cumulusnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60188 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752754AbcKNW7Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 17:59:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37713209431
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:59:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2792FDA24C
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:59:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23289DA87C
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:59:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478715880-18952-1-git-send-email-dsa@cumulusnetworks.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 09, 2016 at 10:24:40AM -0800, David Ahern wrote:
> ip_route_me_harder is not considering the L3 domain and sending lookups
> to the wrong table. For example consider the following output rule:
>
> iptables -I OUTPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset
> 
> using perf to analyze lookups via the fib_table_lookup tracepoint shows:
> 
> vrf-test  1187 [001] 46887.295927: fib:fib_table_lookup: table 255 oif 0 iif 0 src 0.0.0.0 dst 10.100.1.254 tos 0 scope 0 flags 0
>         ffffffff8143922c perf_trace_fib_table_lookup ([kernel.kallsyms])
>         ffffffff81493aac fib_table_lookup ([kernel.kallsyms])
>         ffffffff8148dda3 __inet_dev_addr_type ([kernel.kallsyms])
>         ffffffff8148ddf6 inet_addr_type ([kernel.kallsyms])
>         ffffffff8149e344 ip_route_me_harder ([kernel.kallsyms])
> 
> and
> 
> vrf-test  1187 [001] 46887.295933: fib:fib_table_lookup: table 255 oif 0 iif 1 src 10.100.1.254 dst 10.100.1.2 tos 0 scope 0 flags
>         ffffffff8143922c perf_trace_fib_table_lookup ([kernel.kallsyms])
>         ffffffff81493aac fib_table_lookup ([kernel.kallsyms])
>         ffffffff814998ff fib4_rule_action ([kernel.kallsyms])
>         ffffffff81437f35 fib_rules_lookup ([kernel.kallsyms])
>         ffffffff81499758 __fib_lookup ([kernel.kallsyms])
>         ffffffff8144f010 fib_lookup.constprop.34 ([kernel.kallsyms])
>         ffffffff8144f759 __ip_route_output_key_hash ([kernel.kallsyms])
>         ffffffff8144fc6a ip_route_output_flow ([kernel.kallsyms])
>         ffffffff8149e39b ip_route_me_harder ([kernel.kallsyms])
> 
> In both cases the lookups are directed to table 255 rather than the
> table associated with the device via the L3 domain. Update both
> lookups to pull the L3 domain from the dst currently attached to the
> skb.

Does ip6_route_me_harder need an update too?
