Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F39CC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E105561AA3
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhKQPj2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 10:39:28 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40326 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbhKQPj0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 10:39:26 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8B84F605C0;
        Wed, 17 Nov 2021 16:34:21 +0100 (CET)
Date:   Wed, 17 Nov 2021 16:36:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] monitor: do not call interval_map_decompose() for
 concat intervals
Message-ID: <YZUhd0BVSaLVnIIe@salvia>
References: <20211117142531.21203-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211117142531.21203-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 17, 2021 at 03:25:31PM +0100, Florian Westphal wrote:
> Without this, nft monitor will either print garbage or even segfault
> when encountering a concat set because we pass expr->value to libgmp
> helpers for concat (non-value) expressions.
> 
> Also, for concat case, we need to call concat_range_aggregate() helper.
> Add a test case for this.  Without this patch, it gives:
> 
> tests/monitor/run-tests.sh: line 98: 1163 Segmentation fault
> (core dumped) $nft -nn -e -f $command_file > $echo_output

LGTM.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/monitor.c                          | 7 ++++++-
>  tests/monitor/testcases/set-interval.t | 5 +++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/src/monitor.c b/src/monitor.c
> index 8ecb7d199505..7fa92ebfb0f3 100644
> --- a/src/monitor.c
> +++ b/src/monitor.c
> @@ -533,8 +533,13 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
>  
>  static void rule_map_decompose_cb(struct set *s, void *data)
>  {
> -	if (set_is_interval(s->flags) && set_is_anonymous(s->flags))
> +	if (!set_is_anonymous(s->flags))
> +		return;
> +
> +	if (set_is_non_concat_range(s))
>  		interval_map_decompose(s->init);
> +	else if (set_is_interval(s->flags))
> +		concat_range_aggregate(s->init);
>  }
>  
>  static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
> diff --git a/tests/monitor/testcases/set-interval.t b/tests/monitor/testcases/set-interval.t
> index 1fbcfe222a2b..b0649cdfe01e 100644
> --- a/tests/monitor/testcases/set-interval.t
> +++ b/tests/monitor/testcases/set-interval.t
> @@ -23,3 +23,8 @@ J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "ex
>  I add rule ip t c tcp dport { 20, 30-40 }
>  O -
>  J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": {"set": [20, {"range": [30, 40]}]}}}]}}}
> +
> +# ... and anon concat range
> +I add rule ip t c ether saddr . ip saddr { 08:00:27:40:f7:09 . 192.168.56.10-192.168.56.12 }
> +O -
> +{"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"concat": [{"payload": {"protocol": "ether", "field": "saddr"}}, {"payload": {"protocol": "ip", "field": "saddr"}}]}, "right": {"set": [{"concat": ["08:00:27:40:f7:09", {"range": ["192.168.56.10", "192.168.56.12"]}]}]}}}]}}}
> -- 
> 2.32.0
> 
