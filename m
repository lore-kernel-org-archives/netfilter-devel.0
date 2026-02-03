Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3248721FF26;
	Tue,  3 Feb 2026 03:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770088748; cv=none; b=ovm8HBZMhWLgKMAvWfSBW5o4atfE8LT+NYaCq2TIDilAzLHDvvMxUMHsRaIYYFYdNlcoB3AuxzJKw6XVEFn1KTZ4LtMQonX+owecBoVmRTaXHWkShdgti2Jz6XkzkNzTsMQ8BRdXeYguBDKBjrqyqyKNUnuOzF+rNQv0Yo7MKrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770088748; c=relaxed/simple;
	bh=nuqozKrDAIqLwoXajcEmvhVdQw4xPEyDlPCONhRnhSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCgevnZVo0SMzHo7/b4h/lnGpFzgN05gmVPIBmcl/v5TyrDPwAlmKr+RCMF/cHs0CSOEZrFB/KZO65ZHqSzbH5kxbktY2UK32OsEdOWN11fBERJZTFuJVpChW03QvsHFqh24sScT2rL8EXxJo8fpihxMvCjLUHPpzGn6rceRoI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UF1oV/I9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UF1oV/I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131E0C16AAE;
	Tue,  3 Feb 2026 03:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770088747;
	bh=nuqozKrDAIqLwoXajcEmvhVdQw4xPEyDlPCONhRnhSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UF1oV/I9GrJ6Crma6aGPU7I2UWJPd5C6hRlTy/I9FW3FBRziWeEmNMpKU6+8giLi6
	 0G6HdMo3HwDbo1WSwDR5McV8FVwjyPUs2FterWtR7wqfEV3K2gXouArwB+DkbQvG74
	 qj739DLTrBq6QdsM5nX0400CLPtHKBzVaoao0+ILROsMlM9mDiiLt0T95hn2FGYfdM
	 84gxsXqBiEXeOIYq2W6bNt2G3FqQHtThW8EB6PP2Sqcd6OlzxaOCzmO3i8biImwwZB
	 gMrHP336J5An/b7/FaiEZPWdxv1UXgGJKbD7p3qER/IouCrYwhe1DiDWDYiblXgq6P
	 kGKwR3dVg/2GA==
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
Subject: Re: [net-next,v7,5/5] doc/netlink: nftables: Fill out operation attributes
Date: Mon,  2 Feb 2026 19:19:05 -0800
Message-ID: <20260203031905.934693-1-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202093928.742879-6-one-d-wide@protonmail.com>
References: <20260202093928.742879-6-one-d-wide@protonmail.com>
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
doc/netlink: nftables: Fill out operation attributes

This commit fills out the operation attributes for 31 nftables netlink
operations, documenting which attributes are used in request and reply
messages based on kernel implementation.

> diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
> index ced567e7a521..5a9d8727a8cb 100644
> --- a/Documentation/netlink/specs/nftables.yaml
> +++ b/Documentation/netlink/specs/nftables.yaml

[ ... ]

> @@ -1612,7 +1626,23 @@ operations:
>          request:
>            value: 0xa03
>            attributes:
> +            # Mentioned in nf_tables_newchain()
> +            - table
> +            - handle
> +            - policy
> +            - flags
> +            # Mentioned in nf_tables_updchain()
> +            - hook
>              - name
> +            - counters
> +            - policy
> +            # Mentioned in nf_tables_addchain()
> +            - hook
> +            - name
> +            - counters
> +            - userdata
> +            # Mentioned in nft_chain_parse_hook()
> +            - type

Does this attribute list contain duplicates? The list shows:
- 'policy' twice (lines 1632 and 1638)
- 'hook' twice (lines 1635 and 1640)
- 'name' twice (lines 1636 and 1641)
- 'counters' twice (lines 1637 and 1642)

While the comments indicate these attributes are referenced by different
kernel functions, the YAML specification should document the unified netlink
interface where each attribute appears at most once per message. Having
duplicates may confuse code generation tools that parse this specification.

Should each attribute be listed only once, with implementation details
documented separately if needed?

[ ... ]

> @@ -1717,7 +1798,24 @@ operations:
>          request:
>            value: 0xa09
>            attributes:
> +            # Mentioned in nf_tables_newset()
> +            - table
>              - name
> +            - key-len
> +            - id
> +            - key-type
> +            - key-len
> +            - flags
> +            - data-type
> +            - data-len
> +            - obj-type
> +            - timeout
> +            - gc-interval
> +            - policy
> +            - desc
> +            - table
> +            - name
> +            - userdata

Are there duplicates in this attribute list? Looking at the newset
operation's request attributes:
- 'table' appears twice (lines 1802 and 1816)
- 'name' appears twice (lines 1803 and 1817)
- 'key-len' appears twice (lines 1804 and 1807)

In netlink messages, attributes are identified by their type ID, and each
should appear at most once in the specification. Should these duplicates
be removed?
