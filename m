From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] configure: exit if libnftnl is not found
Date: Fri, 8 Apr 2016 14:55:36 +0200
Message-ID: <20160408125536.GA8693@salvia>
References: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52692 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726AbcDHMzp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 08:55:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7FD7D4B0FE
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 14:55:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7048BDA8FB
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 14:55:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5D2E6DA38A
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 14:55:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 27, 2016 at 12:05:46PM +0200, Giuseppe Longo wrote:
> iptables building is broken if libnftnl is not installed
> on the system, raising up the following errors:
> 
> nft-shared.c:25:27: fatal error: libnftnl/rule.h: No such file or directory
>  #include <libnftnl/rule.h>
>                            ^
> compilation terminated.
> nft.c:41:28: fatal error: libnftnl/table.h: No such file or directory
>  #include <libnftnl/table.h>
>                             ^
> compilation terminated.
> mv -f .deps/xtables_multi-iptables-restore.Tpo .deps/xtables_multi-iptables-restore.Po
> In file included from nft.h:5:0,
>                  from nft-ipv6.c:25:
> nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
>  #include <libnftnl/rule.h>
>                            ^
> mv -f .deps/xtables_multi-xshared.Tpo .deps/xtables_multi-xshared.Po
> compilation terminated.
> In file included from nft.h:5:0,
>                  from nft-ipv4.c:26:
> nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
>  #include <libnftnl/rule.h>
> 
> configure script checks if libnftnl is installed, but doesn't
> exit if it is not.
> 
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  configure.ac | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/configure.ac b/configure.ac
> index 33a8f2d..b08ecca 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -128,6 +128,13 @@ if test "x$enable_nftables" = "xyes"; then
>  
>  	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5], [nftables=1], [nftables=0])
>  
> +	if test "$nftables" = 0;
> +	then
> +		echo "*** Error: No suitable libnftnl found. ***"
> +		echo "    Please install the 'libnftnl' package."

I'm going to take this patch, but mangle it to include this information too:

		echo "    Or consider --disable-nftables to skip "
                echo "    iptables-compat over nftables support."

