Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213233;
	b=nvrji3ywaE7C3Z3dDUDRtDjm0LMIj/P9THyWYjQM/hLswigUJESNwFWEA5PqWwb/u6jM
	 iHWa/lt4yGzAKpJfJDlN+THGYjyBhhHohc4+1TmYLhVedw8MMFc/TrkVt22gVZ+N/tW93
	 CrwPgpFWCayURNfPg135XKJKQY0b3zKDWYebHgbWFchVXkATuVgirHuWh+dWPk+vJgkFz
	 WiHNuOv1hHTpA/kHrWpkmz+Q4RoXH8mXSpml2xudl95lux2d3P0s7BszEUlJZyQqTv3ik
	 XHeMud0//dPDid+mmnmKjHmBuXC1HKtlqzwqzG1m6pAnE2r6s8JT/0vqzfjwXcHFVpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213233;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=UDd0Zg6CUretoFYA67K2u0vOJ5JoLZIvq3TwMbsLA/g=;
	b=IofmZfaJIVSyNjDGdpFRL0tTbm6euUFWIajIPtBYk/pNCCEzt5JNOqj1FXPMs5gNdWYt
	 TGIwCDvY+xLJ8OBufMxni5x3dIE1W0jmtNLrVHnEN+nd4E+R2DZFGW0zYw08TphEpxRe1
	 uwAiZRPB4dF/m7KSoKE7O0s6nYkB6YEYXorIbdJToYWFBciMsBCcF//eiVaC/QKJ8LGGV
	 JzyU+y7KXhOr6LjmAe3I+5tzQJktW+DezPJffaFD9wrZ2Anpku6CXaZPWz5TjrbTW7PwS
	 IrU+x07ehhGepIFGak5HkbVeSllZa7ctJNRUX28tsQagbhzaRzkYnO60pick3QQTM3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cE/8KthE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F4C606A326;
	Mon,  9 Nov 2026 08:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cE/8KthE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB881F0089F;
	Mon,  9 Nov 2026 08:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794213233;
	bh=UDd0Zg6CUretoFYA67K2u0vOJ5JoLZIvq3TwMbsLA/g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cE/8KthEUJtk0LewDEGnN0ewmMPUVYUelvP+s0qv4QA7UIjX4h/v/r0ez56cA3r7i
	 SBFUNy0NosBcg5c9LquPAbY+nTEsp5Ur3v3JJjrcuf2OpKBtPkiLNiLoQAlGIn7RoX
	 nmyq0AH3oKDZ8GboW9SFOIWdgs6mqXR2JztyPdf4Dptt/hwB6twsS7sXF4xe1Bw5dE
	 Szmokk+6tyoLsW4K4sDgO16F9Q2+3au8Y9qc1Rty0At7GEXyewFbfy6M3fPj2NM4yG
	 gZP94gmXyHnZo8Z+xp5OYEnHiS5yFDh2N1VyJayDgUIqtwjtCPdLLpfHHw2qMK4WYB
	 rJgw8OesaKwMQ==
Subject: Re: [PATCH net] netfilter: xt_dccp: reject short option lengths
From: netdev-bot+sashiko@kernel.org
To: shawnq1@163.com
Cc: pablo@netfilter.org, tjdqudcks0424@naver.com, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 horms@kernel.org, coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 09 Nov 2026 08:33:51 +0000
Message-ID: <179421323164.994134.2385901971109672793@kernel.org>
In-Reply-To: <20261105081735.749379-1-shawnq1@163.com>
References: <20261105081735.749379-1-shawnq1@163.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch turns option lengths 0 and 1 into a hotdrop instead
  of a no-match, and the commit message does not say so.
- [Low] The commit body is an email cover letter pasted into the
  permanent changelog.
- [Low] Whether xt_dccp drops a malformed option TLV now depends on which
  malformed form it is and on option order.

--

netfilter: xt_dccp: reject short option lengths

This patch changes dccp_find_option() in net/netfilter/xt_dccp.c so that
a multi-byte DCCP option with a length byte of 0 or 1 is treated as
invalid. The walker previously advanced by one byte and could read the
length byte as the next option type. With this patch it sets hotdrop and
stops.

