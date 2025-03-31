Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0283A1DC991
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743416586; cv=none; b=qW28rpkkYWp0r5roNV7bAxgkK0cSFuD0pk8ISZGxNcizJ79Co4A07tOe6yg1v0Dy1KW/e375SoxEWh4rBTLOdQX/PuV/i7bNTjGtO2MT9cfDe7zbvXCf+4x9xt7y920R0S5CyuNkm8hvcYbwQsfvX1WkVHCspqaDkxxdh9a8YSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743416586; c=relaxed/simple;
	bh=zsYjg5wjou4MzRcZn8WKzFl3uDb6Eux1GE7j3D+5Vf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sAIypAR3TgQZPDMX+4jbN1VN34JA3cjvyv7UipmYAla9YXHKcT1MnO5vGVCg9YS0Y31XKnPPJ3A9Telp5Cnwso5iw9K+VoJTx8L1d8BSEilSAQFN/vygFeHUe6Z2tykDk5Lz8u60VPjaENhqKaAbJbKV8ddzWJ4imfC8wBKFgjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M7QJhN9F; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M7QJhN9F; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M7QJhN9F";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M7QJhN9F"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 97A66603B9; Mon, 31 Mar 2025 12:22:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743416575;
	bh=+U2HpbJFQCj7wZx576pKRekL5epE/k5nRMtlro01VpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7QJhN9F8CTxzTzHsHo+JQbhWuceaKrmIkI31Tfpn2C0Ul3WgrkCuy/X0xvWcTKek
	 7rt/MeMpbGu8DiWLkvpCTb+wh3B3Hl+SxQoIJzqr88PlwfldancigKRCbObM8sBxt1
	 LuQ4RcaqzujgL3RkJDiuA/pdYC1CbZSkDzAGg467WKCNLhCTALiTM6qo6TSSVPApCc
	 yq9bupOOZkZDW2vOAafYgNDj7kk+XOlFf0lqeCAl/ONlXzU8vWhJB9iRdKzunUVOx2
	 c3qHcusBSsQzEK8hxEcQiB+IXMYhYPip/VT6AgJfuZEiur1klmu347dSgXQ4zQ5uY4
	 WlcgkhnboZmEw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0661D603B4;
	Mon, 31 Mar 2025 12:22:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743416575;
	bh=+U2HpbJFQCj7wZx576pKRekL5epE/k5nRMtlro01VpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7QJhN9F8CTxzTzHsHo+JQbhWuceaKrmIkI31Tfpn2C0Ul3WgrkCuy/X0xvWcTKek
	 7rt/MeMpbGu8DiWLkvpCTb+wh3B3Hl+SxQoIJzqr88PlwfldancigKRCbObM8sBxt1
	 LuQ4RcaqzujgL3RkJDiuA/pdYC1CbZSkDzAGg467WKCNLhCTALiTM6qo6TSSVPApCc
	 yq9bupOOZkZDW2vOAafYgNDj7kk+XOlFf0lqeCAl/ONlXzU8vWhJB9iRdKzunUVOx2
	 c3qHcusBSsQzEK8hxEcQiB+IXMYhYPip/VT6AgJfuZEiur1klmu347dSgXQ4zQ5uY4
	 WlcgkhnboZmEw==
Date: Mon, 31 Mar 2025 12:22:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: fix error protagation when parsing binop
 lhs/rhs
Message-ID: <Z-ps_B-vTcI3O-R3@calendula>
References: <20250328144911.21966-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250328144911.21966-1-fw@strlen.de>

On Fri, Mar 28, 2025 at 03:49:04PM +0100, Florian Westphal wrote:
> Malformed input returns NULL when decoding left/right side of binop.
> This causes a NULL dereference in expr_evaluate_binop; left/right must
> point to a valid expression.
> 
> Fix this in the parser, else would have to sprinkle NULL checks all over
> the evaluation code.
> 
> After fix, loading the bogon yields:
> internal:0:0-0: Error: Malformed object (too many properties): '{}'.
> internal:0:0-0: Error: could not decode binop rhs, '<<'.
> internal:0:0-0: Error: Invalid mangle statement value
> internal:0:0-0: Error: Parsing expr array at index 1 failed.
> internal:0:0-0: Error: Parsing command array at index 3 failed.
> 
> Fixes: 0ac39384fd9e ("json: Accept more than two operands in binary expressions")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

one nitpick:

> diff --git a/tests/shell/testcases/bogons/nft-j-f/binop_rhs_decode_error_crash b/tests/shell/testcases/bogons/nft-j-f/binop_rhs_decode_error_crash
> new file mode 100644
> index 000000000000..c5de17111ff6
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-j-f/binop_rhs_decode_error_crash
[...]
> +              "value": {
> +                "<<": [
> +                  {
> +                    "|": [
> +                      {
> +                        "meta": {
> +                          "key": "mark"
> +                        }
> +                      },
> +                      16
> +                    ]
> +                  },
> +    {  },

Something strange here in this indent.

> +                  8
> +                ]
> +              }
> +            }
> +          }
> +        ]
> +      }
> +    }
> +  ]
> +}
