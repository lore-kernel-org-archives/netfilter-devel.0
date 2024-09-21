Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55808F9DF
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Sep 2024 09:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726909847; cv=none; b=p/e9+TKGoaMQetZgcAa3bpRT1K08xoRi42gLCPg0c8jdrQa3aNdIX9Y3GNJ8ahJ6hQA26aBKToUw/8/wnRxyN1qBzJ1wUGivHT7terQoAtrP6F55rJPwaQE/mCzvsbb8n4gyxYcXbMKXYCbQGSyt5ooOt5QZ06fNVua1w09L+qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726909847; c=relaxed/simple;
	bh=64SpuqOKq+4y8tQdYaWg4y0DwhRwkwtNhz0nzUwLdgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4Ua+lFw3PPFLZx+IMrMnvpJPc+Q60zEa1Fb5J2LmIKk7tWD2UABgzQCQHNvYm28Yqx4YEY/1DE70eH+yDImWm/x59q/6NgrDfLTaLiw8pxYP8O2tmbL3hj9QWr3GEAAmtjrNA3SOUMEwDSnmGotZeG8N8Xu3Cx+YhABmglSl1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1srw8Q-0001w4-Kn; Sat, 21 Sep 2024 11:10:34 +0200
Date: Sat, 21 Sep 2024 11:10:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v4 15/16] netfilter: nf_tables: Add notications
 for hook changes
Message-ID: <20240921091034.GA5023@breakpoint.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
 <20240920202347.28616-16-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240920202347.28616-16-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Notify user space if netdev hooks are updated due to netdev add/remove
> events. Send minimal notification messages by introducing
> NFT_MSG_NEWDEV/DELDEV message types describing a single device only.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/net/netfilter/nf_tables.h        |  2 +
>  include/uapi/linux/netfilter/nf_tables.h |  5 +++
>  net/netfilter/nf_tables_api.c            | 56 ++++++++++++++++++++++++
>  net/netfilter/nft_chain_filter.c         |  1 +
>  4 files changed, 64 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index eaf2f5184bdf..f8da38e45277 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1132,6 +1132,8 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
>  int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
>  int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
>  void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
> +void nf_tables_chain_device_notify(const struct nft_chain *chain,
> +				   const struct net_device *dev, int event);
>  
>  enum nft_chain_types {
>  	NFT_CHAIN_T_DEFAULT = 0,
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index d6476ca5d7a6..3a874febf1ac 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -142,6 +142,8 @@ enum nf_tables_msg_types {
>  	NFT_MSG_DESTROYOBJ,
>  	NFT_MSG_DESTROYFLOWTABLE,
>  	NFT_MSG_GETSETELEM_RESET,
> +	NFT_MSG_NEWDEV,
> +	NFT_MSG_DELDEV,

This relies on implicit NFNL_CB_UNSPEC == 0 and nfnetlink
bailing out whe NFT_MSG_NEWDEV appears in a netlink message
coming from userspace.

Is there precedence for this?
If not, maybe better to add explicit entries to the
nf_tables_cb[] array?

AFAICS its fine as-is, nfnetlink won't blindly invoke
NULL ->call() pointer, but I'm not sure this was designed
to be this way or if this is a coincidence.
