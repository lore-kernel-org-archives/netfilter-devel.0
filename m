From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 18:05:23 +0100
Message-ID: <20140106170523.GA9894@breakpoint.cc>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51395 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbaAFRFY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:05:24 -0500
Content-Disposition: inline
In-Reply-To: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kristian Evensen <kristian.evensen@gmail.com> wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> This patch enables connmark to be set/retrieved using meta
> expressions/statements.
> 
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_meta.c                 | 34 ++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index aa86a152..05eaeb9 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -531,6 +531,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_NFTRACE: packet nftrace bit
>   * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
>   * @NFT_META_SECMARK: packet secmark (skb->secmark)
> + * @NFT_META_CONNMARK: used to get/set the connection mark
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -548,6 +549,7 @@ enum nft_meta_keys {
>  	NFT_META_NFTRACE,
>  	NFT_META_RTCLASSID,
>  	NFT_META_SECMARK,
> +	NFT_META_CONNMARK,
>  };

This looks wrong, meta is for packet properties.
You should probably use NFT_CT_MARK from nft_ct_keys enum.
