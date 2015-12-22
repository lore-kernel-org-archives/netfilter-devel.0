From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] extensions: libxt_mark: Add translation to nft
Date: Tue, 22 Dec 2015 17:19:48 +0100
Message-ID: <20151222161948.GA13092@salvia>
References: <20151220031412.GA8273@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57484 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbbLVQ0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:26:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 71E3A225928
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:26:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6558ADA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:26:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 54A64DA86F
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:26:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151220031412.GA8273@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 20, 2015 at 08:44:12AM +0530, Shivani Bhardwaj wrote:
> Add translation for metainformation mark to nftables.
>
> Examples:
> 
> $ sudo iptables-translate -I INPUT -m mark --mark 12
> nft insert rule ip filter INPUT mark  0xc counter
> 
> $ sudo iptables-translate -A FORWARD -m mark --mark 22 -j ACCEPT
> nft add rule ip filter FORWARD mark  0x16 counter accept
> 
> $ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 4600 -m mark --mark 0x40
> nft add rule ip mangle PREROUTING tcp dport 4600 mark  0x40 counter
> 
> $ sudo iptables-translate -A FORWARD -m mark --mark 0x400/0x400 -j ACCEPT
> nft add rule ip filter FORWARD mark  and 0x400 == 0x400 counter accept

Applied with minor glitch I have fixed here.

> +static void
> +print_mark_xlate(struct xt_buf *buf,
> +		 unsigned int mark, unsigned int mask)
> +{
> +	if (mask != 0xffffffffU)
> +		xt_buf_add(buf, " and 0x%x == 0x%x", mark, mask);
> +	else
> +		xt_buf_add(buf, " 0x%x", mark);
> +}
> +
> +static int
> +mark_mt_xlate(const struct xt_entry_match *match,
> +	      struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
> +
> +	xt_buf_add(buf, "mark %s", info->invert ? " !=" : "");

I have edited the line above to become:

	xt_buf_add(buf, "mark%s", info->invert ? " !=" : "");

So we get rid of the extra space:

> nft add rule ip filter FORWARD mark  and 0x400 == 0x400 counter accept
                                     ^
                                   here

> +	print_mark_xlate(buf, info->mark, info->mask);
> +	xt_buf_add(buf, " ");

Removed this xt_buf_add(buf, " ") and added the space to
print_mark_xlate().
