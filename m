From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_esp: Add translation to nft
Date: Tue, 22 Dec 2015 17:29:37 +0100
Message-ID: <20151222162937.GA15518@salvia>
References: <20151220181321.GA15015@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58400 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbbLVQ3l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:29:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 452DB225926
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:29:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 37680DA808
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:29:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 47044DA808
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:29:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151220181321.GA15015@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 20, 2015 at 11:43:21PM +0530, Shivani Bhardwaj wrote:
> Add translation for ESP Protocol to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A FORWARD -p esp -j ACCEPT
> nft add rule ip filter FORWARD ip protocol esp counter accept
> 
> $ sudo iptables-translate -A INPUT  --in-interface  wan --protocol esp -j ACCEPT
> nft add rule ip filter INPUT iifname wan ip protocol esp counter accept
> 
> $ sudo iptables-translate -A INPUT -p 50 -m esp --espspi 500 -j DROP
> nft add rule ip filter INPUT  esp spi 500 counter drop

Applied with changes.

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_esp.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
> index 294338b..1c198c6 100644
> --- a/extensions/libxt_esp.c
> +++ b/extensions/libxt_esp.c
> @@ -79,10 +79,28 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
>  
>  }
>  
> +static int esp_xlate(const struct xt_entry_match *match,
> +		     struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
> +
> +	if (!(espinfo->spis[0] == 0 && espinfo->spis[1] == 0xFFFFFFFF)) {
> +		xt_buf_add(buf, "%s esp spi ",

This should be "esp spi%s" instead.

> +			   (espinfo->invflags & XT_ESP_INV_SPI) ? " !=" : "");
> +		if (espinfo->spis[0] != espinfo->spis[1])
> +			xt_buf_add(buf, "%u:%u ", espinfo->spis[0],

This should be "%u-%u".

Please, make sure you test all possible branches in your code next
time.

Thanks.
