Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A93C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 May 2022 15:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiESPtp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 May 2022 11:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241749AbiESPtT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 May 2022 11:49:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E16A55379
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2022 08:46:24 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nriM1-0007rD-Ew; Thu, 19 May 2022 17:46:21 +0200
Date:   Thu, 19 May 2022 17:46:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Nick Hainke <vincent@systemli.org>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [iptables PATCH] Revert "fix build for missing ETH_ALEN
 definition"
Message-ID: <YoZmTRRCGOVhVQA0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Nick Hainke <vincent@systemli.org>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
References: <20220518142046.21881-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518142046.21881-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Nick, Maciej, does this patch work for you?

On Wed, May 18, 2022 at 04:20:46PM +0200, Phil Sutter wrote:
> This reverts commit c5d9a723b5159a28f547b577711787295a14fd84 as it broke
> compiling against musl libc. Might be a bug in the latter, but for the
> time being try to please both by avoiding the include and instead
> defining ETH_ALEN if unset.
> 
> While being at it, move netinet/ether.h include up.
> 
> Fixes: 1bdb5535f561a ("libxtables: Extend MAC address printing/parsing support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  libxtables/xtables.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index 96fd783a066cf..0638f9271c601 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -28,6 +28,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <netinet/ether.h>
>  #include <sys/socket.h>
>  #include <sys/stat.h>
>  #include <sys/statfs.h>
> @@ -45,7 +46,6 @@
>  
>  #include <xtables.h>
>  #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
> -#include <linux/if_ether.h> /* ETH_ALEN */
>  #include <linux/netfilter_ipv4/ip_tables.h>
>  #include <linux/netfilter_ipv6/ip6_tables.h>
>  #include <libiptc/libxtc.h>
> @@ -72,6 +72,10 @@
>  #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
>  #endif
>  
> +#ifndef ETH_ALEN
> +#define ETH_ALEN 6
> +#endif
> +
>  /* we need this for ip6?tables-restore.  ip6?tables-restore.c sets line to the
>   * current line of the input file, in order  to give a more precise error
>   * message.  ip6?tables itself doesn't need this, so it is initialized to the
> @@ -2245,8 +2249,6 @@ void xtables_print_num(uint64_t number, unsigned int format)
>  	printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
>  }
>  
> -#include <netinet/ether.h>
> -
>  static const unsigned char mac_type_unicast[ETH_ALEN] =   {};
>  static const unsigned char msk_type_unicast[ETH_ALEN] =   {1};
>  static const unsigned char mac_type_multicast[ETH_ALEN] = {1};
> -- 
> 2.34.1
> 
> 
