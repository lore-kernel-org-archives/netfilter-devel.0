From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] fix wrong headername in ipv6header for protocols
Date: Mon, 20 Jul 2015 09:21:26 +0200
Message-ID: <20150720072126.GA4136@salvia>
References: <1437054859-15824-1-git-send-email-andi@geekosphere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40984 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbbGTHPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 03:15:43 -0400
Content-Disposition: inline
In-Reply-To: <1437054859-15824-1-git-send-email-andi@geekosphere.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 16, 2015 at 03:54:19PM +0200, Andreas Herz wrote:
> In the --help output and manpage for ipv6header the name for upper layer
> protocol headers was "proto", while in the code itself it's "prot" for
> the short form. Fixed by changing manpage and help output.
> 
> Signed-off-by: Andreas Herz <andi@geekosphere.org>
> ---
>  extensions/libip6t_ipv6header.c   | 2 +-
>  extensions/libip6t_ipv6header.man | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
> index 00d5d5b..6f03087 100644
> --- a/extensions/libip6t_ipv6header.c
> +++ b/extensions/libip6t_ipv6header.c
> @@ -127,7 +127,7 @@ static void ipv6header_help(void)
>  	printf(
>  "ipv6header match options:\n"
>  "[!] --header headers     Type of header to match, by name\n"
> -"                         names: hop,dst,route,frag,auth,esp,none,proto\n"
> +"                         names: hop,dst,route,frag,auth,esp,none,prot\n"
>  "                    long names: hop-by-hop,ipv6-opts,ipv6-route,\n"
>  "                                ipv6-frag,ah,esp,ipv6-nonxt,protocol\n"
>  "                       numbers: 0,60,43,44,51,50,59\n"

I can read this from the code:

static const struct pprot chain_protos[] = {
        { "protocol", IPPROTO_RAW },
...
        { "prot", IPPROTO_RAW },

Could you clarify what you're seeing there? Thanks.
