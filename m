Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.10.43.109
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795887654;
	b=ArnUjrjXueBI1HwAmaXCHqSgsZ+Hu+toOprCuu09oac1fry85skdqyyr7lJiD+Rb9Vsq
	 nBfeb8mc9s9WPI9q8ipu9OxZwuUkrA2ffoXSBA9rFy352y3qHZONk1dzFNUsL5ffIcCZm
	 d9VC6drvyrhwnjRScEP/5dUjq/zhrTYfTC0q7qvoZSmLLXSvhbla2SK96BUCFD+JpCS1v
	 L2YCiUWF8Ja1LnCbGvd8CVkKZn3BRswv0TxyCJVC++pFqDRVlKYbCkkk5AfjgOk8Z4fzr
	 4nWawmdekiweJ4FWeRmqm8kWsb/XrDFywqhPoPd/vsA4QFkuX/wkMD1lsudiJYMljAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795887654;
	h=DMARC-Filter:DKIM-Signature:Received:MIME-Version:Date:From:To:Cc:
	 Subject:In-Reply-To:References:User-Agent:Message-ID:X-Sender:
	 Content-Type:Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=x4U0b9+L6gBCrUNjs4Fn+csOwjTz5exp/gjJ8ROk324=;
	b=w4fbJG7Wxkk64wN5JvEOdK4ZshVXVAnCftH06YSBhiE5PHemLNcP9vguopsBSjGz8wyC
	 TCFI1OCuTGO0hL0f1e/SRCqPS35MEqUA6pP1/P9s1gE5x+uRmlPn7WcSbBC4ZSSa0+CJh
	 r4kjS7Dqog4oRli3oGOK9YBu0l/OLOt+ttKrrlL49B2FMH0KQADntNcK9+V9EjP34Kc0m
	 7DlZnJ8i1JKrXpHlIQtoNP2NPh3UJuv2YT0Qwh9Tnejb+OlkupvVY9NpgkWyMSlrdJyta
	 xN2ZlnlrxhXjczUlHQiVmAlrcnE0orwCRCR2tuMhUFCcJwku1Gu3jnB44All9PXv11Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=saturumah.net;
	spf=pass smtp.mailfrom=saturumah.net;
	dkim=pass header.d=saturumah.net header.i=@saturumah.net header.a=rsa-sha256 header.s=default header.b=tC6Dp5Dh;
	arc=none smtp.remote-ip=202.10.43.109
Received: from jembayan.satu.rumahweb.net (jembayan.satu.rumahweb.net [202.10.43.109])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7C4606A321
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2026 17:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E7C4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=saturumah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=saturumah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=saturumah.net header.i=@saturumah.net header.a=rsa-sha256 header.s=default header.b=tC6Dp5Dh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=saturumah.net; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=x4U0b9+L6gBCrUNjs4Fn+csOwjTz5exp/gjJ8ROk324=; b=tC6Dp5DhrPeC
	hE7PGLcpIRFWt+P43bYE/evKqYmCfInHBsxcG6OlUXhoAks6w5U1NobkPXJrjRMId386anBuLK9wb
	9mpdmjgZWUxZKO9yVd91Hg8o/1byXYqKoiQQe4TWOnp/kChNUbCPPX+IxieOvN21O1Yc+K49QLS0U
	LI89sxJQmpdBlZIYnaOzP7DW2JKmWaWMWqM8lY7AGaws8J4tVvtI7mLjm0Ruy5bj0XYpUiHlKczZu
	uqs3zW0i4vjqvV9pTpitDjftRqClNeyUVOChoTM4KUIE+60mrzkSaoLhl0h/IVurpux6NPy8WSfcv
	R+hHjgOsAm6qM4AByaHcSg==;
Received: from [::1] (port=56540 helo=jembayan.iixcp.rumahweb.net)
	by jembayan.iixcp.rumahweb.net with esmtpa (Exim 4.100.2)
	(envelope-from <jack@saturumah.net>)
	id 1xXMPk-0000000AcTp-1s76;
	Sun, 29 Nov 2026 00:40:44 +0700
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 29 Nov 2026 00:40:42 +0700
From: jack@saturumah.net
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: xt_nat: drop packet when conntrack is
 missing or invalid
