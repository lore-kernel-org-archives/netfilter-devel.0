Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011FB125D0;
	Tue,  3 Feb 2026 03:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770088745; cv=none; b=SLspEuiHK1uMBxxMuOiR2+Io1yEMA1traM1ITDsGq8dPSoTVxhuQ7FufB62V6Q6ctIIB0bDyZcDLqoulAvXkxP+hIl3wVgtk5vL0JpYYVMxNwp0eyYJURRgsxWPnKOVOp8BJWyjsF/BmZ2Yp7aO3No9EZsQ9MLB2Y2HpuorVics=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770088745; c=relaxed/simple;
	bh=Xr5RciCKSPOhKRDLSKFKOQYUONb33o2QlFkL8N/5UFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHudgE4FDejkJwyXyCbOX1yDFwJs6jubiP1NdTLv1w+pG6GPGmlJYtTCOostgRwH9oROpE1TK6PV7qIkOEEmGk2Td28QjCQfeAF5Lnao59VuVLg7mnaXl/eak5CGU/q0sZPNsRGNyk3kMTRbeE9vXpC2MLLWoxNPTmmdZuslNSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZWQJBQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZWQJBQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAE4C116D0;
	Tue,  3 Feb 2026 03:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770088744;
	bh=Xr5RciCKSPOhKRDLSKFKOQYUONb33o2QlFkL8N/5UFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZWQJBQ9nj91DYGslbsVFu6rfgkRfxM5HQBNWhMZa/s5DRoXbTFQoZyn4oqsYQ5/y
	 +eHnnn++9dcWkMgOt3kAg8Xp2+h1faK8K4GtDvnGcu/Ov9S3IiW78AhLUjnyLHjvd9
	 /p1P1vKqrNNjrqmbFwi5FofiYuk/iVk/t8r3+ph607NCofq79ovJ7e9EukJ9JoOeyz
	 InwnyvKoYfwL+W7p/CxfiuHWzJogrc4p49erVpC5HQiNGSFmwCE04kZA9wWV+5jRFE
	 QaOA3gqlRnXjWbEgDX0rHlnR5xEpbDP7IuSGCh2mgKM6nUroKr5QLE6nEOQExWr0Xx
	 HzE1W/PYlDbMg==
From: Jakub Kicinski <kuba@kernel.org>
To: one-d-wide@protonmail.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	pablo@netfilter.org,
	coreteam@netfilter.org,
	fw@strlen.de,
	donald.hunter@gmail.com
Subject: Re: [net-next,v7,3/5] doc/netlink: nftables: Update attribute sets
Date: Mon,  2 Feb 2026 19:19:02 -0800
Message-ID: <20260203031902.934664-1-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202093928.742879-4-one-d-wide@protonmail.com>
References: <20260202093928.742879-4-one-d-wide@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
doc/netlink: nftables: Update attribute sets

This commit adds new attribute sets (log-attrs, numgen-attrs, range-attrs,
compat-target-attrs, compat-match-attrs, compat-attrs), adds missing
attributes and checks, and fixes byte-order annotations for the nftables
netlink specification.

> diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
> index f15f825cb3a1..2ddf89c70124 100644
> --- a/Documentation/netlink/specs/nftables.yaml
> +++ b/Documentation/netlink/specs/nftables.yaml

[ ... ]

> +  -
> +    name: range-attrs
> +    attributes:
> +      # Mentioned in net/netfilter/nft_range.c
> +      -
> +        name: sreg
> +        doc: source register of data to compare
> +        type: u32
> +        byte-order: big-endian
> +        enum: registers
> +      -
> +        name: op
> +        doc: cmp operation
> +        type: u32
> +        byte-order: big-endian
> +        enum: range-ops
> +        checks:
> +          max: 256

Should this be max: 255? Looking at nft_range_init() in net/netfilter/nft_range.c,
the kernel uses nft_parse_u32_check(tb[NFTA_RANGE_OP], U8_MAX, &op), where U8_MAX
is 255. This spec would allow 256 which the kernel rejects with -ERANGE.

[ ... ]

> +  -
> +    name: compat-target-attrs
> +    header: linux/netfilter/nf_tables_compat.h
> +    attributes:
> +      -
> +        name: name
> +        type: string
> +        checks:
> +          max-len: 32
> +      -
> +        name: rev
> +        type: u32
> +        byte-order: big-endian
> +      -
> +        name: info
> +        type: binary
> +  -
> +    name: compat-match-attrs
> +    header: linux/netfilter/nf_tables_compat.h
> +    attributes:
> +      -
> +        name: name
> +        type: string
> +        checks:
> +          max-len: 32
> +      -
> +        name: rev
> +        type: u32
> +        byte-order: big-endian
> +        checks:
> +          max: 255

Should compat-target-attrs also have checks: max: 255 for its rev field? The
kernel's nft_target_policy uses NLA_POLICY_MAX(NLA_BE32, 255) for NFTA_TARGET_REV,
same as compat-match-attrs, but compat-target-attrs rev field above is missing
this check.
-- 
pw-bot: cr
