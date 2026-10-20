Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510717;
	b=oC47fnV5F1ST3emaOr++Sn1Qr2+THMgO87MX+H+ioMy/u3tENI9WadVt+WeK4v4z/9TZ
	 tufKRO4227LiE+h2Ihg4bZ9iyZcBKuNwBEvyzfQYauQwH1AvVf5WApohwQHOA+wvPzOiV
	 2pu+cpio4fhy9cA/QWO2/R79CmleIB/GWQ+7qP5AYssoxN+uR6Wo9fYCjJbMJ0DbckWu2
	 dAaPhArCGKO5xE6ePv4ocqXugyhqVl62DhM6uEFVkFpy/OauIqiC5i11mbn6PQCYcUQqC
	 z8blUCcoyd0n16ryTC/Q4XUQFr58iNtV0WhvEZySD5O1XCriw2egqFDtx+p/VqPhLHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510717;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=xMhauGuOviU6sajrjNwmfyby/CGvunKqOWW0fHPH6e4=;
	b=esYBBvYUzBgbDYShBjwlVJnvAYFgc0bjJ6YcLikfaRe1QlIEDNy0RApWGI2XFrtt6WZB
	 SGhW7TzoLBd+V2bdLy8959gRFSnzdL/VV0BzWlKYFc4qFmYl7tEuy7hdUOT1v3AYwyOoi
	 gK7XSvH7wPmPhlERYKmfY7vVPb+h9j9cELYdVMSP3XuvcaLS104ldkvaahAe3EgRUgMfi
	 wu/FzT2qg26gnwk3fk2PYofYbhD1OqPm8SBYBGFEsPy7rD9XkQoVq+vo6pwR/hYhhD3RZ
	 P5D9uoCLhs9zwB1AQq9t4m1si0pNZNu1j3difR7hCr8GOJjm/u5tHIFzEszR2aZFUbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54CC606A323;
	Tue, 20 Oct 2026 15:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E741F000C4;
	Tue, 20 Oct 2026 15:38:36 +0000 (UTC)
Subject: Re: [PATCH net 08/10] netfilter: xt_dccp: handle reserved options as
 single-byte
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 20 Oct 2026 15:38:06 +0000
Message-ID: <179251068646.3135.16276902372052104830@kernel.org>
In-Reply-To: <20261019150249.1879516-9-pablo@netfilter.org>
References: <20261019150249.1879516-9-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message lists CONFIG_NETFILTER_XTABLES_LEGACY as a
  prerequisite for the bug.

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but
  dccp_find_option() in net/netfilter/xt_dccp.c does not validate multi-…

--

netfilter: xt_dccp: handle reserved options as single-byte

This commit changes dccp_find_option() so that every DCCP option number
up to DCCPO_MAX_RESERVED is treated as a single-byte option. Before, only
Padding and Mandatory were. The old behaviour read the byte after a
reserved option as a TLV length, which could skip a later option and
invert an XT_DCCP_OPTION rule result.

> Treat every option up to DCCPO_MAX_RESERVED as single-byte, matching the
> protocol definition.  Triggering requires
> CONFIG_NETFILTER_XTABLES_LEGACY, CONFIG_NETFILTER_XT_MATCH_DCCP, an
> option-based rule, and remote protocol-33 reachability.

[Severity: Medium]
Is CONFIG_NETFILTER_XTABLES_LEGACY actually needed to trigger this?

In net/netfilter/Kconfig, NETFILTER_XT_MATCH_DCCP sits inside the
if NETFILTER_XTABLES block and depends only on NETFILTER_ADVANCED:

config NETFILTER_XT_MATCH_DCCP
	tristate '"dccp" protocol match support (DEPRECATED)'
	depends on NETFILTER_ADVANCED

NFT_COMPAT depends only on NETFILTER_XTABLES:

config NFT_COMPAT
	depends on NETFILTER_XTABLES

nft_match_select_ops() in net/netfilter/nft_compat.c looks up the
registered "dccp" match by name:

	match = xt_request_find_match(family, mt_name, rev);

The nft_compat packet path then reaches the same parser:

__nft_match_eval()
  match->match(skb, &xt)
    dccp_mt()
      match_option()
        dccp_find_option()

So iptables-nft setups without legacy tables support seem to have the
same reserved-option bypass. The fix in the shared helper covers both
frontends. Only the stated trigger conditions look wrong.

Could the commit message drop CONFIG_NETFILTER_XTABLES_LEGACY from the
prerequisites, or list CONFIG_NFT_COMPAT as an alternative? That way
backport and security triage won't skip nft-based systems.

> diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
> index 3db81e041af9..23a4e3e8df7d 100644
> --- a/net/netfilter/xt_dccp.c
> +++ b/net/netfilter/xt_dccp.c
> @@ -62,7 +62,7 @@ dccp_find_option(u_int8_t option,
>  			return true;
>  		}
>  
> -		if (op[i] < 2 || i == optlen - 1)
> +		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
>  			i++;
>  		else
>  			i += op[i + 1] ? : 1;

[Severity: Low]
This isn't a bug introduced by this patch, but should dccp_find_option()
also reject multi-byte option lengths below 2?

For a type of 32 or above, a length byte of 0 or 1 moves i forward by one
byte. The next loop iteration then reads the length byte as an option
type.

For example, with options {32, 1, 0, 0} and --dccp-option 1:

  i = 0: op[0] == 32, no match, i += op[1] (1)
  i = 1: op[1] == 1, matches, returns true

No Mandatory option is actually present here. A {32, 0, ...} sequence
gives a phantom match for option 0 the same way.

nft_exthdr_dccp_eval() in net/netfilter/nft_exthdr.c parses the same
option space. It stops with no match on such lengths:

	if (buflen < 2)
		goto err;

	len = bufp[1];

	if (len < 2)
		goto err;

So xt_dccp and nft exthdr dccp still give different answers for the same
malformed packet. Since the length byte is below 2, the phantom match
can only be option type 0 or 1. This patch brings the single-byte
classification in line with nft_exthdr but leaves this length check
difference in place.

Would it make sense to stop parsing (or treat it as no match) when
op[i + 1] < 2, as nft_exthdr_dccp_eval() does?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
