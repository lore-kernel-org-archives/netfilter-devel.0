Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE8546E01E;
	Mon, 12 Oct 2026 09:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796330; cv=none; b=ZcxJivnVORCnnX9NWNMDBSmBC8QrQe2VyCvn0LkMKtOcDwQE7c6MbmVzQjz5M0mrgJV56zR8USVrnVQXp8XG+sMUAPIyuCZIAYF5i0Slf5vHxAVUP1UlA3QnMD14YtlK1WxEv6LMNPuYkh9eg9SdaI27kcRfao+SpcmC3AbrHOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796330; c=relaxed/simple;
	bh=/oq8K5f0YcnsdZxtUzM+wQiCf8eXQzq8UWFidqngtpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sm8I/WfhcOrNuCB3ezsFtA2miayqUvakjOtIbLB8FIEpN9MxkF56GaClZ47im3FeAQYm9CF+o6VaJQkfQL1hbr3HeLGsYw47Eb0ozXbsMKDooOSbDbBM/st3P1UGwb2cI9vv9F11iBF2JSa+XNajJ8CTWxWOwPe1Ebd5kgVVazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C3AEF60293; Mon, 12 Oct 2026 11:12:05 +0200 (CEST)
Date: Mon, 12 Oct 2026 11:12:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Guanglei Zhu <zhugl3@xiaopeng.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	liuwb@xiaopeng.com
Subject: Re: [PATCH] netfilter: nf_conntrack_h323: fix NULL deref in
 decode_seqof()
Message-ID: <asykY-liuKbPCdwK@strlen.de>
References: <20261012090835.920932-1-zhugl3@xiaopeng.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012090835.920932-1-zhugl3@xiaopeng.com>

Guanglei Zhu <zhugl3@xiaopeng.com> wrote:
> decode_seqof() loads son from f->fields and dereferences son->attr
> in the item loop without a NULL check.  A number of SEQOF entries
> in nf_conntrack_h323_types.c carry a NULL fields pointer, so a
> crafted packet that makes one of these optional fields present with
> a nonzero item count dereferences NULL in the loop.
> 
> Skip the decoding when fields is NULL.
> 
> Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
> ---
> Verified on a KASAN kernel with a test module calling decode_seqof()
> with a fields=NULL SEQOF entry and a nonzero item count: NULL deref
> report at son->attr (read of size 2 at address 0x4).

We don't add NULL tests unless there is a sensibe reason.

Will you add NULL tests to other functions too because a 3rd party
module would crash otherwise?

If this is reachable, show how.

> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 6830c9da3..0d07d0276 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -691,6 +691,8 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
>  	}
>  
>  	/* Decode nested field */
> +	if (!f->fields)
> +		return H323_ERROR_NONE;
>  	son = f->fields;

This is strange.

son = f->fields;
if (!son)...

would be more natural.
