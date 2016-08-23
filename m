From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2 2/2] xtables-translate-restore: do not escape
 quotes
Date: Tue, 23 Aug 2016 14:07:50 +0200
Message-ID: <20160823120750.GA27760@salvia>
References: <20160822105615.32483-1-pablombg@gmail.com>
 <20160822105615.32483-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41288 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753295AbcHWMJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 08:09:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3FBE0B6C7E
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:07:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 303B1CE14C
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:07:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 189DC114D76
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:07:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160822105615.32483-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 12:56:15PM +0200, Pablo M. Bermudo Garay wrote:
> If quotes are escaped, nft -f is unable to parse and load the translated
> ruleset.
> 
> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
> 
> Changes in v2:
>   - Do not use strcmp against 'program_name' global, propagate 'bool restore'
>     argument instead.
> 
>  iptables/nft-ipv4.c          |  6 +++---
>  iptables/nft-ipv6.c          |  7 ++++---
>  iptables/nft-shared.h        |  2 +-
>  iptables/nft.h               |  5 +++--
>  iptables/xtables-translate.c | 28 ++++++++++++++++++----------
>  5 files changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
> index 295dd42..362036c 100644
> --- a/iptables/nft-ipv4.c
> +++ b/iptables/nft-ipv4.c
> @@ -438,7 +438,7 @@ static void nft_ipv4_save_counters(const void *data)
>  	save_counters(cs->counters.pcnt, cs->counters.bcnt);
>  }
>  
> -static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
> +static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl, bool restore)

You better place this 'restore' as a field in iptables_command_state?

This would require a bit of changes in iptables and ip6tables, but
that sounds reasonable to me.
