From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Makefile typo for man page
Date: Thu, 09 Sep 2004 12:09:19 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41402BCF.4050808@trash.net>
References: <20040908220405.GA16532@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040908220405.GA16532@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
> Trivial typo prevents libip6t_targets.man from being included in build. 
> Reported by Olaf Rempel.
> 
> This fixes bugzilla #239

Applied, thanks.

> 
> Phil
> 
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> diff -ru ipt-orig/Makefile ipt-new/Makefile
> --- ipt-orig/Makefile	2004-06-17 07:21:07.000000000 -0400
> +++ ipt-new/Makefile	2004-09-08 17:58:29.008998392 -0400
> @@ -172,7 +172,7 @@
>  	sed -e '/@MATCH@/ r extensions/libipt_matches.man' -e '/@TARGET@/ r extensions/libipt_targets.man' iptables.8.in >iptables.8
>  
>  ip6tables.8: ip6tables.8.in extensions/libip6t_matches.man extensions/libip6t_targets.man
> -	sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r extensions/libiptt_targets.man' ip6tables.8.in >ip6tables.8
> +	sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r extensions/libip6t_targets.man' ip6tables.8.in >ip6tables.8
>  
>  # Development Targets
>  .PHONY: install-devel-man3
