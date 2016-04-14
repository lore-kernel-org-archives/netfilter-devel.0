From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 nf-next 4/4] netfilter: nftables: add connlabel set
 support
Date: Thu, 14 Apr 2016 11:57:03 +0200
Message-ID: <20160414094835.GA2119@salvia>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
 <1460477666-17823-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33479 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbcDNJ5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 05:57:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 97A45E839D
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 11:57:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8A1CE9D0ED
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 11:57:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 763F39D0E8
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 11:57:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460477666-17823-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 12, 2016 at 06:14:26PM +0200, Florian Westphal wrote:
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 25998fa..4ec1cea 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -29,6 +29,11 @@ struct nft_ct {
>  		enum nft_registers	dreg:8;
>  		enum nft_registers	sreg:8;
>  	};
> +	union {
> +		u8		set_bit;
> +	} imm;
> +	unsigned int		imm_len:8;
> +	struct nft_data		immediate;

Could you use select_ops() so we don't increase the size of nft_ct for
other users?