In-Reply-To: <awlH7zpDVGHdlDv7@strlen.de>
References: <CALZdHNroZj41WOBd9g4+csZ91h_yEzHP496Sm_esQypv-mztVA@mail.gmail.com>
 <awlH7zpDVGHdlDv7@strlen.de>
User-Agent: Roundcube Webmail/1.6.20
Message-ID: <e31208abf2979545287f53ffb70a7c80@saturumah.net>
X-Sender: jack@saturumah.net
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - jembayan.iixcp.rumahweb.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - saturumah.net
X-Get-Message-Sender-Via: jembayan.iixcp.rumahweb.net: authenticated_id: jack@saturumah.net
X-Authenticated-Sender: jembayan.iixcp.rumahweb.net: jack@saturumah.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Pada 2026-11-27 16:05, Florian Westphal menulis:
> Jack Satu Rumah Net <Jack@saturumah.net> wrote:
>> Hello Netfilter maintainers,
>> 
>> When an SNAT or DNAT target in net/netfilter/xt_nat.c processes a 
>> packet
>> where nf_ct_get() returns NULL or ctinfo is outside the allowed 
>> states,
>> WARN_ON() only logs a warning and still calls nf_nat_setup_info(),
>> resulting in a NULL pointer dereference in nf_ct_net(ct).
> 
>> Drop the packet with NF_DROP after WARN_ON_ONCE() when conntrack is
>> missing or ctinfo does not match the target's allowed states across
>> SNAT and DNAT targets (v0, v1, v2).
>> 
>> Signed-off-by: Jack Satu Rumah Net <jack@saturumah.net>
>> ---
>> Observed on Linux v6.12.119 (commit
>> e2e4b92c2b2a3ae78423cb343951cb5d2241b405)
>> with CONFIG_NF_NAT=y when packets marked NOTRACK in the raw table hit 
>> a
>> SNAT or DNAT rule.
> 
> You need to figure out why and how such packets end up in xt_nat
> frontend code.
> 
> skb with no conntrack must not ever end up in nat frontend code
> to begin with.
> 
> nf_nat_inet_fn() returns NF_ACCEPT if ct is NULL, so I have no idea
> how what you describe can happen.

Florian,

You are right, and I retract the patch. I traced the actual reachability 
on my tree (v6.12.119, commit e2e4b92c2b2a) and the vulnerable path you 
described is fully closed. Two facts from the tree:

1. `xt_nat_target_reg[0]` (revision 0) has `.family = NFPROTO_IPV4`. 
Instantiating it from a bridge-family rule via `nft_compat` returns 
`-EOPNOTSUPP` because `xt_request_find_target(NFPROTO_BRIDGE, "SNAT", 
0)` finds no matching registration.

2. Revisions 1 and 2 use `xt_nat_checkentry()`, which rejects every 
family outside `{ NFPROTO_IPV4, NFPROTO_IPV6, NFPROTO_INET }` with 
`-EINVAL`:

```c
switch (par->family) {
case NFPROTO_IPV4:
case NFPROTO_IPV6:
case NFPROTO_INET:
         break;
default:
         return -EINVAL;
}
```

So there is no way to reach `xt_snat_target_v0/v1/v2` with `ct == NULL` 
through `nft_compat` from an unsupported family. `nf_nat_setup_info()` 
still dereferences `nf_ct_net(ct)` without a NULL check, but the only 
path to it would be through a family that checkentry refuses to install.

I confirmed this with a bridge-family `nft_compat` rule using `xt target 
SNAT`. The kernel rejects the batch with `-EOPNOTSUPP` (rev 0, family 
field mismatch) or `-EINVAL` (rev 1/2, checkentry guard). No KASAN 
splat, no NULL dereference.

My original commit message was also wrong about the ingress path. 
NOTRACK packets do not reach the NAT target through the standard 
iptables NAT table either, because `nf_nat_inet_fn()` returns 
`NF_ACCEPT` for `ct == NULL`. I was chasing a symptom whose root cause I 
had misidentified.

Patch withdrawn. Thanks for the correction — it forced me to actually 
read the reachability chain, which was educational.

Jack
