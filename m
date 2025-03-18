Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A973D18C33B
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742300694; cv=none; b=b51VUlPZH37EG/irwqhA434Lh0GHgqk9aqHUGwVyaoCF3Az8h4NU0yKfN3C86vQ5m+twsnPjHQWmjZTB36MG41/K9mXcTlRgJKBMDDviLyY5LVBFiyJYIaL96Zt/Lvt45+zfsp0albU7M9MdzeOp3pPcMsYasKSlQnnN0sJbpC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742300694; c=relaxed/simple;
	bh=QN5/aVb+nZ83BFqgSSTjOLw8WxdMIZtnTD2lXg5MHdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGJ4GhP1aFCw3yAVQMCeqF5Tq1W65ri12KkFi+xB35Pu2K5hBBAs3n45sBbpFFrg/GUE8VqQNFt3XYiAXgiY9ttqvgFp18OGNdHsBgKbMukgWVaOO1DDxm2gHkgp3yRrhXpcqCCzmL4vsh+VamiVlqrEddlnyxKyLJAxAY9HF7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EBDVGNcU; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=riV2HMiY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EBDVGNcU";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="riV2HMiY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AE0DB605E4; Tue, 18 Mar 2025 13:24:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742300682;
	bh=MH94JYweqGxMd8HOIPMOQFl8fnyIdW29GivGIvFuzSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EBDVGNcUsjDx2hvGqj66Bfgxs5j0JZuKvqtnwzQ6EcTgI2CWK5fbLu9JDlFFCx16A
	 edhT7sfxcVUWyZuqGiENiJ2i0YKFhHBy4BtFXTujtW0v8gM7+uDdgKjg9BrqwE2Aay
	 llA6VIBbArdHYZx4qyKg+M0Ly/ZfnEUUsVstohNCwWuFbjvcKJQTrv+kEGJfGoLPjK
	 i9+fBUwltNmfqGvNF1GqYolxdKaVNvycEirf9q98YZ40DckB5u6bfNvv6a32FxoVn9
	 56lFi1gPLQ+rsEWuc48p7g06JkyVImTj++dqbAbevl0312PDEiTwDs0aVLY8yLkfoM
	 1yQ3IGxcO5mZA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9C826605E4;
	Tue, 18 Mar 2025 13:24:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742300681;
	bh=MH94JYweqGxMd8HOIPMOQFl8fnyIdW29GivGIvFuzSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=riV2HMiY5cKd9naBJ9sSvexBIXuRyZNY7ASS28Dtj/5Y4K3CUlK4+xeVH6QpEHn0o
	 xY910YWyOAZ1CLPiX3QX3ZuMc9Dq0wLLIFxC5WkfukPmr2hZW2lQUZanKx4+jnHvuB
	 58tAT0TOGzIGhIJLnrRS5FMxuZnOJuDXp+RCBILn2RduOhw4Vrztlcieu0XVTcMasa
	 6IUuj2FDi69ZlFXnTW005dD/wv4sx1z5+5NTR/0MxiTRVZzVl440KxxGpfgNPrlGK6
	 UFfjuNRBXDoybpSF/NqrBMdxzH8ZSNsopp0SknTTgd3fEsd98TtVk6NpWse6vWmbT3
	 40Vsk1w37RiEg==
Date: Tue, 18 Mar 2025 13:24:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink: fix stack buffer overrun when emitting
 ranged expressions
Message-ID: <Z9lmBhYELKyJHHOk@calendula>
References: <20250314124159.2131-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7J/+PD0wSCmZqo7u"
Content-Disposition: inline
In-Reply-To: <20250314124159.2131-1-fw@strlen.de>


--7J/+PD0wSCmZqo7u
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Florian,

On Fri, Mar 14, 2025 at 01:41:49PM +0100, Florian Westphal wrote:
> Included bogon input generates following Sanitizer splat:
> 
> AddressSanitizer: dynamic-stack-buffer-overflow on address 0x7...
> WRITE of size 2 at 0x7fffffffcbe4 thread T0
>     #0 0x0000003a68b8 in __asan_memset (src/nft+0x3a68b8) (BuildId: 3678ff51a5405c77e3e0492b9a985910efee73b8)
>     #1 0x0000004eb603 in __mpz_export_data src/gmputil.c:108:2
>     #2 0x0000004eb603 in netlink_export_pad src/netlink.c:256:2
>     #3 0x0000004eb603 in netlink_gen_range src/netlink.c:471:2
>     #4 0x0000004ea250 in __netlink_gen_data src/netlink.c:523:10
>     #5 0x0000004e8ee3 in alloc_nftnl_setelem src/netlink.c:205:3
>     #6 0x0000004d4541 in mnl_nft_setelem_batch src/mnl.c:1816:11
> 
> Problem is that the range end is emitted to the buffer at the *padded*
> location (rounded up to next register size), but buffer sizing is
> based of the expression length, not the padded length.
> 
> Also extend the test script: Capture stderr and if we see
> AddressSanitizer warning, make it fail.
> 
> Same bug as the one fixed in 600b84631410 ("netlink: fix stack buffer overflow with sub-reg sized prefixes"),
> just in a different function.
> 
> Apply same fix: no dynamic array + add a length check.

