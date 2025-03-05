Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8551202F76
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741211249; cv=none; b=umESDR4/lz5nNUTzBqBklVctyfNNGgpDc/syhTxHXiiZtuoBa9CsY+GZnoDZX57B7ZJmYV44RieTjLTcEQvw1Icfi+8BbmpLhVJja3h6Elyxg4MNFJs9xdlkSEz9nhrOOcCd9dwRxDXW3NfLui6R4+Je1Xx2fyxLtQZVr9iNEIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741211249; c=relaxed/simple;
	bh=rBgDtoCIQKggI9p6sqN+VpwN3WlQpKxBzb4C/tfDi+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTqSisVmg2vRk/MWa4xmseD4xja4LgkQgIuEEsVrcMn7+8ON7fKJt6EIGFZSi9c619OisHQwAmntYnqBVTkGsgt0lUKsQOUKVdDDy1mfQFApZZ4YybA3z24muAnrvv9jr5opvM448qdxtFZ9D6nTNOX73SxgAoCxCVnlxH2Ca/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IgOUtsSP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IgOUtsSP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IgOUtsSP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IgOUtsSP"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C97E36028B; Wed,  5 Mar 2025 22:47:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741211244;
	bh=KC/O9iKq/QI4QQTDseyq8dBa+0NiR6doGxAQBKLSXNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgOUtsSP7huJxLDBSRp/do+Lz4ZaEpJ12pp2hm2ODdBpV4vPFrwLRnvMUkgGMjLbE
	 1so6E4l9um9Am+Gfgf+xoXoqHnNiH3YgcUqstqUWNCoc2RrHEPvZRBMSv+V4cXze3m
	 rev9OkeDN2i3pIQ7AotdyWbhyNozBP7Y0E8QvPWerdGXuLP5jEe59OrVeAvNUC3Gih
	 F5AgvNQEoBIXtUVmrk+xGLqKOi01dxnHmMlMJ3Tib4ZV4HNDq3smlG6pGq0BQR1jXE
	 gSn5wf6uxX3jYpEpHV+EXBXgnOiz3B5l8wwgk1EMqkBzA99YEiAZkb1+DhxrnabOSa
	 w4BH2tiQC7GNg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DDFDD6028B;
	Wed,  5 Mar 2025 22:47:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741211244;
	bh=KC/O9iKq/QI4QQTDseyq8dBa+0NiR6doGxAQBKLSXNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgOUtsSP7huJxLDBSRp/do+Lz4ZaEpJ12pp2hm2ODdBpV4vPFrwLRnvMUkgGMjLbE
	 1so6E4l9um9Am+Gfgf+xoXoqHnNiH3YgcUqstqUWNCoc2RrHEPvZRBMSv+V4cXze3m
	 rev9OkeDN2i3pIQ7AotdyWbhyNozBP7Y0E8QvPWerdGXuLP5jEe59OrVeAvNUC3Gih
	 F5AgvNQEoBIXtUVmrk+xGLqKOi01dxnHmMlMJ3Tib4ZV4HNDq3smlG6pGq0BQR1jXE
	 gSn5wf6uxX3jYpEpHV+EXBXgnOiz3B5l8wwgk1EMqkBzA99YEiAZkb1+DhxrnabOSa
	 w4BH2tiQC7GNg==
Date: Wed, 5 Mar 2025 22:47:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] segtree: fix string data initialisation
Message-ID: <Z8jGaFsLyBenv-dK@calendula>
References: <20250305150154.19494-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250305150154.19494-1-fw@strlen.de>

