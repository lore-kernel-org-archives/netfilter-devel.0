Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FEC190075
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720620273; cv=none; b=DQCwF6a6KCFdm7mP0bjMCtcpH2XZZEshthDDUHDnvKWJz5x/tRkm+mGXp8v0Hc36e60sXknSoa0Na4t+fg/W4UpBm95ZNi18E5AcyKGuAcvfZYWBluQPd06OFXc+wKLe+A+2Bv0d6bpG08X6wDyvRbFQJSJqyK4RtMxTjnoYT44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720620273; c=relaxed/simple;
	bh=a/4f8ZaqTbNCiUJZucuF7M/w0pm1xWwmFF8F3ZDvwas=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpGoA/7IaJRiLFPJjXETcO+UM3gBjRe6T6wr51rTdDx5Jeuvug0WVBJ7zk49M7rTq7rNrL+cCcGf7nl/+CQq2QYj+oppZAdiW/AZHZNrRNnwoZilJsy99BL8b8WGzpX/LwLror0vNTrNjAj7061N/n3+JUvyDKQjUdF90nYV/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55178 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sRXvl-00GczE-UF; Wed, 10 Jul 2024 16:04:28 +0200
Date: Wed, 10 Jul 2024 16:04:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	jami.maenpaa@wapice.com, Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH nft 1/2] parser_json: use stdin buffer if available
Message-ID: <Zo6U6T_D69Uovqdi@calendula>
References: <20240709145953.135124-1-pablo@netfilter.org>
 <Zo6ScCYWnACpWJsl@orbyte.nwl.cc>
 <Zo6ULwwUxVG22x6V@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iahYZQSa/7dWjrSZ"
Content-Disposition: inline
In-Reply-To: <Zo6ULwwUxVG22x6V@orbyte.nwl.cc>
X-Spam-Score: -1.8 (-)


--iahYZQSa/7dWjrSZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jul 10, 2024 at 04:01:19PM +0200, Phil Sutter wrote:
> On Wed, Jul 10, 2024 at 03:53:52PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Jul 09, 2024 at 04:59:52PM +0200, Pablo Neira Ayuso wrote:
> > > Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
> > > stdin is stored in a buffer, update json support to use it instead of
> > > reading from /dev/stdin.
> > > 
> > > Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
> > > according to reporter (that mentions Yocto Linux as example).
> > > 
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  src/parser_json.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/src/parser_json.c b/src/parser_json.c
> > > index ee4657ee8044..4912d3608b2b 100644
> > > --- a/src/parser_json.c
> > > +++ b/src/parser_json.c
> > > @@ -4357,6 +4357,13 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
> > >  	json_error_t err;
> > >  	int ret;
> > >  
> > > +	if (nft->stdin_buf) {
> > > +		json_indesc.type = INDESC_STDIN;
> > > +		json_indesc.name = "/dev/stdin";
> > > +
> > > +		return nft_parse_json_buffer(nft, nft->stdin_buf, msgs, cmds);
> > > +	}
> > 
> > Is this sufficient? In nft_run_cmd_from_filename(), nft->stdin_buf is
> > populated conditionally:
> > 
> > | if (!strcmp(filename, "/dev/stdin") &&
> > |     !nft_output_json(&nft->output))
> > |         nft->stdin_buf = stdin_to_buffer();
> > 
> > Later (in the wrapped __nft_run_cmd_from_filename()), we try JSON parsing
> > conditionally:
> > 
> > | if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
> > |         rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
> > 
> > Things got complicated by commit 2034d8c60ed91 ("src: add input flag
> > NFT_CTX_INPUT_JSON to enable JSON parsing") and my request to remain
> > compatible, i.e. '-j' flag which enables JSON output shall continue to
> > make JSON the assumed input format.
> > 
> > So long story short, I guess in order to cover all cases, we have to
> > enable nft->stdin_buf population also if nft_input_json(...) returns
> > true, i.e. cover for library users requesting JSON input (but standard
> > output). WDYT?
> 
> On second review, I think the right change is to make
> nft_run_cmd_from_filename() *always* populate nft->stdin_buf if
> 'filename' is '/dev/stdin', i.e. drop the !nft_output_json(...) clause.
> 
> Sorry for the confusion.

I can squash this incremental fix to 1/2 send post a v2.

Thanks.

--iahYZQSa/7dWjrSZ
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/src/libnftables.c b/src/libnftables.c
index af4734c05004..89317f9f6049 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -807,8 +807,7 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	if (!strcmp(filename, "-"))
 		filename = "/dev/stdin";
 
-	if (!strcmp(filename, "/dev/stdin") &&
-	    !nft_output_json(&nft->output))
+	if (!strcmp(filename, "/dev/stdin"))
 		nft->stdin_buf = stdin_to_buffer();
 
 	if (!nft->stdin_buf &&

--iahYZQSa/7dWjrSZ--
