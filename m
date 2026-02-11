Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CF834F486
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770845822; cv=none; b=jWaIKR5kPFI6BsPW5lpHTIqAJkYIP9QZef12xpncXU4AuZ6OzyklOreleHaDhag4mZTkRs3YAR3hr6aSLJJPShNx0VXjkA5D+0OFL7mfWqtqvjBfXHXVLIHks0r1ZP1mfIIkStrLeTYpsMITtkyqY4itYlco6JGwjDsOEnA0znc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770845822; c=relaxed/simple;
	bh=c43Wk8Wym99w21vO0FG2sfXQcj/wfuX6ruzyN8vyYGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QP4eTidkoNM/gfklknIiwoC8eSF3vWK9gVXrZ8vEY/xkaM5k7JPLMELuBeHn1G6zLvGwLg9J6HVgh3QoaCu31bmhuljdWOAfskZMRKPXt6Clf4NnbV+ss5qToZpsjDAvc6tSt3xhCYrym1Hfld4cbw3c5PcLcthY/fl2L2Yh2eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h6QsOYlu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h6QsOYlu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E0JOd+Khb44Tdthy+vM4b1W2ffq64k1bU7gMvoSLEmc=; b=h6QsOYlulRO5U59plLL/zrZbAR
	E1kPotuOZFSbxFTq0jhwpTP1dDSMg+GgRhZ7Q4XiRkGRAFIMRD1XkY7GA9ne3HrwT6OOv5Z1B1KCs
	GuKd0aqGrtKzqDZSfNL0Qmmz+VFJw0Mr2sNixZ/yqRjpH8nDjhwqdD3vgy/uRF5VQJyl7pFL5VcGC
	G1RswoKup2wZaB+AQuqb/6ICf79xzVlSAQMF9TJ8ykb3+JERhUrHKM3yAV6/MG5RrwHAcpJnYoy60
	RPFOkXAfxChyQebbamqFDgl6MdjcMTrsn+UVpc9s/0x7q7tfZ54rkFTorr13sLXhcX926+qCvttlV
	SAQ0a/fg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqHtJ-000000001BQ-2uqr;
	Wed, 11 Feb 2026 22:36:57 +0100
Date: Wed, 11 Feb 2026 22:36:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH] iptables: fix null dereference parsing bitwise operations
Message-ID: <aYz2eUev4mUdN7uX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
References: <20260202101408.745532-1-one-d-wide@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202101408.745532-1-one-d-wide@protonmail.com>

Hi Remy,

On Mon, Feb 02, 2026 at 10:14:52AM +0000, Remy D. Farley wrote:
> Iptables binary only understands NFT_BITWISE_MASK_XOR bitwise operation and
> assumes its attributes are always present without actually checking, which
> leads to a segfault in some cases.
> 
> This commit introduces this missing check.
> 
> | /**
> |  * enum nft_bitwise_ops - nf_tables bitwise operations
> |  *
> |  * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, AND, OR
> |  *                        and XOR boolean operations
> |  * @NFT_BITWISE_LSHIFT: left-shift operation          \
> |  * @NFT_BITWISE_RSHIFT: right-shift operation         |
> |  * @NFT_BITWISE_AND: and operation                    | These all are affected
> |  * @NFT_BITWISE_OR: or operation                      |
> |  * @NFT_BITWISE_XOR: xor operation                    /
> |  */
> 
> From iptables/nft-ruleparse.c:
> 
> | static void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
> | {
> |   [...]
> |
> |   data = nftnl_expr_get(e, NFTNL_EXPR_BITWISE_XOR, &len); // <-- this attribute may not be present
> |
> |   if (len > sizeof(dreg->bitwise.xor)) {
> |     ctx->errmsg = "bitwise xor too large";
> |     return;
> |   }
> |
> |   memcpy(dreg->bitwise.xor, data, len); // <-- zero dereference happens here
> |
> |   data = nftnl_expr_get(e, NFTNL_EXPR_BITWISE_MASK, &len);
> |
> |   if (len > sizeof(dreg->bitwise.mask)) {
> |   	ctx->errmsg = "bitwise mask too large";
> |   	return;
> |   }
> |
> |   memcpy(dreg->bitwise.mask, data, len);
> |
> |   dreg->bitwise.set = true;
> |
> | }
> 
> The bug can be reproduced by creating a rule like this:
> 
> | # newrule.json
> | {"chain": "example-chain",
> |  "expressions": {"elem": [{"data": {"base": 1,
> |                                     "dreg": 1,
> |                                     "len": 4,
> |                                     "offset": 12},
> |                            "name": "payload"},
> |                           {"data": {"data": {"value": [255, 255, 255, 0]},
> |                                     "dreg": 1,
> |                                     "len": 4,
> |                                     "op": 3,
> |                                     "sreg": 1},
> |                            "name": "bitwise"},
> |                           {"data": {"data": {"value": [1, 2, 3, 0]},
> |                                     "op": 0,
> |                                     "sreg": 1},
> |                            "name": "cmp"},
> |                           {"data": {"data": {"verdict": {"code": 1}},
> |                                     "dreg": 0},
> |                            "name": "immediate"}]},
> |  "nfgen-family": 2,
> |  "table": "filter"}
> 
> | # newrule.sh
> | set -euo pipefail
> |
> | iptables -N example-chain || true
> |
> | genid="$(
> |   ./tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/nftables.yaml \
> |     --do getgen --json "{}" --output-json |
> |     jq -r ".id"
> | )"
> |
> | ./tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/nftables.yaml \
> |   --multi batch-begin "{\"genid\": $genid, \"res-id\": 10}" \
> |   --creat --append --multi newrule "$(cat ./newrule.json)" \
> |   --creat --multi batch-end '{}' \
> |   --output-json
> 
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
> ---
>  iptables/nft-ruleparse.c | 5 +++++
>  iptables/nft.c           | 5 ++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
> index cdf1af4f..1a9084e3 100644
> --- a/iptables/nft-ruleparse.c
> +++ b/iptables/nft-ruleparse.c
> @@ -232,6 +232,11 @@ static void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
>  	const void *data;
>  	uint32_t len;
>  
> +	if (nftnl_expr_get_u32(e, NFTNL_EXPR_BITWISE_OP) != 0 /* empty or MASK_XOR */) {
> +		ctx->errmsg = "unsupported bitwise operation";
> +		return;
> +	}
> +

This is redundant wrt. the stricter compatibility check below, right? Or
did you find a call to nft_rule_to_iptables_command_state() which is not
guarded by nft_is_table_compatible()?

Anyway, I would add two checks to that function like so:

| if (!data) {
| 	ctx->errmsg = "missing bitwise xor attribute";
| 	return;
| }

(And the same for bitwise mask.) It will sanitize the function's code
irrespective of expression content, readers won't have to be aware of
(and rely upon) bitwise expression semantics with NFTNL_EXPR_BITWISE_OP
attribute value being zero.

>  	if (!sreg)
>  		return;
>  
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 85080a6d..661fac29 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -4029,7 +4029,6 @@ static const char *supported_exprs[] = {
>  	"payload",
>  	"meta",
>  	"cmp",
> -	"bitwise",
>  	"counter",
>  	"immediate",
>  	"lookup",
> @@ -4056,6 +4055,10 @@ static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
>  	    nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_GROUP))
>  		return 0;
>  
> +	if (!strcmp(name, "bitwise") &&
> +	    nftnl_expr_get_u32(expr, NFTNL_EXPR_BITWISE_OP) == 0 /* empty or MASK_XOR */)

'== NFT_BITWISE_MASK_XOR' and drop the comment.

Thanks, Phil
