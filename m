From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_hbh: Add translation to nft
Date: Wed, 2 Mar 2016 12:49:28 +0100
Message-ID: <20160302114928.GB3493@salvia>
References: <20160301215243.GA19576@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53572 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbcCBLtg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 06:49:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5DAF5ED063
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:49:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4D718DA385
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:49:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3A07CDA386
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:49:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301215243.GA19576@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 03:22:43AM +0530, Shivani Bhardwaj wrote:
> Add translation for module hop-by-hop to nftables.
> Full translation of this match awaits the support for --hbh-opts option.
> 
> Examples:
> 
> $ sudo ip6tables-translate -A INPUT -m hbh --hbh-len 33
> nft add rule ip6 filter INPUT hbh hdrlength 33 counter
> 
> $ sudo ip6tables-translate -A INPUT -m hbh ! --hbh-len 33
> nft add rule ip6 filter INPUT hbh hdrlength != 33 counter
>
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libip6t_hbh.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
> index c0389ed..f968036 100644
> --- a/extensions/libip6t_hbh.c
> +++ b/extensions/libip6t_hbh.c
> @@ -164,6 +164,22 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
>  	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
>  }
>  
> +static int hbh_xlate(const struct xt_entry_match *match,
> +		     struct xt_xlate *xl, int numeric)
> +{
> +	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
> +
> +	xt_xlate_add(xl, "hbh ");
> +
> +	if (optinfo->flags & IP6T_OPTS_LEN) {

If no header length is passed, then this will print:

nft add rule ip6 filter INPUT hbh counter

which will not work.
