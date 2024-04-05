Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8776416FF36;
	Fri,  5 Apr 2024 20:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712347313; cv=none; b=r7a1M+9pp1OIgEDo5QYLYhwM8U2qxK4TaEYeAgOoExbN+WHGezQ/s/LYA7RWJz5qApGR0HcUCWBgMVWJVH00aentlwmGGS00VqlSj1w107xJoQQzf80zkFd0fsaVviLj3ItgsjJumUeMfJz6eiE3IcRYzQMryzOH2Yyt0VUWGVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712347313; c=relaxed/simple;
	bh=t8Zy94V47DEeguDpVsCAlSHh8loEquEVZj3DhaG/mCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7A2Fp8NZpMil9uCfEe3iFY7q7coaSqmV7O8yj4AsCS3NXqryAZ9lAAst5umiioC7p3IbRh8n1Hz5Ol2GlxdD1R10t/nPCrlJlQDCxD1H+dLxYhil2xZjW11JZ4ak+psZ9LH3q9/59BnNjWTxD3F7aKckFoyZXIvfm5TzUfcoUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q0ir2StH; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q0ir2StH"
Message-ID: <29325462-d001-4cb3-909d-27f7243a5c05@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712347309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gWflinqU1d4wkQYf0aiD/ruz8RWl/tYTTOYnC5SJvI=;
	b=q0ir2StHc3kPa0wMeyOID45TWAeATcIeQbaZClgmEfmzmdtgPJrlcv6qHBr1bYfYt07BB5
	9Dxh3WzWLM2mpLIqv+IsnXo8LoYFDyLoSmMPxGxLExJblxBQCVvOcgXKPiOe65vUzwZZLh
	T7czWGzGRog4EKJiUvzb+qgFFNh4HvY=
Date: Fri, 5 Apr 2024 13:01:40 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next] net: netfilter: Make ct zone id configurable for
 bpf ct helper functions
To: Brad Cowie <brad@faucet.nz>
Cc: lorenzo@kernel.org, memxor@gmail.com, pablo@netfilter.org,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
 john.fastabend@gmail.com, sdf@google.com, jolsa@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20240329041430.2176860-1-brad@faucet.nz>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20240329041430.2176860-1-brad@faucet.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 3/28/24 9:14 PM, Brad Cowie wrote:
> Add ct zone id to bpf_ct_opts so that arbitrary ct zone can be
> set for xdp/tc bpf ct helper functions bpf_{xdp,skb}_ct_alloc
> and bpf_{xdp,skb}_ct_lookup.
> 
> Signed-off-by: Brad Cowie <brad@faucet.nz>
> ---
>   net/netfilter/nf_conntrack_bpf.c              | 23 ++++++++++---------
>   .../testing/selftests/bpf/prog_tests/bpf_nf.c |  1 -
>   .../testing/selftests/bpf/progs/test_bpf_nf.c | 13 ++---------
>   3 files changed, 14 insertions(+), 23 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index d2492d050fe6..a0f8a64751ec 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -30,7 +30,6 @@
>    * @error      - Out parameter, set for any errors encountered
>    *		 Values:
>    *		   -EINVAL - Passed NULL for bpf_tuple pointer
> - *		   -EINVAL - opts->reserved is not 0
>    *		   -EINVAL - netns_id is less than -1
>    *		   -EINVAL - opts__sz isn't NF_BPF_CT_OPTS_SZ (12)
>    *		   -EPROTO - l4proto isn't one of IPPROTO_TCP or IPPROTO_UDP
> @@ -42,16 +41,14 @@
>    *		 Values:
>    *		   IPPROTO_TCP, IPPROTO_UDP
>    * @dir:       - connection tracking tuple direction.
> - * @reserved   - Reserved member, will be reused for more options in future
> - *		 Values:
> - *		   0
> + * @ct_zone    - connection tracking zone id.
>    */
>   struct bpf_ct_opts {
>   	s32 netns_id;
>   	s32 error;
>   	u8 l4proto;
>   	u8 dir;
> -	u8 reserved[2];
> +	u16 ct_zone;

How about the other fields (flags and dir) in the "struct nf_conntrack_zone" and 
would it be useful to have values other than the default?

[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index b30ff6b3b81a..25c3c4e87ed5 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -103,7 +103,6 @@ static void test_bpf_nf_ct(int mode)
>   		goto end;
>   
>   	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
> -	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
>   	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
>   	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
>   	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> index 77ad8adf68da..4adb73bc1b33 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -45,7 +45,8 @@ struct bpf_ct_opts___local {
>   	s32 netns_id;
>   	s32 error;
>   	u8 l4proto;
> -	u8 reserved[3];
> +	u8 dir;
> +	u16 ct_zone;
>   } __attribute__((preserve_access_index));
>   
>   struct nf_conn *bpf_xdp_ct_alloc(struct xdp_md *, struct bpf_sock_tuple *, u32,
> @@ -84,16 +85,6 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
>   	else
>   		test_einval_bpf_tuple = opts_def.error;
>   
> -	opts_def.reserved[0] = 1;
> -	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> -		       sizeof(opts_def));
> -	opts_def.reserved[0] = 0;
> -	opts_def.l4proto = IPPROTO_TCP;
> -	if (ct)
> -		bpf_ct_release(ct);
> -	else
> -		test_einval_reserved = opts_def.error;
> -

Can it actually test an alloc and lookup of a non default zone id?

Please also separate the selftest into another patch.

pw-bot: cr

>   	opts_def.netns_id = -2;
>   	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
>   		       sizeof(opts_def));

