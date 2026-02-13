Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94381B85F8
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2026 13:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770988010; cv=none; b=RSdXgkuVRUa3TiKkx+C256wekYfQ0Q97Nx751OxrRsR75V7q1dbqPCknJjQhRWb4xIoy+YZsS8PObE9GOxcD4s+KH71W7ZDcUflVtKD/GqOxMwBhWdKXj502sIlVaK6LYpfe4owbxVzpFYNbEkjJhhAnzuoQCyLPRL3cadz8Zyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770988010; c=relaxed/simple;
	bh=3UFd1vRjlNZfL3ZvC5poXO23A3s9gNUSupPjJ9WnUy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfr3tRyFqoPPT+zwIlCFFuV8IXFxwUnTJQvi/Vwto/SrtkgTSoqlutwsnbm1fI1OGvXneQ63WV5MVBEyuwm4o8KD0aXFJC1pjcys4+/1vzdPdyL16faQ1x4phMzBs3m5T94geIP3b4iwsagVcLxfhyv7QSBjeewPr67QFCsPufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eXV4iFP1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eXV4iFP1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H8+MHR49fnZwePxwId5hHtaDjBSiuv+3KmA1ZImVui4=; b=eXV4iFP1npJk52S9kUBLbzpcir
	03WB9qY5PPF2MjO4jusjOEWzixo5b/RV+Zf1JW8V5oaPPfThZ17TT8zjwrEuD+nFGLeiL/P/y7QbB
	7vVgeNjauCSxnGCKTtChjPXgF0lFp1r3RqZo70hkWRxCnQKRmdfyYOWruQGW9X/jhR/TZFPRn6ofz
	6RuylVbOP9k3pn6uaRPO/RCncr5Wa5LBcP89PO/M2jVRtdDMlX7QYAo7+hmXwuETo1r97V+030LO5
	z+wUoyQodJAYhMhB4cnE23T97g4D1c+ImgH8hVaQz7YVOevC7NUWFJxnNyAkEi+gt9bI3eiU/MC50
	gafL0cmg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqssh-000000007Dn-0tvx;
	Fri, 13 Feb 2026 14:06:47 +0100
Date: Fri, 13 Feb 2026 14:06:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH v2] iptables: fix null dereference parsing bitwise
 operations
Message-ID: <aY8h55YbXBQ53Gks@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
References: <20260212200617.3297279-1-one-d-wide@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212200617.3297279-1-one-d-wide@protonmail.com>

On Thu, Feb 12, 2026 at 08:07:28PM +0000, Remy D. Farley wrote:
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

Patch applied, thanks for following up!
