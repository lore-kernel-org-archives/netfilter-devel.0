From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Make Ebtables use Xtables infrastructure
Date: Tue, 09 Sep 2008 08:21:19 +0200
Message-ID: <48C615DF.4090009@trash.net>
References: <alpine.LNX.1.10.0809061209150.14936@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Bart De Schuymer <bdschuym@pandora.be>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62931 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYIIGVW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:21:22 -0400
In-Reply-To: <alpine.LNX.1.10.0809061209150.14936@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit bf161deb157ce95ac28b534a86fc1b18fe4d9aa4
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sun Aug 10 22:16:14 2008 -0400
> 
> [NETFILTER]: Make Ebtables use Xtables infrastructure
 > ...
 > 22 files changed, 620 insertions(+), 593 deletions(-)

Nice work, thanks. The patch is really huge though and I would
prefer a slightly more gradual conversion, like first adjust
the return conventions (and only those), than convert to x_tables.

> +MODULE_AUTHOR("Manohar Castelino <manohar.r.castelino@intel.com>");
> +MODULE_AUTHOR("Kuo-Lang Tseng <kuo-lang.tseng@intel.com>");
> +MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");

Please avoid these unrelated changes, especially in big patches
like this that are supposed to contain only mechanical transformations.

> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index aece6c2..f03ced4 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -30,7 +30,7 @@
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
> -MODULE_DESCRIPTION("[ip,ip6,arp]_tables backend module");
> +MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
>  
>  #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
>  
> @@ -325,7 +325,8 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
>  		   unsigned int size, const char *table, unsigned int hook_mask,
>  		   unsigned short proto, int inv_proto)
>  {
> -	if (XT_ALIGN(match->matchsize) != size) {
> +	/* testing for -1 is temporary until ebtables is fixed up */
> +	if (match->matchsize != -1 && XT_ALIGN(match->matchsize) != size) {

What exactly is the problem here (and when will ebtables be fixed up)?
