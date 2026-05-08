Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A221E2DAFA9
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 10:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778235679; cv=none; b=TC08H2IFOggcnWj3mdXQLtdfJI3sS0LslA1R7Mx3ECfbhMNUfeQlsw4uLzV3VjaX0/HfZrCR+vHrdCJ4Mjwx1LytQjKImFfarr2qmsimMVFI7loMHNWoNbtxjqngkJBRzfBscGLeeAots+zpXE9MwFUONKlsiolx4pOJMZxauXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778235679; c=relaxed/simple;
	bh=Hp7SX1k3WcuLiqrwHtmhwGY+xM3O5ISbYtncUi9hwLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZXdFIdgDBUmW28Eq79NiVi+vh/NtMRGPasx5tD4f1j+Yd0XtvwM1nAbQxATeri6rGbOcMyqcUD7OJihkNCrJ04mOg3gZjlKopWkEqt5xm3rhUdzW5iEFB7sSTUf4ag4snkuS1EG4PqKhrzgIpNOcmoncwp917OzWJ/BHXiCCTd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MF9RB/1C; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MF9RB/1C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rW7LqxPU62J08WOC+a4RqOexYaNKwxtxzQAud2T4IVw=; b=MF9RB/1CQFcqb965iwME9JI2Qf
	FjTbkBhR5b1/0lgl+/hPsncIFVDSSRkKqZ/j8ZDOH2eHhLQo9/vCy4S0BbTRKkPVScEby/zARbIR3
	cb9+h4xmhwEAZxIRUYNYtm/bUbz+hi26qsANwLjg1CHPn8eh3A1FVVC2SVirU/DIKGJOiPMU7qEB1
	vzh3NKeZTEy/1gfb9iEc1h+pPNmigBCKmzx/F1Ar0NCTuoV67G7zmcPJF7IHW6WrDqgGt3C0bOaf6
	lJPE1REvWr3p/8v6hpKoM/xCjsFQmrGYMOJgD+RAILkI1ihFMx5asUjDhgGeoWX6ImQFgPSjkT5MH
	8tuSTenw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wLIKY-000000004Bp-0Y0r;
	Fri, 08 May 2026 12:21:14 +0200
Date: Fri, 8 May 2026 12:21:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] scanner: Accept all statements' first words in all
 scopes
Message-ID: <af25GqQQQXt8pZhf@orbyte.nwl.cc>
References: <20260507203824.3560155-1-phil@nwl.cc>
 <af0MY2qPAuNwULFo@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af0MY2qPAuNwULFo@strlen.de>

On Fri, May 08, 2026 at 12:04:19AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > To fix for token lookahead with exclusive start conditions, we must
> > accept all keywords which may immediately follow the exclusive scope in
> > that scope as well. This affects basically the first word of every
> > statement which may follow a limit statement.
> 
> Hmm.  Can you give examples for some of these?

Ah, perfect. I managed to forget to "git add" the test case, will send a
v2. Sorry!

> 
> > -"@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
> > +<*>"@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
> > +<*>"set"		{ return SET; }
> 
> I have a hard time figureing these two out.

The first one is for payload_raw_expr which starts with "@" token. With
set_stmt, there is an old syntax it seems ("set add ip saddr @foo").

> > +<*>"socket"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SOCKET); return SOCKET; }
> > +<*>"tproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_TPROXY); return TPROXY; }
> 
> Yes, I can see those at least theoretically.

They are for socket_expr and tproxy_stmt.

> > +<*>"delete"		{ return DELETE; }
> > +<*>"update"		{ return UPDATE; }
> > +<*>"add"		{ return ADD; }
> 
> Hmm.  Care to enlighten us?  Is this for a theoretical thing only?
> (limit + flowtable...?)

A set_stmt or map_stmt may follow limit_stmt, e.g.:

| limit rate 1/second update @myset { ip saddr }

Note that I did not care about semantics. I don't want to fix only those
uses of nftables *I* can imagine but all possible ones. Therefore I
parsed through parser_bison.y, identifying all tokens which may
immediately follow a limit statement. The only exceptions were those
which seemed outright impossible, like e.g. a number (accepted via
primary_expr -> integer_expr -> NUM).

> > +<*>"reset"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_RESET); return RESET; }
> 
> ?

This is for optstrip_stmt.

> > -"last"				{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
> > +<*>"last"		{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
> 
> This one is also strange.  Normally, after limit, one would expect a
> meaningful action (verdict, log, etc. -- something that has side
> effects).
> 
> > +<*>"log"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
> > +<*>"queue"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
> 
> Makes sense.
> 
> > -"limit"			{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
> > +<*>"limit"		{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
> 
> limit limit?

Heh, that is indeed a bug. Aside from the questionable semantics, LIMIT
token is obviously accepted in SCANSTATE_LIMIT already.

> > -"quota"			{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
> > +<*>"quota"		{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
> 
> limit + quota?  Strange combination, but ok.
> 
> > +<*>"reject"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_REJECT); return _REJECT; }
> 
> Makes sense.
> 
> > -"snat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
> > -"dnat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
> > -"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
> > -"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }
> > +<*>"snat"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
> > +<*>"dnat"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
> > +<*>"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
> > +<*>"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }
> 
> Make no sense IMO, combining limit with nat table?
> Is there a use case for this or are you just being conservative to not
> break some random stuff?

Yes, the latter. As the famous proverb goes: For any braindead use-case,
there's at least one user who absolutely depends on it.

> > +<*>"th"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_TH); return TRANSPORT_HDR; }
> 
> Yes, however, I'm not sure its worth it.  Because its a strange flow.
> th ... limit ... -> makes sense to me.
> 
> limit ... th ... -> not so much.
> 
> 'meta mark' or 'mark', or 'ct' , yes those make sense because it would
> be natual to e.g. 'mark set x' for traffic shaping for example.
> 
> [ This is not a nack, I am just curious ]

Looking at it from the opposite perspective: Are there any downsides if
we allow "too much" in SCANSTATE_LIMIT? We may not want to, but if there
will be another statement with an exclusive start condition in future,
we don't have to have this discussion about the sensibility of combining
some statements in a specific order again.

In general, there are various ways of writing nonsensical rules, e.g.
"tcp dport 22 tcp dport 23". If at all, I would not try to catch them in
the parser but at a later stage (eval phase maybe).

Cheers, Phil
