Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C534B4028C3;
	Thu, 30 Jul 2026 09:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405140; cv=none; b=o/60D3FHNkcWx0O486bQVb8F29mOnW/Oohyck3MQo8vToulPFFZS51HM/eXEcYue23rpQiJuayT3+JScxqTMG9bHrDxHwsc1ODrftAjBgXTX3eFGMHhiHQHGYX8IBHPKixcMAqAMc6H9n+vf5AsVWaz7KliA8wW1+zQrwlXdTMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405140; c=relaxed/simple;
	bh=t894MoMYEdKrUphOfQJj8pkCwyRwo80HRcbW6XR1exk=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=axDhjT0thoHndcMZvuybHfxi+L/f0iXEyv/oBgr3MEdqZJEwufxtbqbJviUIDFPrxFBvHvEKmNHTdJBlUESMU9Ez+75kCyfj3OnRlM9ay7fCd1FhzunFw4GNrTJHOX3bVx6V8NO7XwH/i0JtpN7WEtufkdF7tiz4wvFk+TmqTsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VC+EP3GK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VC+EP3GK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441991F00A3F;
	Thu, 30 Jul 2026 09:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785405138;
	bh=xUqL87DdA8qA2aMXoECkvDvuXXO5oy6OAIDvleX9BCE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=VC+EP3GKfFLT3d+mN8FImpiyFsl5cBpEICmni8wrtByv1MTDmd/rxr2NIcrgHyTCN
	 i73DS4ezlu3VTcRQux/Q51YlE/6VdxnZBr2BnY5fxlFJKtaexXytWvEFnUj9YR/ylN
	 Zom1t3p982D6fxnPH9M6qKBtnJ5yAnnvNP4nHk/pEqa1/1MXpKfxiD9aHPe4yXyel0
	 BulSFbaI7ixxEy0hHqfN8xobbMjpSVqClQVJI37AsWHq0VaFDycWF1kp4GqE1uSmqz
	 5AbLDSmxNKV+RlFWb9IUxkx7IR9VjncxT/Ri9o5O/S6/JAvv2kVXV8CobTc7u/dEFA
	 d3vxTs60XOp9A==
Content-Type: multipart/mixed; boundary="===============0063013281550582967=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <3bd200c7256262889a96f82d8c4c3535a1e5170067c9a9bde35a7e264814fb30@mail.kernel.org>
In-Reply-To: <20260730082958.2065194-1-nicoyip.dev@gmail.com>
References: <20260730082958.2065194-1-nicoyip.dev@gmail.com>
Subject: Re: [PATCH bpf v2] bpf: Fix netns reference imbalance in conntrack kfuncs
From: bot+bpf-ci@kernel.org
To: nicoyip.dev@gmail.com,pablo@netfilter.org,fw@strlen.de,phil@nwl.cc,davem@davemloft.net,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,horms@kernel.org,ast@kernel.org,daniel@iogearbox.net,hawk@kernel.org,john.fastabend@gmail.com,sdf@fomichev.me,memxor@gmail.com,lorenzo@kernel.org
Cc: netfilter-devel@vger.kernel.org,coreteam@netfilter.org,netdev@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,nicoyip.dev@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 30 Jul 2026 09:52:17 +0000 (UTC)

--===============0063013281550582967==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index f98d1d4b42c3..c3395cb98c00 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -122,42 +122,56 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
>  	struct nf_conntrack_tuple otuple, rtuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	u16 ct_zone_id;
> +	s32 netns_id;
> +	u8 ct_zone_dir = 0;
> +	u8 reserved[3] = {};
> +	u8 l4proto;

This isn't a bug, but would it be worth reordering these declarations
longest-to-shortest to match the netdev reverse-xmas-tree convention
before this goes out again? The block goes from 'struct nf_conn *ct;'
(21 chars) down to 's32 netns_id;' (15), then back up to 'u8 reserved[3]
= {};' (22). The same ordering appears in __bpf_nf_ct_lookup() further
down.

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
> +		reserved[0] = READ_ONCE(opts->reserved[0]);
> +		reserved[1] = READ_ONCE(opts->reserved[1]);
> +		reserved[2] = READ_ONCE(opts->reserved[2]);
> +		if (reserved[0] || reserved[1] || reserved[2])

This isn't a bug, but since reserved[] is only used by the check on the
next line, could the three READ_ONCE() calls be inlined into the condition
instead of going through a local array? The same block appears in
__bpf_nf_ct_lookup() at the corresponding location.

>  			return ERR_PTR(-EINVAL);
>  	} else {
> -		if (opts->ct_zone_id)
> +		if (ct_zone_id)
>  			return ERR_PTR(-EINVAL);
>  	}

[ ... ]

> @@ -186,46 +200,60 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
>  	struct nf_conntrack_tuple tuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	u16 ct_zone_id;
> +	s32 netns_id;
> +	u8 ct_zone_dir = 0;
> +	u8 reserved[3] = {};
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
> +		reserved[0] = READ_ONCE(opts->reserved[0]);
> +		reserved[1] = READ_ONCE(opts->reserved[1]);
> +		reserved[2] = READ_ONCE(opts->reserved[2]);
> +		if (reserved[0] || reserved[1] || reserved[2])
>  			return ERR_PTR(-EINVAL);

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/30527661826
--===============0063013281550582967==--
