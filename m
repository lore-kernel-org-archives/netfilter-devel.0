Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCB41442F4;
	Wed,  2 Apr 2025 19:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743621539; cv=none; b=cLnC3ddlgOuDhP9sVpnUJcI4ptfC/Z4uOK9YeqJV4k6jy2E4gLkjsT+GwstyoTPsqvhU8Bf318ib7B1UcGwKxPWYWb9TldaZ8lrqkXnR8K/X41nrTRS4ALQMYitVFZbtO0yVL1YarjVeQHBrWo8ViQ0zJAIcNDyDIzK95XM4WO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743621539; c=relaxed/simple;
	bh=u1VzHhr3NATkjO5zyRwRIyBCZ7KIidR1SIlaH6YNjY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buP4EgBP5H+fWBRN/U89J/AqKDd592HfqkEuuY+LKrRTp4v40mSsRZHjjFuyPe+JG3PnM92p7LrioQ0YTdmvbuiiQLtCjfGeagk5f2WF2XWwYDgTzaxTH3LQABS8/ZiXxD7rMPrwNnNVRx6OPWY4AVMM1/Cv/1fvX0ALgKb1OYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=otSks8tH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KqYv92ps; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="otSks8tH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KqYv92ps"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 61BCD605FF; Wed,  2 Apr 2025 21:18:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743621527;
	bh=M2JF6JNwewrfGe73f8c2ZUcID5NoSrPFhaz8S0huJno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=otSks8tHsc/8mmYdoxx3Zv4HxDKPupQcfCWRWeWjif7FaUH8E+HwyftYjmiEqRy8b
	 KYnRgGsOsGkYPvyAZIDvu8rrMY8VlqkK9gfS3WbQpVn34eQ+Bw93wQTlBRzDCAakA0
	 PyoWKjt8i7Yl1fLHUcl1KIdNh51Rpyrt+PeZqInNUENcZex3xm/an8pSoioYGMgQ6k
	 M0mY65DIN6U55zTsWOQhUtCPrLXeuohElwfOMiTl9xPoOSp39fSn1lUgvaLy8MRBV7
	 nujeuT5yFxDSrPsmQEbv7N+lx/PWMaT8ORgVFGou4WHA3+fLxFqXGOzs9SiMD8BNzO
	 a4EW7jCVEOstw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2195A605F4;
	Wed,  2 Apr 2025 21:18:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743621524;
	bh=M2JF6JNwewrfGe73f8c2ZUcID5NoSrPFhaz8S0huJno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqYv92psEyK59ZGrVPrupF6siwBRiPx4kwYhi2blYU1zG6lwHPLE6r5A4nXcNtvvr
	 RCEvXBZJCp/HzAXHmfGbgw41Wn/hzk3xRoCCDhOopCO4VBFuOj+T9GrdUJhkJWG4eO
	 8z27I0XV/xD7JflQbRYoMSZPQTJ6sOxhryuvTKknxV8RlQGQu9DypqfD3cx9kp18D/
	 wez1Q2XlGH75qKDV98Km0b2K23TDtTG8rXXZ00X/tey9VRwkQ8tt2AHudWzfgQ+N60
	 k/feRtyEFHvEqE+lNpONjBAZu6HaniVG/OOFXQY00a4GmfElSWGAFyuEF8YrN1xz8D
	 nHFWpkG1h2hWg==
Date: Wed, 2 Apr 2025 21:18:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lin Ma <linma@zju.edu.cn>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	lucien.xin@gmail.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nft_tunnel: fix geneve_opt type confusion
 addition
Message-ID: <Z-2NkQkl18OSJJuG@calendula>
References: <20250402170026.9696-1-linma@zju.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250402170026.9696-1-linma@zju.edu.cn>

Hi,

On Thu, Apr 03, 2025 at 01:00:26AM +0800, Lin Ma wrote:
> When handling multiple NFTA_TUNNEL_KEY_OPTS_GENEVE attributes, the
> parsing logic should place every geneve_opt structure one by one
> compactly. Hence, when deciding the next geneve_opt position, the
> pointer addition should be in units of char *.
> 
> However, the current implementation erroneously does type conversion
> before the addition, which will lead to heap out-of-bounds write.

Patch LGTM, I can take it through nf.git, I am preparing a pull
request now.

Thanks.

> [    6.989857] ==================================================================
> [    6.990293] BUG: KASAN: slab-out-of-bounds in nft_tunnel_obj_init+0x977/0xa70
> [    6.990725] Write of size 124 at addr ffff888005f18974 by task poc/178
> [    6.991162]
> [    6.991259] CPU: 0 PID: 178 Comm: poc-oob-write Not tainted 6.1.132 #1
> [    6.991655] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [    6.992281] Call Trace:
> [    6.992423]  <TASK>
> [    6.992586]  dump_stack_lvl+0x44/0x5c
> [    6.992801]  print_report+0x184/0x4be
> [    6.993790]  kasan_report+0xc5/0x100
> [    6.994252]  kasan_check_range+0xf3/0x1a0
> [    6.994486]  memcpy+0x38/0x60
> [    6.994692]  nft_tunnel_obj_init+0x977/0xa70
> [    6.995677]  nft_obj_init+0x10c/0x1b0
> [    6.995891]  nf_tables_newobj+0x585/0x950
> [    6.996922]  nfnetlink_rcv_batch+0xdf9/0x1020
> [    6.998997]  nfnetlink_rcv+0x1df/0x220
> [    6.999537]  netlink_unicast+0x395/0x530
> [    7.000771]  netlink_sendmsg+0x3d0/0x6d0
> [    7.001462]  __sock_sendmsg+0x99/0xa0
> [    7.001707]  ____sys_sendmsg+0x409/0x450
> [    7.002391]  ___sys_sendmsg+0xfd/0x170
> [    7.003145]  __sys_sendmsg+0xea/0x170
> [    7.004359]  do_syscall_64+0x5e/0x90
> [    7.005817]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [    7.006127] RIP: 0033:0x7ec756d4e407
> [    7.006339] Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 faf
> [    7.007364] RSP: 002b:00007ffed5d46760 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
> [    7.007827] RAX: ffffffffffffffda RBX: 00007ec756cc4740 RCX: 00007ec756d4e407
> [    7.008223] RDX: 0000000000000000 RSI: 00007ffed5d467f0 RDI: 0000000000000003
> [    7.008620] RBP: 00007ffed5d468a0 R08: 0000000000000000 R09: 0000000000000000
> [    7.009039] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> [    7.009429] R13: 00007ffed5d478b0 R14: 00007ec756ee5000 R15: 00005cbd4e655cb8
> 
> Fix this bug with correct pointer addition and conversion.
> 
> Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---
>  net/netfilter/nft_tunnel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index 681301b46aa4..2df4b2a02f27 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -341,7 +341,7 @@ static const struct nla_policy nft_tunnel_opts_geneve_policy[NFTA_TUNNEL_KEY_GEN
>  static int nft_tunnel_obj_geneve_init(const struct nlattr *attr,
>  				      struct nft_tunnel_opts *opts)
>  {
> -	struct geneve_opt *opt = (struct geneve_opt *)opts->u.data + opts->len;
> +	struct geneve_opt *opt = (struct geneve_opt *)(opts->u.data + opts->len);
>  	struct nlattr *tb[NFTA_TUNNEL_KEY_GENEVE_MAX + 1];
>  	int err, data_len;
>  
> -- 
> 2.17.1
> 