Link: https://lists.openwall.net/netdev/2026/10/20/477

> Hello,

[Severity: Low]
This isn't a bug, but the changelog reads like an email cover letter that
was pasted in as the commit body. It opens with "Hello,".

It also includes reproduction notes that would usually go below the ---
line: QEMU and gcc versions, gist URLs, tested SHAs, and build and boot
steps.

The technical explanation ends mid-sentence:

> The option walker should reject a TLV length below two before advancing:
>
> Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")

Nothing follows the colon. The message also doesn't say what the code now
does with a length of 0 or 1, which is to hotdrop the packet.

> diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
> index 23a4e3e8df7de..e0d7f43749588 100644
> --- a/net/netfilter/xt_dccp.c
> +++ b/net/netfilter/xt_dccp.c
> @@ -62,10 +62,15 @@ dccp_find_option(u_int8_t option,
>  			return true;
>  		}
>  
> -		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
> +		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1) {
>  			i++;
> -		else
> -			i += op[i + 1] ? : 1;
> +		} else {
> +			if (op[i + 1] < 2) {
> +				spin_unlock_bh(&dccp_buflock);
> +				goto invalid;
> +			}

[Severity: Medium]
Is the change from a no-match to a hotdrop intended here?

The goto invalid path sets *hotdrop = true. dccp_mt() passes &par->hotdrop
down through match_option(), and ipt_do_table() then stops rule traversal
and drops the packet, whatever the target or chain policy:

net/ipv4/netfilter/ip_tables.c:ipt_do_table() {
    ...
	} while (!acpar.hotdrop);
    ...
	if (acpar.hotdrop)
		return NF_DROP;
    ...
}

Before this patch, a packet with options {32, 1} just failed the match and
kept going. With this patch it looks like the packet is also dropped in
setups such as these:

- an ACCEPT policy chain with a non-terminal --dccp-option N rule, for
  example LOG or MARK, or a rule in the mangle or raw table

- an inverted rule such as "! --dccp-option 5 -j ACCEPT", which used to
  match {32, 1} or {32, 0} because option 5 is absent

The commit message only describes the DROP policy allow-list case. In that
case hotdrop and no-match give the same result.

nft_exthdr_dccp_eval() handles the same malformed TLV as "option not
present" and does not drop the packet:

net/netfilter/nft_exthdr.c:nft_exthdr_dccp_eval() {
    ...
		if (len < 2)
			goto err;
    ...
err:
	*dest = 0;
}

xt_dccp already hotdrops when doff is shorter than the header, so hotdrop
may be the intended policy. Could the changelog say why hotdrop was chosen
over returning false? Could it also note that the iptables and nftables
DCCP option matches now give different results for these packets?

> +			i += op[i + 1];
> +		}
>  	}

[Severity: Low]
With the new hotdrop, dccp_find_option() now handles malformed TLVs in
different ways. The hotdrop only fires for a length of 0 or 1, and only if
the walker reaches that option before it finds the requested type.

Other malformed forms still end as a plain no-match:

- a length larger than the remaining option area, where
  i += op[i + 1] runs past optlen and the function returns false

- a multi-byte type (above DCCPO_MAX_RESERVED) in the last byte, which
  the i == optlen - 1 branch skips as if it were a single-byte option

Also, the op[i] == option check returns true before any length is checked.
So {32, 1} still matches --dccp-option 32, and {1, 32, 1} matches
--dccp-option 1 without the bad trailing TLV being examined.

Take an inverted rule like "! --dccp-option 5 -j ACCEPT". It would accept
{32, 0xff} and a trailing {..., 32}, but hotdrop {32, 1}, even though all
three are malformed. nft_exthdr_dccp_eval() treats every one of these as
"not present".

None of these cases brings back the false match this patch fixes. Once
lengths are at least 2, the walk stays on TLV boundaries.

Should these malformed forms all be handled the same way?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105081735.749379-1-shawnq1%40163.com
