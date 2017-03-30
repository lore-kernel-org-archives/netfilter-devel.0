From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: extensions: Remove assignment in if condition.
Date: Thu, 30 Mar 2017 11:02:39 +0200
Message-ID: <20170330090239.GD18679@breakpoint.cc>
References: <20170329233459.GA22682@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39412 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932685AbdC3JDX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 05:03:23 -0400
Content-Disposition: inline
In-Reply-To: <20170329233459.GA22682@arushi-HP-Pavilion-Notebook>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arushi Singhal <arushisinghal19971997@gmail.com> wrote:
> Remove assignments in if condition as reported by checkpatch.pl.
> 
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> ---
>  extensions/libebt_ip.c          | 11 ++++++-----
>  extensions/libip6t_ipv6header.c |  5 +++--
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
> index 4ca63e9..deae6f4 100644
> --- a/extensions/libebt_ip.c
> +++ b/extensions/libebt_ip.c
> @@ -68,9 +68,9 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
>  {
>  	char *buffer;
>  	char *cp;
> -
> +	cp = strchr(buffer, ':');

This is broken.
