From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_NFLOG: Add translation to nft
Date: Tue, 22 Dec 2015 17:43:58 +0100
Message-ID: <20151222164358.GA18134@salvia>
References: <20151221173559.GA8787@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60931 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbbLVQoD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:44:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 12E8B23CF60
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:44:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04861DA863
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:44:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A7A3ADA843
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:43:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151221173559.GA8787@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 21, 2015 at 11:05:59PM +0530, Shivani Bhardwaj wrote:
> Add translation for NF Logging to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A OUTPUT -j NFLOG --nflog-group 30
> nft add rule ip filter OUTPUT counter log group 30
> 
> $ sudo iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix "Prefix 1.0"
> nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" log group 32
> 
> $ sudo iptables-translate -I INPUT -j NFLOG --nflog-range 256
> nft insert rule ip filter INPUT counter log snaplen 256
> 
> $ sudo iptables-translate -I INPUT -j NFLOG --nflog-threshold 25
> nft insert rule ip filter INPUT counter log queue-threshold 25

Applied with changes.

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_NFLOG.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
> index 448576a..3d05ce0 100644
> --- a/extensions/libxt_NFLOG.c
> +++ b/extensions/libxt_NFLOG.c
> @@ -72,7 +72,7 @@ static void nflog_print(const struct xt_nflog_info *info, char *prefix)
>  }
>  
>  static void NFLOG_print(const void *ip, const struct xt_entry_target *target,
> -                        int numeric)
> +			int numeric)
>  {
>  	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
>  
> @@ -86,6 +86,31 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
>  	nflog_print(info, "--");
>  }
>  
> +static void nflog_print_xlate(const struct xt_nflog_info *info,
> +			      char *prefix, struct xt_buf *buf)
> +{
> +	if (info->prefix[0] != '\0')
> +		xt_buf_add(buf, "%slog prefix \\\"%s\\\" ",
> +			   prefix, info->prefix);
> +	if (info->group)
> +		xt_buf_add(buf, "%slog group %u ", prefix, info->group);
> +	if (info->len)
> +		xt_buf_add(buf, "%slog snaplen %u ", prefix, info->len);
> +	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
> +		xt_buf_add(buf, "%slog queue-threshold %u ",
> +			   prefix, info->threshold);
> +}
> +
> +static int NFLOG_xlate(const struct xt_entry_target *target,
> +		       struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
> +
> +	nflog_print_xlate(info, "", buf);
                                ^^

This is always "", so we can get rid of this extra parameter.

I have fixed this here, no need to send v2.

Thanks.
