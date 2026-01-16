Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D41943AA6
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2026 13:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768568853; cv=none; b=X89u7Nib9KBCyYO6kW25Ex6ETq/zQxggqh+FuAyomQFajWYyAqmgFzRctHpkDzpFFjjnScuc5FuEhn4WykW/9/IlRBQ11gH0idm/oLVaFWzEkg592Tei04zIf+AuO9LIegGX/YDtphMq+9SGR8bZ0y9QYNipl+k7lnwEJu18/dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768568853; c=relaxed/simple;
	bh=qQDVlLeI1qCGEKP6U5aQRCR1OEWlHl5esqwCUHgERaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNCa39OVbhHXiVk8b6tFEv6tC0TDFASgJxf3QuG00wF49J01GZ+tTbc8ghWNVqHS3uYr6SsZcpxSmMVbWIxWVvugQX9cpTI+CnmpVynRDSZy757k9zdN0krt+Zp+BVPEdADPKxRbE7sEsuAR4nQu7RlwneCOsztTS3XOmrPX918=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4BAD360242; Fri, 16 Jan 2026 14:07:29 +0100 (CET)
Date: Fri, 16 Jan 2026 14:07:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: on syntax errors, output expected
 tokens
Message-ID: <aWo4DAHLS5284upo@strlen.de>
References: <1950751.CQOukoFCf9@imladris>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1950751.CQOukoFCf9@imladris>

Jan Kończak <jan.konczak@cs.put.poznan.pl> wrote:
> +static int
> +yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
> +                      void *scanner, struct parser_state *state)
> +{
> +	struct location *loc = yypcontext_location(yyctx);
> +	const char *badTok = yysymbol_name(yypcontext_token(yyctx));
> +
> +	char * msg;
> +	int len = 1024;
> +	int pos;
> +	const char * const sep = ", ";
> +
> +	// get expected tokens
> +	int expTokCnt = yypcontext_expected_tokens(yyctx, NULL, 0);

No need for these comments, the function name below is verbose enough.

> +	yysymbol_kind_t *expTokArr = malloc(sizeof(yysymbol_kind_t) * expTokCnt);

You could use xmalloc_array() instead.

> +	if (!expTokArr) return YYENOMEM;
> +	yypcontext_expected_tokens(yyctx, expTokArr, expTokCnt);
> +
> +	// reserve space for the error message
> +	msg = malloc(len);

You can use xmalloc() here, like other parts in the parser already do.

> +	if (!msg) { free(expTokArr); return YYENOMEM; }

... and then this can be removed.

> +	// start building up the error message
> +	pos = snprintf(msg, len, "syntax error, unexpected %s\n"
> +	                         "expected any of: ", badTok);

I think it would be easier to switch this to fprintf, with
FILE *err = open_memstream(&msg,  ...).

> +	// append expected tokens to the error message
> +	for (int i = 0; i < expTokCnt; ++i) {
> +		yysymbol_kind_t expTokKind = expTokArr[i];
> +		const char * expTokName = yysymbol_name(expTokKind);
> +
> +		// tokens that name generic things shall be printed as <foo>; detect them
> +		int isNotAKeyword = 0;
> +		switch( expTokKind ){
> +			case YYSYMBOL_NUM:      case YYSYMBOL_QUOTED_STRING:
> +			case YYSYMBOL_STRING:   case YYSYMBOL_ASTERISK_STRING:
> +				isNotAKeyword = 1;
> +			default:
> +		}
> +
> +		if ((size_t)len-pos-1 < strlen(expTokName)+strlen(sep)+isNotAKeyword*2) {
> +			// need more space for the error message to fit all expected tokens
> +			char * newMsg;
> +			len += 1024;
> +			newMsg = realloc(msg, len);
> +			if (!newMsg) { free(msg); free(expTokArr); return YYENOMEM; }
> +			msg = newMsg;

... it would allow to remove these checks; libc would take care of
reallocting the memory buffer.

> +		pos += snprintf(msg+pos, len-pos, "%s%s%s%s",

and no more need to advance the target buffer and manual fiddling with
allowed length.

Other than these nits I think this is ready to get merged.
