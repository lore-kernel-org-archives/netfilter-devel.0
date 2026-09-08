Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D66159D62E;
	Tue,  8 Sep 2026 18:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890646; cv=none; b=gCMgSujoUmjrOzUKAaUjJKDlBoesOhhXWSG2jvOBaQZNpyMkKORtGdFB5NmxT6y7sqau6TraD2lx4AAim3hWdPDxVN6N4CDN/eBBtmEtsa4dLx/mhmhm9+ibJWK0UrhUO60+PUJ2U5cGsaOPu0ofEjQpcN8jZFvwtTgGKIoydiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890646; c=relaxed/simple;
	bh=Qiz79g5PSVcF2IF2qvisBggszh3TiyNR4PTMGRDyixA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KNlFiBbd522OILb0WBYMkzZEuOjpOhyoWJYJ/T4av+xe+zRVxlLrxWp1XBdrP8E/45dRWXlD6WXNHP8d2dUqPFGUo+Jd4dblDt92WeSc31MXPmWYh67Gox3yfiVkSNF0kC89Vv2b+8gVroBO6QNiPtoRhrTo1w7wUCQLzDeiz0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFowyx9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFowyx9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EA61F00A3E;
	Tue,  8 Sep 2026 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788890644;
	bh=mMiLERTI+z1WkeyyclW/+eyrW1pM6m7F9OGHgIZnVK0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bFowyx9lbV9WqlkvST20RfCd9ey2npkjm2azEGfL0Pcd+pfDEU4JrWHzEWrQsXdF8
	 JY8jgSVjyPf0Z1JBW4QgbGf4SdsuIbv48KeW28Xh9UoWQd2U2OVXsUPHcWPzbH7o92
	 WFG+O/nlOWun0KK7YSj15ZNILYW7uRGjcFJ2KbxvMD+QYAoEh74JKLEwBH3HYrK3p5
	 +2yLb6VH+6Kebgzb8AzPWK6kManbNIGYzxSMd4CNo1FZDPplC64smvI5eII5i5gcTq
	 GjfAvJ9cJxPpY1k7XbfbSWwSvZ9hBQC7xSq6Xd6Hbmaznqbk9g0iHSgWPj2Axuxd4V
	 6o/TYnzbII8RA==
Subject: Re: [PATCH net 8/9] netfilter: ip6_tables: set F_PROTO when proto
 value is nonzero
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 08 Sep 2026 18:04:04 +0000
Message-ID: <178889064403.219967.3259522251975828189@kernel.org>
In-Reply-To: <20260907171732.1407739-9-pablo@netfilter.org>
References: <20260907171732.1407739-9-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Stale/contradicted UAPI documentation for `struct
  ip6t_ip6::proto`.

--

netfilter: ip6_tables: set F_PROTO when proto value is nonzero

This makes the kernel set IP6T_F_PROTO for any rule that carries a nonzero
ipv6.proto, so ip6_packet_match() always performs the protocol comparison
and extension header walk instead of skipping it when userspace left the
flag clear. It mirrors the normalisation already done in nft_compat.c.

> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> index f42fb96ef64b6..313c4aac377aa 100644
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
> @@ -647,6 +647,11 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
>  	/* Clear counters and comefrom */
>  	e->counters = ((struct xt_counters) { 0, 0 });
>  	e->comefrom = 0;
> +
> +	/* set F_PROTO, else ip6_packet_match won't do the right thing. */
> +	if (e->ipv6.proto)
> +		e->ipv6.flags |= IP6T_F_PROTO;
> +
>  	return 0;
>  }

[Severity: Low]
Should the uapi header comment be updated in the same patch?  The
description of struct ip6t_ip6::proto in
include/uapi/linux/netfilter_ipv6/ip6_tables.h still documents the
opposite contract:

	/* Upper protocol number
	 * ...
	 * - You also need to set IP6T_FLAGS_PROTO to "flags" to check protocol.
	 */
	__u16 proto;

After this change, a non-standard userspace that follows that comment and
sets proto = IPPROTO_TCP while leaving flags = 0 (expecting a
protocol-agnostic rule) gets a protocol-narrowed rule instead, and
ip6_packet_match() now takes the flag-gated branch, including the
ipv6_find_hdr() walk and its *hotdrop = true path when the lookup fails
with _frag_off == 0:

	if (ip6info->flags & IP6T_F_PROTO) {
		...
		protohdr = ipv6_find_hdr(skb, protoff, -1, &_frag_off, NULL);
		if (protohdr < 0) {
			if (_frag_off == 0)
				*hotdrop = true;

Standard ip6tables always sets IP6T_F_PROTO together with -p, so this only
affects hand-crafted rule blobs, and the resulting rule is stricter rather
than unsafe.  Still, the field's documented meaning changes here.

While in that comment, IP6T_FLAGS_PROTO does not exist anywhere in the
tree; the macro defined a few lines below is IP6T_F_PROTO.  That name is a
pre-existing typo and was not introduced by this patch, but it sits in the
same sentence this change invalidates.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260907171732.1407739-2-pablo%40netfilter.org
