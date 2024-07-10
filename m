Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1101940B1
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720619637; cv=none; b=QlYaLCKk3oVxLaDi2n2RZOrSwN4lzkuB1EVKfzEAqrtyffd7qf4+HagKVMNLRYkudQ7xbSmWi2RurO42AiJWPO0WrSi0QFc9PG+uHuGwmFykKN77UsTk+GnY23+xJq/NupA819+XEnbn/GewNFVvg1mh84AsfmvPfbKGc1K5DQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720619637; c=relaxed/simple;
	bh=ohA3OiJ/BKxkhsXZKXi0GXExxx8LdTB+et/iu5mmloA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RU2TyhCBhh+2ARqNa/YwO2c4STR0Al5srftIjd1xtnOM8SMZ8wiwinIKJEyNum4TJJfz85N+byCCvIA1HYYDQ3hSdZzuVhrCjVibyIuMoXZFcIkq+pnHzIWWBGodr0nmN9pZwTTRpx5BTBKmvhrb0OTOTEUdekZseAVf73byO3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kRcXm+QF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kRcXm+QF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KGx44/LFYBryTpxU2xnw5hR4Xu1+sHXG9wY8wovMMOg=; b=kRcXm+QFYw4kR/xbKMC/yGZ9pn
	LITz1KGjsRf0+j++U4NzOls1ivsOrsd1hhpp1H+gLfuoN/84S6DQsjvg5zODhXamaAHYS4qYFaXJZ
	bG09uPa+esHYBSAKGK/QHbn9Hpbg90lPIKtZGS8T8OIWMGzSEB8KTO1QOoYF+fkhEcH4PBble0Dnk
	E6+wMcX+fP4jEDB42NxJp3/P01/r3jQ+IlL73HlvixvtY+1p6CR6Rbt5Uj6Tgd7av+wWFTrLHrZpy
	COLOMOsGvL0EXSIu9cjPXztLogxnLmlmdg9ZR+LxJP1lzdNk+hH+CLj9gonDv21HEH+KGGkKKulQb
	HhCDd9YA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sRXlY-000000006L1-3bpl;
	Wed, 10 Jul 2024 15:53:52 +0200
Date: Wed, 10 Jul 2024 15:53:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, jami.maenpaa@wapice.com,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH nft 1/2] parser_json: use stdin buffer if available
Message-ID: <Zo6ScCYWnACpWJsl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, jami.maenpaa@wapice.com,
	Thomas Haller <thaller@redhat.com>
References: <20240709145953.135124-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709145953.135124-1-pablo@netfilter.org>

Hi Pablo,

On Tue, Jul 09, 2024 at 04:59:52PM +0200, Pablo Neira Ayuso wrote:
> Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
> stdin is stored in a buffer, update json support to use it instead of
> reading from /dev/stdin.
> 
> Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
> according to reporter (that mentions Yocto Linux as example).
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/parser_json.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/src/parser_json.c b/src/parser_json.c
> index ee4657ee8044..4912d3608b2b 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -4357,6 +4357,13 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
>  	json_error_t err;
>  	int ret;
>  
> +	if (nft->stdin_buf) {
> +		json_indesc.type = INDESC_STDIN;
> +		json_indesc.name = "/dev/stdin";
> +
> +		return nft_parse_json_buffer(nft, nft->stdin_buf, msgs, cmds);
> +	}

Is this sufficient? In nft_run_cmd_from_filename(), nft->stdin_buf is
populated conditionally:

| if (!strcmp(filename, "/dev/stdin") &&
|     !nft_output_json(&nft->output))
|         nft->stdin_buf = stdin_to_buffer();

Later (in the wrapped __nft_run_cmd_from_filename()), we try JSON parsing
conditionally:

| if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
|         rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);

Things got complicated by commit 2034d8c60ed91 ("src: add input flag
NFT_CTX_INPUT_JSON to enable JSON parsing") and my request to remain
compatible, i.e. '-j' flag which enables JSON output shall continue to
make JSON the assumed input format.

So long story short, I guess in order to cover all cases, we have to
enable nft->stdin_buf population also if nft_input_json(...) returns
true, i.e. cover for library users requesting JSON input (but standard
output). WDYT?

Cheers, Phil
