Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34068C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1808E60F5A
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhKHK0K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:26:10 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46738 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhKHK0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 05:26:10 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9DBC16063C;
        Mon,  8 Nov 2021 11:21:27 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:23:22 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: update ct timeout section with the state names
Message-ID: <YYj6mnS+kS+PHgsV@salvia>
References: <20211028153724.9192-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211028153724.9192-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 28, 2021 at 05:37:24PM +0200, Florian Westphal wrote:
> docs are too terse and did not have the list of valid timeout states.
> While at it, adjust default stream timeout of udp to 120, this is the
> current kernel default.

ack.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  doc/stateful-objects.txt | 11 +++++++++++
>  src/rule.c               |  2 +-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/doc/stateful-objects.txt b/doc/stateful-objects.txt
> index 4972969eb250..e3c79220811f 100644
> --- a/doc/stateful-objects.txt
> +++ b/doc/stateful-objects.txt
> @@ -77,6 +77,17 @@ per ct timeout comment field |
>  string
>  |=================
>  
> +tcp connection state names that can have a specific timeout value are:
> +
> +'close', 'close_wait', 'established', 'fin_wait', 'last_ack', 'retrans', 'syn_recv', 'syn_sent', 'time_wait' and 'unack'.
> +
> +You can use 'sysctl -a |grep net.netfilter.nf_conntrack_tcp_timeout_' to view and change the system-wide defaults.
> +'ct timeout' allows for flow-specific settings, without changing the global timeouts.
> +
> +For example, tcp port 53 could have much lower settings than other traffic.
> +
> +udp state names that can have a specific timeout value are 'replied' and 'unreplied'.
> +
>  .defining and assigning ct timeout policy
>  ----------------------------------
>  table ip filter {
> diff --git a/src/rule.c b/src/rule.c
> index c7bc6bcf3496..b1700c40079d 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -72,7 +72,7 @@ static uint32_t tcp_dflt_timeout[] = {
>  
>  static uint32_t udp_dflt_timeout[] = {
>  	[NFTNL_CTTIMEOUT_UDP_UNREPLIED]		= 30,
> -	[NFTNL_CTTIMEOUT_UDP_REPLIED]		= 180,
> +	[NFTNL_CTTIMEOUT_UDP_REPLIED]		= 120,
>  };
>  
>  struct timeout_protocol timeout_protocol[IPPROTO_MAX] = {
> -- 
> 2.32.0
> 
