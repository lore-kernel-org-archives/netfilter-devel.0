Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874973;
	b=by5KfgDFdlVsEjVvVpRkB38hSHMFiviAOnt3lgNZfvkFNzF86PD2fVGDjE2o1WebXrSK
	 jahqHDL05zOFtmspkJOc5LBrrI+MwK6RKq2ILePG5hCBrd42zwcPMSVrv8pTzd0lJLRRY
	 M3SfAql+Zkck3V92mAkSoyxvhw0WZL5PxUA/MWJqR7w513ra6pBurny8qKR8XMYHMQFyL
	 7cKWxKeoPqlXN8kFxyJMvepao5FzfZb/1Fwme3OXVt7H2BZV7qqcZgmYz58EWEwsrHtI2
	 Wm0O+A7ugG9CzMx05XY2YjAWVacgyBAQ5IPHR3h3rhGzTOztlnMWL+WNZY7Tcch5ZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874973;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=l0rf7L0u8LWAAVJiVYbDdKMPiWuUUvJiPStr+CQ+4Ic=;
	b=e4Qi4rbUUvlf4H2At6i70eIEcdUQYNy1nSmEXcGwVrAgiczwejudcWRxiBbgqLA6y6D5
	 +8dE0KMz7tO1T4p7e08sUQi07uoAmPuJu2wN9YHEaXrmyx20J9PKtgEJGj54Wr5oq1HP7
	 PvbFsC8WVlPF6OMB+bBWdeFjSL+vpe2Q74XMtJ/iEkVd3t2p/E/1CL/WYxyeut0YqQFVY
	 FJP+KrhmIbldguVckBXZhe421LxIqVDJHgRn6gXa5bEAOuXY9jRArzIiJz3R9x4amakW6
	 JQDItoUMdYEdCifO5ngWMq8vA2mbFY0mVoxk2M1/iONaeDZMYciaxbLKCTp51XIDuWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PG9SO+Qm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703B606A323;
	Tue, 17 Nov 2026 00:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PG9SO+Qm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A351D1F000C5;
	Tue, 17 Nov 2026 00:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874973;
	bh=l0rf7L0u8LWAAVJiVYbDdKMPiWuUUvJiPStr+CQ+4Ic=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PG9SO+QmSVJ5eVsQerJGd9gHJxml6DEXuD+z+/OXsDZZAWr930WOlVu6va+RRjrhF
	 pfNSBjKbS8iyPKkGCIvjpKlZVc0ILPvPTeCLQyrkJArJ312cmeLJOBX7wywZEBN9og
	 qi/d7E6aXXI1ZV2+pcVlJadxK+5JRnlsDpxZAOpWy9nwfJxSx0dGd1PmKhNoGL7NkB
	 rXSePIjYl+ysGp3y8kyrKl5XvkGq38ABOPIdOWtt2EyWvF5UgMgQn7+yqvqbAzv7du
	 d29beMWi1SIk+m5bgO/RkW6NGBgbmCnkrbPhGSPcrMBYP95x+PRFeWgs1/CdmyHDdo
	 oroYb+U8qSVcQ==
Subject: Re: [PATCH net-next 09/13] netfilter: flowtable: do not scrub as
 crossing netns
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:52 +0000
Message-ID: <179487497222.3136.5458006669603733275@kernel.org>
In-Reply-To: <20261116001612.2806263-10-pablo@netfilter.org>
References: <20261116001612.2806263-10-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message and its Fixes: tag cover only half of what the
  patch changes.

--

netfilter: flowtable: do not scrub as crossing netns

This commit changes the flowtable tunnel tx push helpers to call
skb_scrub_packet() with xnet set to false, so the existing skb mark is
kept. The commit message gives the reason that IPIP tunneling does not
cross a netns.

> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 19cafae748abe..78bba416dd5be 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c

[ ... ]

> @@ -699,7 +699,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
>  	if (err)
>  		return err;
>  
> -	skb_scrub_packet(skb, true);
> +	skb_scrub_packet(skb, false);

[Severity: Low]
This isn't a bug, but should the commit message and Fixes: tags also
cover this hunk?

The message only mentions "IPIP tunneling support", and the only tag is:

  Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")

That tag matches the change in nf_flow_tunnel_ip_push(). The call changed
here in nf_flow_tunnel_ip6_push() came from a different commit:

  93cf357fa797 ("netfilter: flowtable: Add IP6IP6 tx sw acceleration")

The IPv6 outer path changes behavior as well. With xnet set to false,
skb_scrub_packet() now returns before it reaches this code:

	skb->mark = 0;
	skb_clear_tstamp(skb);

Stable selection still works, because 93cf357fa797 came after
d30301ba4b07. Every tree that has the IPv6 code also has the commit that
is cited.

Could a second Fixes: tag for 93cf357fa797 be added, along with a
sentence about the IP6IP6 / IPv6 outer path?

>  	mtu = dst_mtu(dst) - sizeof(*ip6h);
>  	mtu = max(mtu, IPV6_MIN_MTU);
>  	skb_dst_update_pmtu_no_confirm(skb, mtu);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
