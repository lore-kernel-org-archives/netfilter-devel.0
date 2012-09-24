From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_time: add support to ignore day
 transition
Date: Mon, 24 Sep 2012 14:35:59 +0200
Message-ID: <20120924123559.GA30314@1984>
References: <1347877389-15728-1-git-send-email-fw@strlen.de>
 <1347877389-15728-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46059 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2IXMgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:36:07 -0400
Content-Disposition: inline
In-Reply-To: <1347877389-15728-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 17, 2012 at 12:23:09PM +0200, Florian Westphal wrote:
> Currently, if you want to do something like:
> "match Monday, starting 23:00, for two hours"
> You need two rules, one for Mon 23:00 to 0:00 and one for Tue 0:00-1:00.
> The rule
> --weekdays Mo --timestart 23:00  --timestop 01:00
> looks correct, but it will first match on monday from midnight to 1 a.m.
> and then again for another hour from 23:00 onwards.
> 
> This permits userspace to explicitly ignore the day transition and
> match for a single, continuous time period instead.

Applied with one minor glitch.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter/xt_time.h |    7 +++++++
>  net/netfilter/xt_time.c           |   24 +++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/netfilter/xt_time.h b/include/linux/netfilter/xt_time.h
> index 7c37fac..39cc3c4 100644
> --- a/include/linux/netfilter/xt_time.h
> +++ b/include/linux/netfilter/xt_time.h
> @@ -17,6 +17,9 @@ enum {
>  	/* Match against local time (instead of UTC) */
>  	XT_TIME_LOCAL_TZ = 1 << 0,
>  
> +	/* treat timestart > timestop (e.g. 23:00-01:00) as single period */
> +	XT_TIME_CONTIGUOUS = 1 << 1,
> +
>  	/* Shortcuts */
>  	XT_TIME_ALL_MONTHDAYS = 0xFFFFFFFE,
>  	XT_TIME_ALL_WEEKDAYS  = 0xFE,
> @@ -24,4 +27,8 @@ enum {
>  	XT_TIME_MAX_DAYTIME   = 24 * 60 * 60 - 1,
>  };
>  
> +#ifdef __KERNEL__
> +#define XT_TIME_ALL_FLAGS (XT_TIME_LOCAL_TZ|XT_TIME_CONTIGUOUS)
> +#endif

I've removed this conditional definition. IMO that ifdef is too much
for just hidding one mask from user-space. Moreover it uses two flags
that are exposed to user-space.

There's is still one rare case we may use it, which is adding one rule
with recent iptables using the contiguous thing and dumping the
rule-set with one old iptables binary. But that's really rare.

Well, this is just to avoid a bit the ifdef pollution we have all
around our code.
