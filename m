Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068FF2661BB
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 22:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741212774; cv=none; b=qxZLgFNs5E+P3g7tIV5mFZxHtcFS4VgYDocG84jZ717Rzpb+2vNPoa3Vsr8Nm+wMRLSTgfDrvCPxqo2rJWF3kLia0sqLskIqdovu0EDuGR+Q57zTOGDZzC7jo13Xw+1n9mkucLlnrZyqSUL103Mi2uql/jeupN3Gd5xsnFNPcXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741212774; c=relaxed/simple;
	bh=3LkyGvKbEoUt02V/ByGtGWiB96hI5UgODoL2OhkHJIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5akTA6i6XcEM5ugwkGvYc7K+4i8BJz6BxbwjC+WLCjNJuiSci+PBBJdlaZuUuO1VJD4UhAj5GdgsZGJQX1r4/kLu/hLICHVGWoJ1qD2gImoUh1XuvsniIpxphcnP35TNgoITJ9uOmBDEIeihV8yMYXkCR3tzya9Y/ApD88NR2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e8FodICh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pLdJah1v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e8FodICh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pLdJah1v"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1FEC960291; Wed,  5 Mar 2025 23:12:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741212770;
	bh=d4bU3i4j1zp9JBbeNl7amMUr0hSSaPZ4WPNcc4T4UWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e8FodIChJe8JvM7bwfYtYVxiMteOkTclyLFYuRdwIMTcqswNZsa3R4xEzNX+TL5/H
	 E7moVhUEdW9ToUtoq3ptCb2FoGeqXjGOvOPAK31k5Lt6y+D0nfNwWPvHMaRRFVZSNq
	 AET3PkFtwvXZiKKJn67DMBlRj+A139p0fxtzmJ0+DYh9BQXuVvZCspT+Po+LfAZSkG
	 wpkpXdaY9fHXxancd6uwvveRTzNzvCzjxSDXVzgcKQstQf64GizCgumym1tgC74UZ+
	 oOLlfwGBzRp3BkVZhoq+eGC9yZGUfhM1tznEBcWEB9uusPgkwX3GseA870NXTfAbko
	 qSn0lAM6uJK6w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5003C6028D;
	Wed,  5 Mar 2025 23:12:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741212769;
	bh=d4bU3i4j1zp9JBbeNl7amMUr0hSSaPZ4WPNcc4T4UWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pLdJah1vsgBM8yemy3OrD1ZHZSTmR9gvfD46mrJb1YdC39YHGyg0GX1zJUDzacoGT
	 eogQ76R3un6KgsT9V7bQY4jmr/8Fxm6AI+GKzUrY+W2xgPhpyWZm7uTs9mkc/4cmwP
	 oaTXE72XKBzg5EYL+S/xCI10xGVhX93Mlb7dvviBuEwkYue0GY5hTRwVDbPc8X3B6Y
	 5qt6Imk4e9ngkusFCcsba/APPVbVqi3gQ7Cf6IPO5tqbo0HeMKqSUfc1DRC0OjgiLN
	 nsfPW7Ac5VATXvAqYk8Xx+oXz7grDsZRjfq7yqmJSqACB0Uz/Bt3ledc/T/PSFfl2L
	 303GvIJvPCZLQ==
Date: Wed, 5 Mar 2025 23:12:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] segtree: fix string data initialisation
Message-ID: <Z8jMXkcOOKzsyELF@calendula>
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

One question here.

> Fixes: 5e393ea1fc0a ("segtree: add string "range" reversal support")
> Signed-off-by: Florian Westphal <fw@strlen.de>
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

BTW, is this also needed?

diff --git a/src/segtree.c b/src/segtree.c
index 2e32a3291979..b7a89383fae0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -453,7 +453,7 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
 {
        unsigned int len = div_round_up(i->len, BITS_PER_BYTE);
        unsigned int prefix_len, str_len;
-       char data[len + 2];
+       char data[len + 2] = {};
        struct expr *expr;
 
        prefix_len = expr_value(i)->len - mpz_scan0(range, 0);

otherwise uninitialized data could be send to the kernel?

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
