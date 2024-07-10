Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A1C18622
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720620083; cv=none; b=rr9RK7PhHL4XGmpQu4iFS6X6rH6Wyp9xlWMeF/G7NsI2eJWU/W3zxOBY0QhMEvHRHVaMOopXdoNIt3T6YFDvp/oSwFF70TKfo0bMO7SHAyu8TVRj8czmFVLB8aIAd5bRnEwke8W/PZS73Ejc4logsbEft97Ks7jfDJ+Wx2GvMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720620083; c=relaxed/simple;
	bh=rSnV8sNLgGc+fzFh5kCAfVEmA+nS9xKPD/b+atb5xSI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFA51cJTQr2iIbmPMa2UuGHzeQ8oN8HAB01oMCGAYgdnoTV0hIrciWwQoKO8TD0tsc2t5efR85OT4dNgTwjVHUR9sUFTAnQzUUrEijz7rASztHB1N034Io8Y7sB0Y7RMAxFT1aWKdKomt2234RuhAtfN8SsoiomA30XkB21yVqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UyXjyUmB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UyXjyUmB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sPzNrlXLnFWENiWI4VUgHZ0t4jR8qS9RF8njda/7Q/0=; b=UyXjyUmBEjFFd1svEznjuwiq3K
	09/gXXyjCOrhmsR3YTkoMJ8XNTqF5cE5aRPEllfBJ2TmjnIXzBje+uP2mxohSyZG4ysyzk+ZvAZZ4
	PV3XWKTI+lsfK+lYDqXZlokozf0PaAggw0vvVLEoduDDFeZMM6pMoD5jk+Z5wByZmEqHrPIDGprC7
	mtoaZc1iAyQPWXX3U/rcKJql8iTxHpjl2QDm9PrBzwXC5PuOr49VJQp0EnsZ6EenxPSt/z6zkI/fV
	wY/jFtw89AenvjBiZ034pAd3S5dgU2d37EGYfM5UzO/0GY9FMxL5zM1WLPA3sibtvxEav+LgqM357
	DLAIQutw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sRXsl-000000006SV-14CF;
	Wed, 10 Jul 2024 16:01:19 +0200
Date: Wed, 10 Jul 2024 16:01:19 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, jami.maenpaa@wapice.com,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH nft 1/2] parser_json: use stdin buffer if available
Message-ID: <Zo6ULwwUxVG22x6V@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, jami.maenpaa@wapice.com,
	Thomas Haller <thaller@redhat.com>
References: <20240709145953.135124-1-pablo@netfilter.org>
 <Zo6ScCYWnACpWJsl@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zo6ScCYWnACpWJsl@orbyte.nwl.cc>

On Wed, Jul 10, 2024 at 03:53:52PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Jul 09, 2024 at 04:59:52PM +0200, Pablo Neira Ayuso wrote:
> > Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
> > stdin is stored in a buffer, update json support to use it instead of
> > reading from /dev/stdin.
> > 
> > Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
> > according to reporter (that mentions Yocto Linux as example).
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/parser_json.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/src/parser_json.c b/src/parser_json.c
> > index ee4657ee8044..4912d3608b2b 100644
> > --- a/src/parser_json.c
> > +++ b/src/parser_json.c
> > @@ -4357,6 +4357,13 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
> >  	json_error_t err;
> >  	int ret;
> >  
> > +	if (nft->stdin_buf) {
> > +		json_indesc.type = INDESC_STDIN;
> > +		json_indesc.name = "/dev/stdin";
> > +
> > +		return nft_parse_json_buffer(nft, nft->stdin_buf, msgs, cmds);
> > +	}
> 
> Is this sufficient? In nft_run_cmd_from_filename(), nft->stdin_buf is
> populated conditionally:
> 
> | if (!strcmp(filename, "/dev/stdin") &&
> |     !nft_output_json(&nft->output))
> |         nft->stdin_buf = stdin_to_buffer();
> 
> Later (in the wrapped __nft_run_cmd_from_filename()), we try JSON parsing
> conditionally:
> 
> | if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
> |         rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
> 
> Things got complicated by commit 2034d8c60ed91 ("src: add input flag
> NFT_CTX_INPUT_JSON to enable JSON parsing") and my request to remain
> compatible, i.e. '-j' flag which enables JSON output shall continue to
> make JSON the assumed input format.
> 
> So long story short, I guess in order to cover all cases, we have to
> enable nft->stdin_buf population also if nft_input_json(...) returns
> true, i.e. cover for library users requesting JSON input (but standard
> output). WDYT?

On second review, I think the right change is to make
nft_run_cmd_from_filename() *always* populate nft->stdin_buf if
'filename' is '/dev/stdin', i.e. drop the !nft_output_json(...) clause.

Sorry for the confusion.

Cheers, Phil
