From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] configure: Show support for connlabel
Date: Tue, 15 Mar 2016 01:36:01 +0100
Message-ID: <20160315003601.GA23295@salvia>
References: <20160312121804.GA27150@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58563 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbcCOAgI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 20:36:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 30378114F49
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:36:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1AB65DA8F8
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:36:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3DCE2DA8F8
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:36:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160312121804.GA27150@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 12, 2016 at 05:48:04PM +0530, Shivani Bhardwaj wrote:
> Add the --disable-connlabel option and the appropriate functionality
> associated with it.
> 
> After this patch, iptables configuration shows up as:
> 
> Iptables Configuration:
>   IPv4 support:                         yes
>   IPv6 support:                         yes
>   Devel support:                        yes
>   IPQ support:                          no
>   Large file support:                   yes
>   BPF utils support:                    no
>   nfsynproxy util support:              no
>   nftables support:                     yes
>   connlabel support:                    yes

I think we are almost there, see below.

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
> Changes in v3:
> 	Remove check for libnfnetlink from the if block
> 
> Changes in v2:
> 	Correct the option to disable-connlabel and add code to make it
> 	work
> 
>  configure.ac | 30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 33a8f2d..f9bc2a3 100644
> --- a/configure.ac
> +++ b/configure.ac
[...]
> @@ -168,6 +164,21 @@ if test "$nftables" != 1; then
>  	blacklist_a_modules="$blacklist_a_modules mangle"
>  fi
>  
> +if test "x$enable_connlabel" = "xyes"; then
> +	PKG_CHECK_MODULES([libnetfilter_conntrack],
> +		[libnetfilter_conntrack >= 1.0.4],
> +		[nfconntrack=1], [nfconntrack=0])
> +
> +	if test "$nfconntrack" -ne 1; then
> +		blacklist_modules="$blacklist_modules connlabel";
> +		echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";

Could you set enable_connlabel to "no" when this occurs so the banner
also displays that connlabel support has been skipped?

> +	fi;
> +else
> +	blacklist_modules="$blacklist_modules connlabel";
> +fi;
