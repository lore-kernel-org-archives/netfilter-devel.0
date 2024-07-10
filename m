Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2579538397
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720624556; cv=none; b=XeGJgxwINh5uVgQxi4uIn6PTBaxFa/VbYCnafFovFB2Insqj51Zn61YfNz2HfNJpcaQODn1fv33yXsbU+F6N4igR1va16ReSQY7SiDLAEvffD010oRevhGL5Cnn5jXSsolFeO5sRJjj5YIl/06yT783nWZrxvJZ7+wW/fDB99mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720624556; c=relaxed/simple;
	bh=r1r5yY7DpNtbFc8gdULou5nSMfHO18Ahq7hs+pt8UFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVm94ZvsEm74OoddPjhFFnpC+t7Kcrxci8qSqaOzQz90oL2mGXC8cAMXDfyIFmStCb/nuTBzH9xeiXZdRmq37NtZ7C/8FZXjHsvaIa8f7ND5ngyejAkLxRNZZ8OmgbBLcbkws6F/SvwYJMObEUwqQulfSUlrbZwn7JmTZxJAFAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FcRafWBT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FcRafWBT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=thd/shyO9nXV+v8PqrNj8OdSreToUzLDKnWp4XT+Q78=; b=FcRafWBTy1qS+QtiIF+Y5mkOAN
	7VJ7kGkasVJu/YOLAZCtIJjxvBhAx0Exl9iiFW4b5UsAULDzUSpPrlVMBa9abxUrWXU+uAz4vKxf8
	YBjrO3JkMcoj6nH+gIl7m7Wpzu7x/QYelj2Skm5th2DFunwsyalUUftiTmn6aNocdzsisnaqvYf9/
	EuB5wEggJmDepQJUogYEg8NZpoVeE7iMDiU3wGZaKKNSAM9eLXwya6P5uXEcyKOLBmm/n081mVYTu
	um7idbFkt/4BukI/qkpYgiOM55+0bHH/Qixnlbai7zZzm4zn/QO59GwEgKjZfVaDoOmlF/uegf5My
	IXodjudA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sRZ2s-000000008TD-3an5;
	Wed, 10 Jul 2024 17:15:50 +0200
Date: Wed, 10 Jul 2024 17:15:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, jami.maenpaa@wapice.com,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH nft 1/2] parser_json: use stdin buffer if available
Message-ID: <Zo6lpgE8buxOo5rQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, jami.maenpaa@wapice.com,
	Thomas Haller <thaller@redhat.com>
References: <20240709145953.135124-1-pablo@netfilter.org>
 <Zo6ScCYWnACpWJsl@orbyte.nwl.cc>
 <Zo6ULwwUxVG22x6V@orbyte.nwl.cc>
 <Zo6U6T_D69Uovqdi@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zo6U6T_D69Uovqdi@calendula>

On Wed, Jul 10, 2024 at 04:04:25PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 10, 2024 at 04:01:19PM +0200, Phil Sutter wrote:
> > On Wed, Jul 10, 2024 at 03:53:52PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Tue, Jul 09, 2024 at 04:59:52PM +0200, Pablo Neira Ayuso wrote:
> > > > Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
> > > > stdin is stored in a buffer, update json support to use it instead of
> > > > reading from /dev/stdin.
> > > > 
> > > > Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
> > > > according to reporter (that mentions Yocto Linux as example).
> > > > 
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > >  src/parser_json.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > > 
> > > > diff --git a/src/parser_json.c b/src/parser_json.c
> > > > index ee4657ee8044..4912d3608b2b 100644
> > > > --- a/src/parser_json.c
> > > > +++ b/src/parser_json.c
> > > > @@ -4357,6 +4357,13 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
> > > >  	json_error_t err;
> > > >  	int ret;
> > > >  
> > > > +	if (nft->stdin_buf) {
> > > > +		json_indesc.type = INDESC_STDIN;
> > > > +		json_indesc.name = "/dev/stdin";
> > > > +
> > > > +		return nft_parse_json_buffer(nft, nft->stdin_buf, msgs, cmds);
> > > > +	}
> > > 
> > > Is this sufficient? In nft_run_cmd_from_filename(), nft->stdin_buf is
> > > populated conditionally:
> > > 
> > > | if (!strcmp(filename, "/dev/stdin") &&
> > > |     !nft_output_json(&nft->output))
> > > |         nft->stdin_buf = stdin_to_buffer();
> > > 
> > > Later (in the wrapped __nft_run_cmd_from_filename()), we try JSON parsing
> > > conditionally:
> > > 
> > > | if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
> > > |         rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
> > > 
> > > Things got complicated by commit 2034d8c60ed91 ("src: add input flag
> > > NFT_CTX_INPUT_JSON to enable JSON parsing") and my request to remain
> > > compatible, i.e. '-j' flag which enables JSON output shall continue to
> > > make JSON the assumed input format.
> > > 
> > > So long story short, I guess in order to cover all cases, we have to
> > > enable nft->stdin_buf population also if nft_input_json(...) returns
> > > true, i.e. cover for library users requesting JSON input (but standard
> > > output). WDYT?
> > 
> > On second review, I think the right change is to make
> > nft_run_cmd_from_filename() *always* populate nft->stdin_buf if
> > 'filename' is '/dev/stdin', i.e. drop the !nft_output_json(...) clause.
> > 
> > Sorry for the confusion.
> 
> I can squash this incremental fix to 1/2 send post a v2.

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
