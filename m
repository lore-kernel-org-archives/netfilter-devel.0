From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 libnftnl] utils: Fix out of bound access in
 nftnl_family2str
Date: Mon, 15 Aug 2016 13:03:39 +0200
Message-ID: <20160815110339.GA8028@salvia>
References: <20160815103256.GB5883@salvia>
 <20160815105103.22319-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37938 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbcHOLDt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 07:03:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D8055A4170
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 13:03:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C8F74DA7FE
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 13:03:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AD794DA7FC
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 13:03:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160815105103.22319-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 15, 2016 at 12:51:02PM +0200, Carlos Falgueras García wrote:
> Checks array limits before access it and adds a missed translation.
> 
> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  src/utils.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/utils.c b/src/utils.c
> index e2715a2..7264d1f 100644
> --- a/src/utils.c
> +++ b/src/utils.c
> @@ -23,6 +23,7 @@
>  #include <linux/netfilter/nf_tables.h>
>  
>  static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
> +	[NFPROTO_UNSPEC]	= "unknown",

You don't need this line above, right? I can mangle the patch here
before applying it.

>  	[NFPROTO_INET]		= "inet",
>  	[NFPROTO_IPV4]		= "ip",
>  	[NFPROTO_ARP]		= "arp",
> @@ -33,7 +34,7 @@ static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
>  
>  const char *nftnl_family2str(uint32_t family)
>  {
> -	if (nftnl_family_str[family] == NULL)
> +	if (family >= NFPROTO_NUMPROTO || !nftnl_family_str[family])
>  		return "unknown";
>  
>  	return nftnl_family_str[family];
> -- 
> 2.8.3
> 
