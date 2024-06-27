Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86556145A1F;
	Thu, 27 Jun 2024 11:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487739; cv=none; b=iryPlPsShP2PTvZ848nBV301pfIvBx4xqk+3BG092YgZcMmae4OnFIkz3nGBAYQ5HRuvTJPOdpYrIX68P7yudEroTirquiSVvzPTyO6ICLF89h7bv1bh/wtuhUzxchyhGYtX6B3mqu4F2fTACCLlRjM+1htYQfQicI3bWVvcCis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487739; c=relaxed/simple;
	bh=DxxuywpAijUqea/EY+mDV8FLeBQMkZhzKz6bn8siyzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2yZHxwpl9oKgGI/IVwNAxRRlWvqr9zglwcX0bNxhCqhOFFmEDI5g4v1WxNfTwkUPhtk9hRdgcSmp+YlMucwJXj6ndnr14d+W6TYAC6V/rQ59t68HSCtHMS8cQHSRuGZRvPPE4lDBWOoAGdKlgwi9Sf8o4JwdTgr8JjBnA2ZYPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34044 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMnJ6-009Zhj-R4; Thu, 27 Jun 2024 13:28:54 +0200
Date: Thu, 27 Jun 2024 13:28:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH nf-next 00/19] Netfilter/IPVS updates for net-next
Message-ID: <Zn1M890ZdC1WRekQ@calendula>
References: <20240627112713.4846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

Note for netdev maintainer: This PR is actually targeted at *net-next*.

Please, let me know if you prefer I resubmit.

On Thu, Jun 27, 2024 at 01:26:54PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter/IPVS updates for net-next:
> 
> Patch #1 to #11 to shrink memory consumption for transaction objects:
> 
>   struct nft_trans_chain { /* size: 120 (-32), cachelines: 2, members: 10 */
>   struct nft_trans_elem { /* size: 72 (-40), cachelines: 2, members: 4 */
>   struct nft_trans_flowtable { /* size: 80 (-48), cachelines: 2, members: 5 */
>   struct nft_trans_obj { /* size: 72 (-40), cachelines: 2, members: 4 */
>   struct nft_trans_rule { /* size: 80 (-32), cachelines: 2, members: 6 */
>   struct nft_trans_set { /* size: 96 (-24), cachelines: 2, members: 8 */
>   struct nft_trans_table { /* size: 56 (-40), cachelines: 1, members: 2 */
> 
>   struct nft_trans_elem can now be allocated from kmalloc-96 instead of
>   kmalloc-128 slab.
> 
>   Series from Florian Westphal. For the record, I have mangled patch #1
>   to add nft_trans_container_*() and use if for every transaction object.
>    I have also added BUILD_BUG_ON to ensure struct nft_trans always comes
>   at the beginning of the container transaction object. And few minor
>   cleanups, any new bugs are of my own.
> 
> Patch #12 simplify check for SCTP GSO in IPVS, from Ismael Luceno.
> 
> Patch #13 nf_conncount key length remains in the u32 bound, from Yunjian Wang.
> 
> Patch #14 removes unnecessary check for CTA_TIMEOUT_L3PROTO when setting
> 	  default conntrack timeouts via nfnetlink_cttimeout API, from
> 	  Lin Ma.
> 
> Patch #15 updates NFT_SECMARK_CTX_MAXLEN to 4096, SELinux could use
> 	  larger secctx names than the existing 256 bytes length.
> 
> Patch #16 fixes nfnetlink_queue with SCTP traffic, from Antonio Ojea.
> 
> Patch #17 adds a selftest for SCTP traffic under nfnetlink_queue,
> 	  also from Antonio.
> 
> Patch #18 adds a selftest to exercise nfnetlink_queue listeners leaving
> 	  nfnetlink_queue, from Florian Westphal.
> 
> Patch #19 increases hitcount from 255 to 65535 in xt_recent, from Phil Sutter.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-06-27
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit c4532232fa2a4f8d9b9a88135a666545157f3d13:
> 
>   selftests: net: remove unneeded IP_GRE config (2024-06-25 08:37:55 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-06-27
> 
> for you to fetch changes up to 8871d1e4dceb6692ea8217b1fc835c4bf2e93d97:
> 
>   netfilter: xt_recent: Lift restrictions on max hitcount value (2024-06-27 01:55:57 +0200)
> 
> ----------------------------------------------------------------
> netfilter pull request 24-06-27
> 
> ----------------------------------------------------------------
> Antonio Ojea (2):
>       netfilter: nfnetlink_queue: unbreak SCTP traffic
>       selftests: netfilter: nft_queue.sh: sctp coverage
> 
> Florian Westphal (12):
>       netfilter: nf_tables: make struct nft_trans first member of derived subtypes
>       netfilter: nf_tables: move bind list_head into relevant subtypes
>       netfilter: nf_tables: compact chain+ft transaction objects
>       netfilter: nf_tables: reduce trans->ctx.table references
>       netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
>       netfilter: nf_tables: pass more specific nft_trans_chain where possible
>       netfilter: nf_tables: avoid usage of embedded nft_ctx
>       netfilter: nf_tables: store chain pointer in rule transaction
>       netfilter: nf_tables: reduce trans->ctx.chain references
>       netfilter: nf_tables: pass nft_table to destroy function
>       netfilter: nf_tables: do not store nft_ctx in transaction objects
>       selftests: netfilter: nft_queue.sh: add test for disappearing listener
> 
> Ismael Luceno (1):
>       ipvs: Avoid unnecessary calls to skb_is_gso_sctp
> 
> Lin Ma (1):
>       netfilter: cttimeout: remove 'l3num' attr check
> 
> Pablo Neira Ayuso (1):
>       netfilter: nf_tables: rise cap on SELinux secmark context
> 
> Phil Sutter (1):
>       netfilter: xt_recent: Lift restrictions on max hitcount value
> 
> Yunjian Wang (1):
>       netfilter: nf_conncount: fix wrong variable type
> 
>  include/net/netfilter/nf_tables.h                  | 222 +++++++----
>  include/uapi/linux/netfilter/nf_tables.h           |   2 +-
>  net/core/dev.c                                     |   1 +
>  net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
>  net/netfilter/nf_conncount.c                       |   8 +-
>  net/netfilter/nf_tables_api.c                      | 411 ++++++++++++---------
>  net/netfilter/nf_tables_offload.c                  |  40 +-
>  net/netfilter/nfnetlink_cttimeout.c                |   3 +-
>  net/netfilter/nfnetlink_queue.c                    |  12 +-
>  net/netfilter/nft_immediate.c                      |   2 +-
>  net/netfilter/xt_recent.c                          |   8 +-
>  tools/testing/selftests/net/netfilter/nft_queue.sh | 113 ++++++
>  12 files changed, 546 insertions(+), 280 deletions(-)
> 
