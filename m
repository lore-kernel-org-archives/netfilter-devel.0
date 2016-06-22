From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH iptables] configure: Fix logic to show connlabel support
Date: Wed, 22 Jun 2016 18:30:26 +0200
Message-ID: <20160622163026.GC10213@breakpoint.cc>
References: <1466604637-26536-1-git-send-email-shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34080 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbcFVQah (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 12:30:37 -0400
Content-Disposition: inline
In-Reply-To: <1466604637-26536-1-git-send-email-shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> With the earlier logic, when libnfnetlink and libnetfilter_conntrack
> were not installed, all the warnings showed up correctly but the final
> configuration showed:
> 
>             connlabel support:                      yes
> 
> which was faulty.
> This was happening because connlabel module was blacklisted first and
> then set to "no" if package requirements were not met.

its because ...

> diff --git a/configure.ac b/configure.ac
> index c91e9e7..131bc8b 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -173,9 +173,9 @@ if test "x$enable_connlabel" = "xyes"; then
>  		[nfconntrack=1], [nfconntrack=0])
>  
>  	if test "$nfconntrack" -ne 1; then
> +		enable_connlabel="no";
>  		blacklist_modules="$blacklist_modules connlabel";
>  		echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
> -		enable_connlabel = "no";

... of the space around the '=', shell tried to execute
'enable_connlabel' command here.
