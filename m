From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: PROBLEM: Netfilter time matching matches all packets when time
 start and time stop is the same
Date: Thu, 1 Aug 2013 13:24:44 +0200
Message-ID: <20130801112444.GE21352@unicorn.suse.cz>
References: <CAK+MRYuFUCvkker9sq7LFa42t=vQ7FhWwzz37Mtw3sLMZTJ+EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Henry Lee <henryronlee@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3HALYq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:24:46 -0400
Content-Disposition: inline
In-Reply-To: <CAK+MRYuFUCvkker9sq7LFa42t=vQ7FhWwzz37Mtw3sLMZTJ+EQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 31, 2013 at 04:42:15PM +0800, Henry Lee wrote:
> diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
> index 0ae55a3..753573c 100644
> --- a/net/netfilter/xt_time.c
> +++ b/net/netfilter/xt_time.c
> @@ -192,7 +192,7 @@ time_mt(const struct sk_buff *skb, struct
> xt_action_param *par)
> 
>      packet_time = localtime_1(&current_time, stamp);
> 
> -   if (info->daytime_start < info->daytime_stop) {
> +   if (info->daytime_start <= info->daytime_stop) {
>          if (packet_time < info->daytime_start ||
>              packet_time > info->daytime_stop)
>              return false;
> 

As far as I can see, this would cause only packets arriving at midnight
to match by default (i.e. without both --timestart and --timestop).

                                                         Michal Kubecek

