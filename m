Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88E8332906
	for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2026 22:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191465; cv=none; b=LRfvjk8y5zFqvwSmnNGpqpbVvUlYZUuZJJkaG1ChHbwJrR4b81onhkmRSiX6rOae/+nHtchbJtWtibmJUbmPj9Mik8xgW7CAisD0lhSz3eazYGUhKV79WU1rmdEys0/bzixEOTLZ5ssulYqqqDfD7gTTimJaVEwXusuBGJH7/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191465; c=relaxed/simple;
	bh=9jukIn/2fv24sOGnWj6EB+Rmg+yMOfDzuJImuQo1g1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBUeHnT8w9elPYptcGYqlCjeLC6oGvZWR4f8vf0O8QYoc1gGZ2UWjRFYFfXF3V/dWjmn0OX7FFOIJEPGgredF05lktpkoUXDmNoTuDtlfs/JA5dQ0tJcD1Dn+LnTk6hCY6qBnEks4XuYGrpcowwm4wwWG6INHMc+lHPacvtcPmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 40B5160D43; Fri, 08 May 2026 00:04:21 +0200 (CEST)
Date: Fri, 8 May 2026 00:04:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] scanner: Accept all statements' first words in all
 scopes
Message-ID: <af0MY2qPAuNwULFo@strlen.de>
References: <20260507203824.3560155-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507203824.3560155-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> To fix for token lookahead with exclusive start conditions, we must
> accept all keywords which may immediately follow the exclusive scope in
> that scope as well. This affects basically the first word of every
> statement which may follow a limit statement.

Hmm.  Can you give examples for some of these?

> -"@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
> +<*>"@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
> +<*>"set"		{ return SET; }

I have a hard time figureing these two out.

> +<*>"socket"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SOCKET); return SOCKET; }
> +<*>"tproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_TPROXY); return TPROXY; }

Yes, I can see those at least theoretically.

> +<*>"delete"		{ return DELETE; }
> +<*>"update"		{ return UPDATE; }
> +<*>"add"		{ return ADD; }

Hmm.  Care to enlighten us?  Is this for a theoretical thing only?
(limit + flowtable...?)

> +<*>"reset"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_RESET); return RESET; }

?

> -"last"				{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
> +<*>"last"		{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }

This one is also strange.  Normally, after limit, one would expect a
meaningful action (verdict, log, etc. -- something that has side
effects).

> +<*>"log"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
> +<*>"queue"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}

Makes sense.

> -"limit"			{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
> +<*>"limit"		{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }

limit limit?


> -"quota"			{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
> +<*>"quota"		{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }

limit + quota?  Strange combination, but ok.

> +<*>"reject"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_REJECT); return _REJECT; }

Makes sense.

> -"snat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
> -"dnat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
> -"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
> -"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }
> +<*>"snat"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
> +<*>"dnat"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
> +<*>"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
> +<*>"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }

Make no sense IMO, combining limit with nat table?
Is there a use case for this or are you just being conservative to not
break some random stuff?

> +<*>"th"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_TH); return TRANSPORT_HDR; }

Yes, however, I'm not sure its worth it.  Because its a strange flow.
th ... limit ... -> makes sense to me.

limit ... th ... -> not so much.

'meta mark' or 'mark', or 'ct' , yes those make sense because it would
be natual to e.g. 'mark set x' for traffic shaping for example.

[ This is not a nack, I am just curious ]
