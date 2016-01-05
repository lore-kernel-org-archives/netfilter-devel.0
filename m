From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libipt_ttl: Add translation to nft
Date: Tue, 5 Jan 2016 12:17:45 +0100
Message-ID: <20160105111745.GA6613@salvia>
References: <20160104180002.GA10529@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38340 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbcAELRt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:17:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A50BE1324D6
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:17:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 95E64DA804
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:17:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAC23DA804
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:17:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160104180002.GA10529@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 11:30:02PM +0530, Shivani Bhardwaj wrote:
> Add translation for module ttl to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m ttl --ttl-eq 3 -j ACCEPT
> nft add rule ip filter INPUT ip ttl 3 counter accept
> 
> $ sudo iptables-translate -A INPUT -m ttl --ttl-gt 5 -j ACCEPT
> nft add rule ip filter INPUT ip ttl \> 5 counter accept

Applied with minor glitch.

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
> Changes in v2:
> 	Remove the changes done in nft-ipv4
> 
>  extensions/libipt_ttl.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
> index 5fe08cc..5d897a7 100644
> --- a/extensions/libipt_ttl.c
> +++ b/extensions/libipt_ttl.c
> @@ -100,6 +100,35 @@ static void ttl_save(const void *ip, const struct xt_entry_match *match)
>  	printf(" %u", info->ttl);
>  }
>  
> +static int ttl_xlate(const struct xt_entry_match *match,
> +		     struct xt_buf *buf, int numeric)
> +{
> +	const struct ipt_ttl_info *info =
> +			(struct ipt_ttl_info *) match->data;
> +
> +		switch (info->mode) {
> +		case IPT_TTL_EQ:
> +			xt_buf_add(buf, "ip ttl");
> +			break;
> +		case IPT_TTL_NE:
> +			xt_buf_add(buf, "ip ttl !=");
> +			break;
> +		case IPT_TTL_LT:
> +			xt_buf_add(buf, "ip ttl \\<");

I prefer you use 'lt' instead of \\<.

> +			break;
> +		case IPT_TTL_GT:
> +			xt_buf_add(buf, "ip ttl \\>");

Same thing here: use 'gt'.

No need to resend, I have fixed this here.

Thanks.
