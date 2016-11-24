From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Update nf_send_reset6 to consider L3 domain
Date: Thu, 24 Nov 2016 12:46:29 +0100
Message-ID: <20161124114629.GB11284@salvia>
References: <1478715905-19005-1-git-send-email-dsa@cumulusnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org
To: David Ahern <dsa@cumulusnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44588 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965060AbcKXLqj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 06:46:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 42F7E1B3611
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:46:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FBA0DA849
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:46:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18CFADA814
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:46:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478715905-19005-1-git-send-email-dsa@cumulusnetworks.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 09, 2016 at 10:25:05AM -0800, David Ahern wrote:
> nf_send_reset6 is not considering the L3 domain and lookups are sent
> to the wrong table. For example consider the following output rule:
> 
> ip6tables -A OUTPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset
> 
> using perf to analyze lookups via the fib6_table_lookup tracepoint shows:
> 
> swapper     0 [001]   248.787816: fib6:fib6_table_lookup: table 255 oif 0 iif 1 src 2100:1::3 dst 2100:1:
>         ffffffff81439cdc perf_trace_fib6_table_lookup ([kernel.kallsyms])
>         ffffffff814c1ce3 trace_fib6_table_lookup ([kernel.kallsyms])
>         ffffffff814c3e89 ip6_pol_route ([kernel.kallsyms])
>         ffffffff814c40d5 ip6_pol_route_output ([kernel.kallsyms])
>         ffffffff814e7b6f fib6_rule_action ([kernel.kallsyms])
>         ffffffff81437f60 fib_rules_lookup ([kernel.kallsyms])
>         ffffffff814e7c79 fib6_rule_lookup ([kernel.kallsyms])
>         ffffffff814c2541 ip6_route_output_flags ([kernel.kallsyms])
>                      528 nf_send_reset6 ([nf_reject_ipv6])
> 
> The lookup is directed to table 255 rather than the table associated with
> the device via the L3 domain. Update nf_send_reset6 to pull the L3 domain
> from the dst currently attached to the skb.

Also applied, thanks.
