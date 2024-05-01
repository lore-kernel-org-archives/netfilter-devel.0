Received: from smtp.forwardemail.net (smtp.forwardemail.net [149.28.215.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8E01D68F
	for <netfilter-devel@vger.kernel.org>; Wed,  1 May 2024 05:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.28.215.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714540307; cv=none; b=lhbu0Rp1Bh3v9R4qbPLpW1lqmqvdbrbxKXtlxLvGF1cXDSZiH5fWLrjVWXMrZ3pH64tDpxrHZaduLSit4gfqwbD4PCT2T9NMkBRQXQcH12cPHoWA07B3LDvhmVpZRjuPT+CYyQTJGi4m7p86oPOCAoWKsb1IbXgq9HbuPVMZ/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714540307; c=relaxed/simple;
	bh=pEAY0QWRsLB9JluX8XvvnxaNOrBWmNrSqSwEC+UUzo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GZnWaTIZwDlKC4IqbzAgn8endGvZ0ci2y/eVTKeJY8lOwoDBWqEfkBA0z4CaG44kJn6Ct2ydXXpN83PFmcbAR0gdqzY1fM1d6pOBeFe8O/tEvWbW1A35xJyNds/p0o3MeNfdpSUr5dxuw1eDcjonoA6w2Oh1GfM/G5yb31Y6TRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=faucet.nz; spf=pass smtp.mailfrom=fe-bounces.faucet.nz; dkim=pass (1024-bit key) header.d=faucet.nz header.i=@faucet.nz header.b=w86L0Mfe; arc=none smtp.client-ip=149.28.215.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=faucet.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.faucet.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=faucet.nz header.i=@faucet.nz header.b="w86L0Mfe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=faucet.nz;
 h=Content-Transfer-Encoding: MIME-Version: References: In-Reply-To:
 Message-Id: Date: Subject: Cc: To: From; q=dns/txt; s=fe-4ed8c67516;
 t=1714540290; bh=enGl1EWAiYGXFruQwU3JI5/BpgRyOA/UsoNJoaKWqB4=;
 b=w86L0Mfe+WJFVWiWNrrNu0ODPXsyWWzvqRW+Uzcgxusf/o77gdOlU1ZCiVVU2w+pkx/h1ZToi
 5jy2mcyQmMfXDMTTc6zDaG9UpqgwIx/2JMw8AJlHnT6avQC8uKwBo0ProRmuCaBiWQC76dW2z2Q
 ZflksCjEN0XinwYMcSjenq0=
From: Brad Cowie <brad@faucet.nz>
To: martin.lau@linux.dev
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, brad@faucet.nz,
 coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
 john.fastabend@gmail.com, jolsa@kernel.org, kuba@kernel.org,
 lorenzo@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org,
 sdf@google.com, song@kernel.org
Subject: Re: [PATCH bpf-next v2 1/2] net: netfilter: Make ct zone opts configurable for bpf ct helpers
Date: Wed,  1 May 2024 16:59:31 +1200
Message-Id: <20240501045931.157041-1-brad@faucet.nz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <463c8ea7-08cf-412e-bb31-6fbb15b4df8b@linux.dev>
References: <463c8ea7-08cf-412e-bb31-6fbb15b4df8b@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Report-Abuse-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-ForwardEmail-Version: 0.4.40
X-ForwardEmail-Sender: rfc822; brad@faucet.nz, smtp.forwardemail.net,
 149.28.215.223
X-ForwardEmail-ID: 6631cc4e257562284fbdc957

On Fri, 26 Apr 2024 at 11:27, Martin KaFai Lau <martin.lau@linux.dev> wrote:
> On 4/23/24 8:00 PM, Brad Cowie wrote:
> >   };
> >
> >   static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
> > @@ -104,11 +107,13 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
> >   			u32 timeout)
> >   {
> >   	struct nf_conntrack_tuple otuple, rtuple;
> > +	struct nf_conntrack_zone ct_zone;
> >   	struct nf_conn *ct;
> >   	int err;
> >
> > -	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
> > -	    opts_len != NF_BPF_CT_OPTS_SZ)
> > +	if (!opts || !bpf_tuple)
> > +		return ERR_PTR(-EINVAL);
> > +	if (!(opts_len == NF_BPF_CT_OPTS_SZ || opts_len == NF_BPF_CT_OPTS_OLD_SZ))
> >   		return ERR_PTR(-EINVAL);
> >
> >   	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
> > @@ -130,7 +135,16 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
> >   			return ERR_PTR(-ENONET);
> >   	}
> >
> > -	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
> > +	if (opts_len == NF_BPF_CT_OPTS_SZ) {
> > +		if (opts->ct_zone_dir == 0)
>
> I don't know the details about the dir in ct_zone, so a question: a 0 
> ct_zone_dir is invalid and can be reused to mean NF_CT_DEFAULT_ZONE_DIR?

ct_zone_dir is a bitmask that can have two different bits set,
NF_CT_ZONE_DIR_ORIG (1) and NF_CT_ZONE_DIR_REPL (2).

The comparison function nf_ct_zone_matches_dir() in nf_conntrack_zones.h
checks if ct_zone_dir & (1 << ip_conntrack_dir dir). ip_conntrack_dir
has two possible values IP_CT_DIR_ORIGINAL (0) and IP_CT_DIR_REPLY (1).

If ct_zone_dir has a value of 0, this makes nf_ct_zone_matches_dir()
always return false which makes nf_ct_zone_id() always return
NF_CT_DEFAULT_ZONE_ID instead of the specified ct zone id.

I chose to override ct_zone_dir here and set NF_CT_DEFAULT_ZONE_DIR (3),
to make the behaviour more obvious when a user calls the bpf ct helper
kfuncs while only setting ct_zone_id but not ct_zone_dir.

> > +			opts->ct_zone_dir = NF_CT_DEFAULT_ZONE_DIR;
> > +		nf_ct_zone_init(&ct_zone,
> > +				opts->ct_zone_id, opts->ct_zone_dir, opts->ct_zone_flags);
> > +	} else {
>
> Better enforce "ct_zone_id == 0" also instead of ignoring it.

Could I ask for clarification here, do you mean changing this
else statement to:

+	} else if (opts->ct_zone_id == 0) {

Or should I be setting opts->ct_zone_id = 0 inside the else block?