While at it, extend it for similar code too until there is a way to
consolidate this? See attachment.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/netlink.c                                   | 11 +++++++----
>  tests/shell/testcases/bogons/assert_failures    | 17 ++++++++++++++++-
>  ...an_stack_buffer_overrun_in_netlink_gen_range |  6 ++++++
>  3 files changed, 29 insertions(+), 5 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 8e6e2066fe2a..52c2d8009b82 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -462,11 +462,14 @@ static void netlink_gen_verdict(const struct expr *expr,
>  static void netlink_gen_range(const struct expr *expr,
>  			      struct nft_data_linearize *nld)
>  {
> -	unsigned int len = div_round_up(expr->left->len, BITS_PER_BYTE) * 2;
> -	unsigned char data[len];
> -	unsigned int offset = 0;
> +	unsigned int len = (netlink_padded_len(expr->left->len) / BITS_PER_BYTE) * 2;
> +	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
> +	unsigned int offset;
>  
> -	memset(data, 0, len);
> +	if (len > sizeof(data))
> +		BUG("Value export of %u bytes would overflow", len);
> +
> +	memset(data, 0, sizeof(data));
>  	offset = netlink_export_pad(data, expr->left->value, expr->left);
>  	netlink_export_pad(data + offset, expr->right->value, expr->right);
>  	nft_data_memcpy(nld, data, len);
> diff --git a/tests/shell/testcases/bogons/assert_failures b/tests/shell/testcases/bogons/assert_failures
> index 79099427c98a..3dee63b3f97b 100755
> --- a/tests/shell/testcases/bogons/assert_failures
> +++ b/tests/shell/testcases/bogons/assert_failures
> @@ -1,12 +1,27 @@
>  #!/bin/bash
>  
>  dir=$(dirname $0)/nft-f/
> +tmpfile=$(mktemp)
> +
> +cleanup()
> +{
> +	rm -f "$tmpfile"
> +}
> +
> +trap cleanup EXIT
>  
>  for f in $dir/*; do
> -	$NFT --check -f "$f"
> +	echo "Check $f"
> +	$NFT --check -f "$f" 2> "$tmpfile"
>  
>  	if [ $? -ne 1 ]; then
>  		echo "Bogus input file $f did not cause expected error code" 1>&2
>  		exit 111
>  	fi
> +
> +	if grep AddressSanitizer "$tmpfile"; then
> +		echo "Address sanitizer splat for $f" 1>&2
> +		cat "$tmpfile"
> +		exit 111
> +	fi
>  done
> diff --git a/tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range b/tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range
> new file mode 100644
> index 000000000000..2f7872e4accd
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range
> @@ -0,0 +1,6 @@
> +table ip test {
> +        chain y {
> +                redirect to :tcp dport map { 83 : 80/3, 84 :4 }
> +        }
> +}
> +
> -- 
> 2.45.3
> 
> 

--7J/+PD0wSCmZqo7u
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/netlink.c b/src/netlink.c
index 687b0b87da3a..dfb7f4d17147 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -330,11 +330,15 @@ static void nft_data_memcpy(struct nft_data_linearize *nld,
 static void netlink_gen_concat_key(const struct expr *expr,
 				    struct nft_data_linearize *nld)
 {
-	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
-	unsigned char data[len];
+	unsigned int len = netlink_padded_len(expr->len) / BITS_PER_BYTE;
+	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
+	unsigned int offset = 0;
 	const struct expr *i;
 
-	memset(data, 0, len);
+	if (len > sizeof(data))
+		BUG("Value export of %u bytes would overflow", len);
+
+	memset(data, 0, sizeof(data));
 
 	list_for_each_entry(i, &expr->expressions, list)
 		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
@@ -373,11 +377,15 @@ static int __netlink_gen_concat_data(int end, const struct expr *i,
 static void __netlink_gen_concat_expand(const struct expr *expr,
 				        struct nft_data_linearize *nld)
 {
-	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE) * 2, offset = 0;
-	unsigned char data[len];
+	unsigned int len = (netlink_padded_len(expr->len) / BITS_PER_BYTE) * 2;
+	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
+	unsigned int offset = 0;
 	const struct expr *i;
 
-	memset(data, 0, len);
+	if (len > sizeof(data))
+		BUG("Value export of %u bytes would overflow", len);
+
+	memset(data, 0, sizeof(data));
 
 	list_for_each_entry(i, &expr->expressions, list)
 		offset += __netlink_gen_concat_data(false, i, data + offset);
@@ -391,11 +399,15 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 static void __netlink_gen_concat(const struct expr *expr,
 				 struct nft_data_linearize *nld)
 {
-	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
-	unsigned char data[len];
+	unsigned int len = netlink_padded_len(expr->len) / BITS_PER_BYTE;
+	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
+	unsigned int offset = 0;
 	const struct expr *i;
 
-	memset(data, 0, len);
+	if (len > sizeof(data))
+		BUG("Value export of %u bytes would overflow", len);
+
+	memset(data, 0, sizeof(data));
 
 	list_for_each_entry(i, &expr->expressions, list)
 		offset += __netlink_gen_concat_data(expr->flags, i, data + offset);
@@ -1218,10 +1230,15 @@ static struct expr *range_expr_reduce(struct expr *range)
 static struct expr *netlink_parse_interval_elem(const struct set *set,
 						struct expr *expr)
 {
-	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	unsigned int len = netlink_padded_len(expr->len) / BITS_PER_BYTE;
 	const struct datatype *dtype = set->data->dtype;
 	struct expr *range, *left, *right;
-	char data[len];
+	char data[NFT_MAX_EXPR_LEN_BYTES];
+
+	if (len > sizeof(data))
+		BUG("Value export of %u bytes would overflow", len);
+
+	memset(data, 0, sizeof(data));
 
 	mpz_export_data(data, expr->value, dtype->byteorder, len);
 	left = constant_expr_alloc(&internal_location, dtype,

--7J/+PD0wSCmZqo7u--
