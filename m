Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7650537C0E2;
	Fri, 31 Jul 2026 20:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785530467; cv=none; b=Es7dvHH49v8zbJcLGATVHDUzd3euZZdZp+lcXAHYCIiYloV4QNf5zcoIAnInCSdk/TVj0NVSo8zw4Wa5efSkWrVb/GWk5U6dUhD4iLyQ8XBi9YxRv54HFlFNZcVadbr8leE79WPdVU889rJ46y52nuFFRIjVmxOD3YTdLJYNYFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785530467; c=relaxed/simple;
	bh=PDqm1BKGgoM3pk4RNgtQUD4jhgJoC0QQhLQEsVH1pls=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=dFka5vkszDZzqRtqjQugkGZd3XAgb5C5kAhbQKYL89R20IvXsDL00a4WjA66q8owoFPyjzGwYSS0M3Ow87Z26rBIO+QjTYKTiD/K4+o89Ql+8g6jpPQP9xL6jrsteyxeruEGvbB+cMvZpsglWORlKkrZOql0W/oMxcos/MqjHM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMG7W+R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMG7W+R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5B61F00AC4;
	Fri, 31 Jul 2026 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785530466;
	bh=S2K80QHmc0EJh1Wwtw3sYRTZiKW46eHenny2khjEGhw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=RMG7W+R/esmpt/pNqiNSACppYYWKpAvQuYw6l1HwGcbPkjGPY9UlcmXy6iyPX6Hwg
	 y52L73lPTpZQOIfHK2pmcNSCWt6buc1at/nVmhEbRI1oqwec/9rHWc/bdyVID6k8AK
	 A1Yn5B35w3+3NIc5UaFVN95hykL32yeVZyCszdtT25BD6v6HDJY+aIJlUK65zZ6Pzv
	 qzPwMRUIOGsCDhr9Nge4onHidNwdxUj18tHK1Qb0Tvf6kUh6jdEVIjJBZaxpCmIhrY
	 pca0Tg+hyYgpzQmS/puO5ZLICzJgVvjzLC8VEOfSxvpTGp/aB7B7PSX/RC2Z77qw5J
	 SqVavI9dx318w==
Content-Type: multipart/mixed; boundary="===============7093018806644806532=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <1617752d86587cdab81d79caeab2cbbffb3ca997fd18cb68c56bf5f8214d7127@mail.kernel.org>
In-Reply-To: <20260731160921.3245840-1-nicoyip.dev@gmail.com>
References: <20260731160921.3245840-1-nicoyip.dev@gmail.com>
Subject: Re: [PATCH bpf v3] bpf: Fix netns reference imbalance in conntrack kfuncs
From: bot+bpf-ci@kernel.org
To: nicoyip.dev@gmail.com,pablo@netfilter.org,fw@strlen.de,phil@nwl.cc,davem@davemloft.net,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,horms@kernel.org,ast@kernel.org,daniel@iogearbox.net,hawk@kernel.org,john.fastabend@gmail.com,sdf@fomichev.me,memxor@gmail.com,lorenzo@kernel.org
Cc: netfilter-devel@vger.kernel.org,coreteam@netfilter.org,netdev@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,nicoyip.dev@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 31 Jul 2026 20:41:04 +0000 (UTC)

--===============7093018806644806532==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -122,42 +122,54 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
>  	struct nf_conntrack_tuple otuple, rtuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	u8 ct_zone_dir = 0;
> +	u16 ct_zone_id;
> +	s32 netns_id;
> +	u8 l4proto;
>  	int err;
>
>  	if (!(opts_len == NF_BPF_CT_OPTS_SZ || opts_len == 12))
>  		return ERR_PTR(-EINVAL);
> +
> +	netns_id = READ_ONCE(opts->netns_id);
> +	l4proto = READ_ONCE(opts->l4proto);
> +	ct_zone_id = READ_ONCE(opts->ct_zone_id);
>  	if (opts_len == NF_BPF_CT_OPTS_SZ) {
> -		if (opts->reserved[0] || opts->reserved[1] || opts->reserved[2])
> +		ct_zone_dir = READ_ONCE(opts->ct_zone_dir);
> +		if (READ_ONCE(opts->reserved[0]) ||
> +		    READ_ONCE(opts->reserved[1]) ||
> +		    READ_ONCE(opts->reserved[2]))
>  			return ERR_PTR(-EINVAL);
>  	} else {
> -		if (opts->ct_zone_id)
> +		if (ct_zone_id)
>  			return ERR_PTR(-EINVAL);
>  	}
>
> -	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
> +	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>  		return ERR_PTR(-EINVAL);