On Wed, Mar 05, 2025 at 04:01:48PM +0100, Florian Westphal wrote:
> This uses the wrong length.  This must re-use the length of the datatype,
> not the string length.
> 
> The added test cases will fail without the fix due to erroneous
> overlap detection, which in itself is due to incorrect sorting of
> the elements.
> 
> Example error:
>  netlink: Error: interval overlaps with an existing one
>  add element inet testifsets simple_wild {  "2-1" } failed.
>  table inet testifsets {
>       ...       elements = { "1-1", "abcdef*", "othername", "ppp0" }
> 
> ... but clearly "2-1" doesn't overlap with any existing members.
> The false detection is because of the "acvdef*" wildcard getting sorted
> at the beginning of the list which is because its erronously initialised
> as a 64bit number instead of 128 bits (16 bytes / IFNAMSIZ).
> 
> Fixes: 5e393ea1fc0a ("segtree: add string "range" reversal support")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/segtree.c                                |  2 +-
>  tests/shell/testcases/sets/sets_with_ifnames | 62 ++++++++++++++++++++
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/src/segtree.c b/src/segtree.c
> index 2e32a3291979..11cf27c55dcb 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -471,7 +471,7 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
>  
>  	expr = constant_expr_alloc(&low->location, low->dtype,
>  				   BYTEORDER_HOST_ENDIAN,
> -				   (str_len + 1) * BITS_PER_BYTE, data);
> +				   len * BITS_PER_BYTE, data);
>  
>  	return __expr_to_set_elem(low, expr);
>  }
> diff --git a/tests/shell/testcases/sets/sets_with_ifnames b/tests/shell/testcases/sets/sets_with_ifnames
> index a4bc5072938e..c65499b76bc5 100755
> --- a/tests/shell/testcases/sets/sets_with_ifnames
> +++ b/tests/shell/testcases/sets/sets_with_ifnames
> @@ -105,10 +105,67 @@ check_matching_icmp_ppp()
>  	fi
>  }
>  
> +check_add_del_ifnames()
> +{
> +	local what="$1"
> +	local setname="$2"
> +	local prefix="$3"
> +	local data="$4"
> +	local i=0
> +
> +	for i in $(seq 1 5);do
> +		local cmd="element inet testifsets $setname { "
> +		local to_batch=16
> +
> +		for j in $(seq 1 $to_batch);do
> +			local name=$(printf '"%x-%d"' $i $j)
> +
> +			[ -n "$prefix" ] && cmd="$cmd $prefix . "
> +
> +			cmd="$cmd $name"
> +
> +			[ -n "$data" ] && cmd="$cmd : $data"
> +
> +			if [ $j -lt $to_batch ] ; then
> +				cmd="$cmd, "
> +			fi
> +		done
> +
> +		cmd="$cmd }"
> +
> +		if ! $NFT "$what" "$cmd"; then
> +			echo "$what $cmd failed."
> +			$NFT list set inet testifsets $setname
> +			exit 1
> +		fi
> +
> +		if ! ip netns exec "$ns1" $NFT "$what" "$cmd"; then
> +			echo "$ns1 $what $cmd failed."
> +			ip netns exec "$ns1" $NFT list set inet testifsets $setname
> +			exit 1
> +		fi
> +	done
> +}
> +
> +check_add_ifnames()
> +{
> +	check_add_del_ifnames "add" "$1" "$2" "$3"
> +}
> +
> +check_del_ifnames()
> +{
> +	check_add_del_ifnames "delete" "$1" "$2" "$3"
> +}
> +
>  ip netns add "$ns1" || exit 111
>  ip netns add "$ns2" || exit 111
>  ip netns exec "$ns1" $NFT -f "$dumpfile" || exit 3
>  
> +check_add_ifnames "simple" "" ""
> +check_add_ifnames "simple_wild" "" ""
> +check_add_ifnames "concat" "10.1.2.2" ""
> +check_add_ifnames "map_wild" "" "drop"
> +
>  for n in abcdef0 abcdef1 othername;do
>  	check_elem simple $n
>  done
> @@ -150,3 +207,8 @@ ip -net "$ns2" addr add 10.1.2.2/24 dev veth0
>  ip -net "$ns2" addr add 10.2.2.2/24 dev veth1
>  
>  check_matching_icmp_ppp
> +
> +check_del_ifnames "simple" "" ""
> +check_del_ifnames "simple_wild" "" ""
> +check_del_ifnames "concat" "10.1.2.2" ""
> +check_del_ifnames "map_wild" "" "drop"
> -- 
> 2.48.1
> 
> 
