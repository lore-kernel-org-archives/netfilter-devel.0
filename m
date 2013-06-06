From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 3/4] Add JSON Constant for to use the Json
 export function
Date: Thu, 6 Jun 2013 18:25:58 +0200
Message-ID: <20130606162558.GA30602@localhost>
References: <20130606131706.18048.11297.stgit@Ph0enix>
 <20130606131725.18048.26908.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, julien@linuxwall.info
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43563 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3FFQ0F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:26:05 -0400
Content-Disposition: inline
In-Reply-To: <20130606131725.18048.26908.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alvaro,

On Thu, Jun 06, 2013 at 03:17:25PM +0200, Alvaro Neira wrote:
> 
> ---
>  0 files changed
> 
> diff --git a/include/libnftables/table.h b/include/libnftables/table.h
> index 658230c..19f322c 100644
> --- a/include/libnftables/table.h
> +++ b/include/libnftables/table.h
> @@ -31,6 +31,7 @@ void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table
>  enum {
>  	NFT_TABLE_O_DEFAULT	= 0,
>  	NFT_TABLE_O_XML,
> +	NFT_TABLE_O_JSON,

you have to collapse patch 1/4, 3/4 and 4/4. You cannot add the
definition of this constant in a follow-up patch. Note that the
repository has to remain consistent between patches, and after patch
1/4, if I compile libnftables, it would break.

Please, fix it and resubmit. Thanks.
