From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libip6t_hbh: Add translation to nft
Date: Thu, 10 Mar 2016 19:47:15 +0100
Message-ID: <20160310184715.GA16857@salvia>
References: <20160307212141.GA10594@sonyv>
 <20160308105346.GB4008@salvia>
 <56DFCCED.8040909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: FaTe <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49367 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbcCJSrS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:47:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 68B7FC9EDB
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:47:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 57812DA383
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:47:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 26DB5DA383
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:47:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56DFCCED.8040909@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 09, 2016 at 12:42:45PM +0530, FaTe wrote:
> Added translation for hbh module .
> 
> Note: Currently, --hbh-opts support dont exist in nftables .
> 
> Example :
> $ ip6tables-translate -A INPUT -m hbh --hbh-len 40
> nft add rule ip6 filter INPUT hbh hdrlength  40 counter
> 
> $ sudo ip6tables-translate -A INPUT -m hbh ! --hbh-len 40
> nft add rule ip6 filter INPUT hbh hdrlength  != 40 counter
> 
> Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
> ---
>  extensions/libip6t_hbh.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
> index c0389ed..98dcade 100644
> --- a/extensions/libip6t_hbh.c
> +++ b/extensions/libip6t_hbh.c
> @@ -164,6 +164,27 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
>  	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
>  }
>  
> +static int hbh_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
> +		     int numeric)
> +{
> +	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
> +
> +	if (optinfo->flags & IP6T_OPTS_LEN) {
> +		xt_xlate_add(xl," hbh hdrlength %s %u",
> +			    (optinfo->invflags & IP6T_OPTS_INV_LEN) ? " !=" :
> +			    "", optinfo->hdrlen);

I suggested Shivani you check how to translate:

ip6tables -I INPUT -m hbh

which seems to be value too.

http://www.spinics.net/lists/netfilter-devel/msg41045.html

So we make sure we provide a right translation for that too.
