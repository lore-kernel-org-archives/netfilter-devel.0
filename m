Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E7210E3;
	Sat, 14 Mar 2026 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773504776; cv=none; b=d2LsK8vHhhR2Hprp+159Lcc73emAQG6fkLJGYnuInWvcIRZOA3Cmg/4L/kqF+5dD57+ex5tCOzDxAvxl3VnhSjyHuewddmtFet0wMiGsW4HZWc7wsotUj2KNawMQ4qscvMtGb7JGZ//sEx8lTvsbZ5BdCW3azFQdSNVNf2zVIkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773504776; c=relaxed/simple;
	bh=7sf2uWzMvNSCCtjzHOwj8ITgXe8jBNiCxVKw7yg6T5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9i/r3LXq2iX1QmLxME6cM679sPPFVXRbFiJ9+YMP847o4v9de7irbS3PlBI1kyjsqCQYFOt1H/wVVvH0583QcylzMIVnvm+oBdp3dRoJd/wZA7EdjnnhBhYnHjUoAhLXD6KUNO8TNZ7dUR3BjOt9EDF6qxO8CIX2jSvhHNaRbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkRG+E/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkRG+E/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A99EC116C6;
	Sat, 14 Mar 2026 16:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773504775;
	bh=7sf2uWzMvNSCCtjzHOwj8ITgXe8jBNiCxVKw7yg6T5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkRG+E/J3cl9YBqX/Pm//DHD3LLPk5hBRmxuhBvPehOdkhzcaVnPoiGmnO1RStckE
	 7ypKf/ZY/jOdyu2C+NVERI21jd/aMkt/Wuqt6Pt6RtrxK8lJChVJf5an4O1eE1vchB
	 Jt0r15FBLrkbT1UAZeCzR+Q87pCxAC4vk3Bv/pUSm9OS5gzR6eSjJSTbbvGfuYbGz1
	 YHMu2LC4dR1PTPRiyXn5mEdHkp6XjEX5ETL9+Gx9c2QZfNVGUo0yA77HQKqJOMpbr2
	 qWh4BHEfKwxwe8LK1Nh9sPwac/w1Uut55ijiLMx7oCyBVKmPbM7tzVM3cE8pgU3uVR
	 L0G+XSoei5hvw==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	edumazet@google.com,
	pablo@netfilter.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com
Subject: Re: [net,06/11] netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case
Date: Sat, 14 Mar 2026 09:12:36 -0700
Message-ID: <20260314161236.2454291-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260313150614.21177-7-fw@strlen.de>
References: <20260313150614.21177-7-fw@strlen.de>
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
netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case

This patch adds a boundary check in the CONS case of decode_int() to
prevent reading beyond the buffer after get_bits() returns a length
value. The fix validates that len bytes remain before calling
get_uint().

> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 62aa22a07876..c972e9488e16 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -331,6 +331,8 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
>  		if (nf_h323_error_boundary(bs, 0, 2))
>  			return H323_ERROR_BOUND;
>  		len = get_bits(bs, 2) + 1;
> +		if (nf_h323_error_boundary(bs, len, 0))
> +			return H323_ERROR_BOUND;
>  		BYTE_ALIGN(bs);
>  		if (base && (f->attr & DECODE)) {	/* timeToLive */
>  			unsigned int v = get_uint(bs, len) + f->lb;

This patch fixes the CONS case, but the UNCO case in the same function
has the same vulnerability. In the UNCO case, get_len(bs) can return up
to 0x3FFF (16383 bytes), and the code advances bs->cur by that amount
without checking that len bytes remain:

	case UNCO:
		BYTE_ALIGN(bs);
		if (nf_h323_error_boundary(bs, 2, 0))
			return H323_ERROR_BOUND;
		len = get_len(bs);
		bs->cur += len;
		break;

The check only validates 2 bytes for get_len() itself, not the
subsequent len bytes that will be skipped. Does this need the same fix
pattern?

The decode_bitstr() function has a similar issue. In the SEMI case, it
calls get_len(bs) which can return up to 0x3FFF bits, then advances the
buffer by len >> 3 bytes plus partial bits without checking that
sufficient buffer space exists:

	case SEMI:
		if (nf_h323_error_boundary(bs, 2, 0))
			return H323_ERROR_BOUND;
		len = get_len(bs);
		break;
	}

	bs->cur += len >> 3;
	bs->bit = len & 7;

The check at the top only validates 2 bytes for the get_len() call. The
actual advance at the bottom can be up to 2047 bytes. Should this be
checked as well?

The decode_octstr() function has the same pattern in both the SEMI case
and the default case:

	case SEMI:
		BYTE_ALIGN(bs);
		if (nf_h323_error_boundary(bs, 2, 0))
			return H323_ERROR_BOUND;
		len = get_len(bs) + f->lb;
		break;
	default:		/* 2 <= Range <= 255 */
		if (nf_h323_error_boundary(bs, 0, f->sz))
			return H323_ERROR_BOUND;
		len = get_bits(bs, f->sz) + f->lb;
		BYTE_ALIGN(bs);
		break;
	}

	bs->cur += len;

In the SEMI case, get_len() can return up to 0x3FFF and f->lb is added.
In the default case, get_bits(bs, f->sz) returns an attacker-controlled
value based on field size and f->lb is added. Both cases then advance by
len bytes without checking. The existing checks only validate the bytes
needed to READ the length value, not the len bytes that will be
consumed. Should boundary checks be added after both break statements?

Similarly, decode_bmpstr() (which handles 2-byte character strings) has
the same issue in both the BYTE case and default case:

	case BYTE:		/* Range == 256 */
		BYTE_ALIGN(bs);
		if (nf_h323_error_boundary(bs, 1, 0))
			return H323_ERROR_BOUND;
		len = (*bs->cur++) + f->lb;
		break;
	default:		/* 2 <= Range <= 255 */
		if (nf_h323_error_boundary(bs, 0, f->sz))
			return H323_ERROR_BOUND;
		len = get_bits(bs, f->sz) + f->lb;
		BYTE_ALIGN(bs);
		break;
	}

	bs->cur += len << 1;

After computing len from packet data plus f->lb, the function advances
by len << 1 bytes (doubling for 2-byte characters) without verifying
that len << 1 bytes are available. Should this also be checked?
