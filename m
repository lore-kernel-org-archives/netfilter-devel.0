Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1454C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F5661078
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 11:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbhHELPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 07:15:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58676 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240777AbhHELPC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 07:15:02 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id DDDC260043;
        Thu,  5 Aug 2021 13:14:09 +0200 (CEST)
Date:   Thu, 5 Aug 2021 13:14:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH v2 nf] netfilter: conntrack: remove offload_pickup sysctl
 again
Message-ID: <20210805111440.GA6246@salvia>
References: <20210804130215.3625-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210804130215.3625-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 04, 2021 at 03:02:15PM +0200, Florian Westphal wrote:
> These two sysctls were added because the hardcoded defaults (2 minutes,
> tcp, 30 seconds, udp) turned out to be too low for some setups.
> 
> They appeared in 5.14-rc1 so it should be fine to remove it again.
> 
> Marcelo convinced me that there should be no difference between a flow
> that was offloaded vs. a flow that was not wrt. timeout handling.
> Thus the default is changed to those for TCP established and UDP stream,
> 5 days and 120 seconds, respectively.
> 
> Marcelo also suggested to account for the timeout value used for the
> offloading, this avoids increase beyond the value in the conntrack-sysctl
> and will also instantly expire the conntrack entry with altered sysctls.
> 
> Example:
>    nf_conntrack_udp_timeout_stream=60
>    nf_flowtable_udp_timeout=60
> 
> This will remove offloaded udp flows after one minute, rather than two.
> 
> An earlier version of this patch also cleared the ASSURED bit to
> allow nf_conntrack to evict the entry via early_drop (i.e., table full).
> However, it looks like we can safely assume that connection timed out
> via HW is still in established state, so this isn't needed.
> 
> Quoting Oz:
>  [..] the hardware sends all packets with a set FIN flags to sw.
>  [..] Connections that are aged in hardware are expected to be in the
>  established state.
> 
> In case it turns out that back-to-sw-path transition can occur for
> 'dodgy' connections too (e.g., one side disappeared while software-path
> would have been in RETRANS timeout), we can adjust this later.

Applied, thanks.
