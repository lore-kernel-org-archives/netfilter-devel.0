Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793523482;
	b=i6kI9mNxZ4nNLwhY75Q47WNSbq2I+HQNN+z5hDtp1FooFDr5AnU5cTOgVm2hIMJzlsCB
	 ZG4kpyKr0duwkFgciPQyUUkmmQORPnfL+J+n0kw16WQxYaixhMLgEZUD3v5PDYu2ig0Gx
	 7yayw/PolfxyMYM4Pn2TW+Wb2Qa8VVAhvsnNoQ+Kzi7Ifq5OYyJubuyRHdkakh1D4kR8d
	 4YU1jRhO7xMWtZ9fW95HLfZJIBDV5xkq+ChVZmAgGvapIhb1EECrffQRhhpAzut0ijDzA
	 Wt2rezYGkd+o70noBApzT8H0gauTaKl98Xdr8GeFE+h6BB3t5qdE3QVOWU/p+HR8RVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793523482;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=JazUQmysvfz25hGlDENwnPUbFOn1chSV8foXgSqZs7Q=;
	b=pye9oOawRg7x7teLflksrNb6os3BiPrI2afB/ddLwZ+/r7f3mzZWC2aD+K6ufLAuU1ev
	 9NFNkCHmBesF4Nv5+B7IQTTD7NwQ6TIWrn5ljfNNpMuFBzsT6+KhsJcw1PPdBan6sxcuc
	 DVsQ9pyjUW/9Du1wTgvmiPEjdD6Vqm2pSdGl8MYIE1MARAaX0LxDzSZmG7v3maN4hwDWF
	 IWp9FcfboAlFH/CZaUjodrMt65U4d2jVdU8bn3mhUkpZPwdSFm/fxnIkVyEFEpyB4KSpi
	 /iC4pKm9Ob3NcymC/5aca5oU6zk57gqs+u1+09nmM8kLZMDHqzj3+eqa0ZiovhcvzBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iGzixnac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F22E606A324
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iGzixnac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493DA1F000C1;
	Sun,  1 Nov 2026 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793523480;
	bh=JazUQmysvfz25hGlDENwnPUbFOn1chSV8foXgSqZs7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iGzixnacmt8jP5/HWuDs22KkugbQx25YQLehO8FQpvD/W1dh/SB/QWeeWv2pZw4QX
	 waLtBf817rwaOP6m825YbkTlHwX4bof1JoNAVnqzwV3ylMasWlSsut67EqEmC+KHK8
	 sHmZc2x5OoKc8vS2UXhMthR9altvcX04yX3XBxBA=
Date: Sun, 1 Nov 2026 09:57:53 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?5bKp5qmL5ra85LuL?= <ryosuke@ikotaslabs.com>
Cc: pablo@netfilter.org, fw@strlen.de, security@kernel.org, phil@nwl.cc,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_reasm: restore IPv6 nhoff
 after reassembly
Message-ID: <2026110155-twisting-autism-009a@gregkh>
References: <CAN2NGG5Y_A4ZcH3Wh8A8HeF42zOR=HnUpKYH7zxi7DJeqhwwjQ@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN2NGG5Y_A4ZcH3Wh8A8HeF42zOR=HnUpKYH7zxi7DJeqhwwjQ@mail.gmail.com>

On Sat, Oct 31, 2026 at 08:45:52PM -0500, 岩橋涼介 wrote:
> >From 8197824cf0c745a032f6deddfc19fd62302c804e Mon Sep 17 00:00:00 2001
> From: Ryosuke <ryosuke@ikotaslabs.com>
> Date: Sun, 1 Nov 2026 10:43:10 +0900
> Subject: [PATCH nf] netfilter: nf_conntrack_reasm: restore IPv6 nhoff after
>  reassembly

This doesn't all need to be here, please use 'git send-email' or b4 to
send patches.

> 
> nf_ct_frag6_reasm() removes the fragment header and resets the transport
> header, but unlike ip6_frag_reasm() it leaves IP6CB(skb)->nhoff set to
> its pre-reassembly value.
> 
> Subsequent IPv6 local delivery consumes this stale next-header offset
> alongside the updated transport header. As a result, the two cursors
> can point to different protocol boundaries after conntrack
> defragmentation, causing later processing stages to interpret a
> different transport protocol than the one evaluated by conntrack and
> nftables.
> 
> Restore IP6CB(skb)->nhoff from the saved pre-fragment next-header offset
> after reassembly, matching ip6_frag_reasm().
> 
> Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5
> Signed-off-by: Ryosuke <ryosuke@ikotaslabs.com>

Real name please.

> ---
>  net/ipv6/netfilter/nf_conntrack_reasm.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c
> b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 599c49b..ab06b05 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -321,6 +321,7 @@ static int nf_ct_frag6_reasm(struct frag_queue
> *fq, struct sk_buff *skb,

Your patch is line-wrapped and can not be applied :(

thanks,

greg k-h