[ ... ]

>  	if (opts_len == NF_BPF_CT_OPTS_SZ) {
> -		if (opts->ct_zone_dir == 0)
> -			opts->ct_zone_dir = NF_CT_DEFAULT_ZONE_DIR;
> -		nf_ct_zone_init(&ct_zone,
> -				opts->ct_zone_id, opts->ct_zone_dir, 0);
> +		if (ct_zone_dir == 0) {
> +			ct_zone_dir = NF_CT_DEFAULT_ZONE_DIR;
> +			opts->ct_zone_dir = ct_zone_dir;
> +		}
> +		nf_ct_zone_init(&ct_zone, ct_zone_id, ct_zone_dir, 0);
>  	} else {
>  		ct_zone = nf_ct_zone_dflt;
>  	}

[ ... ]

> @@ -186,46 +198,58 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
>  	struct nf_conntrack_tuple tuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	u8 ct_zone_dir = 0;
> +	u16 ct_zone_id;
> +	s32 netns_id;
> +	u8 l4proto;
>  	int err;
>
>  	if (!opts || !bpf_tuple)
>  		return ERR_PTR(-EINVAL);
>  	if (!(opts_len == NF_BPF_CT_OPTS_SZ || opts_len == 12))
>  		return ERR_PTR(-EINVAL);
> +
> +	netns_id = READ_ONCE(opts->netns_id);
> +	l4proto = READ_ONCE(opts->l4proto);
> +	ct_zone_id = READ_ONCE(opts->ct_zone_id);
>  	if (opts_len == NF_BPF_CT_OPTS_SZ) {
> -		if (opts->reserved[0] || opts->reserved[1] || opts->reserved[2])
> +		ct_zone_dir = READ_ONCE(opts->ct_zone_dir);
> +		if (READ_ONCE(opts->reserved[0]) ||
> +		    READ_ONCE(opts->reserved[1]) ||
> +		    READ_ONCE(opts->reserved[2]))
>  			return ERR_PTR(-EINVAL);
>  	} else {
> -		if (opts->ct_zone_id)
> +		if (ct_zone_id)
>  			return ERR_PTR(-EINVAL);
>  	}
> -	if (unlikely(opts->l4proto != IPPROTO_TCP && opts->l4proto != IPPROTO_UDP))
> +	if (unlikely(l4proto != IPPROTO_TCP && l4proto != IPPROTO_UDP))
>  		return ERR_PTR(-EPROTO);
> -	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
> +	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>  		return ERR_PTR(-EINVAL);

[ ... ]

>  	if (opts_len == NF_BPF_CT_OPTS_SZ) {
> -		if (opts->ct_zone_dir == 0)
> -			opts->ct_zone_dir = NF_CT_DEFAULT_ZONE_DIR;
> -		nf_ct_zone_init(&ct_zone,
> -				opts->ct_zone_id, opts->ct_zone_dir, 0);
> +		if (ct_zone_dir == 0) {
> +			ct_zone_dir = NF_CT_DEFAULT_ZONE_DIR;
> +			opts->ct_zone_dir = ct_zone_dir;
> +		}
> +		nf_ct_zone_init(&ct_zone, ct_zone_id, ct_zone_dir, 0);
>  	} else {
>  		ct_zone = nf_ct_zone_dflt;
>  	}

This isn't a bug, but both __bpf_nf_ct_alloc_entry() and
__bpf_nf_ct_lookup() now snapshot and validate the same five opts fields
in the same order with the same declarations (u8 ct_zone_dir = 0; u16
ct_zone_id; s32 netns_id; u8 l4proto;), and both carry the identical
zone-init block. The two functions now share about 25 lines of duplicated
code, and the patch grows each copy from roughly 8 lines to roughly 14.

Would it be worth factoring the snapshot and validation into a shared
helper so a future opts field only has to be handled once?  One of the
Fixes targets, aed8ee7feb44, was itself a de-duplication of similar code
in this file, so the direction of travel here has been toward sharing
rather than copying.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/30647492237
--===============7093018806644806532==--
