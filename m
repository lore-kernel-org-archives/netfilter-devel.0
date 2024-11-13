Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B3526AEC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 11:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731495676; cv=none; b=CAkq5mnAFE8erptkBW7p+rsdYEgsRN2dbugJhTztIcpkllH2iqv/IzWyN97K6rPQTcIS5ho3eAwRjObHOlmfSq4h1DmiR3dsJsfBszNgHmjDZx14c+29+AArHMKGK2o772sEz1eQMISUq+qrJ39kSXBi0EwwViQnuK1M6SURJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731495676; c=relaxed/simple;
	bh=Muqx94YtTl7dYl/RN3oGUmZOQV4pNR2uXo2B3SrUezw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHFnfgmDlHtU5h9Nveikk6CHXgzVoWoe+BTZLe8p9kAHIxUcsmMlYFuHhut0zZ2zwn7IigUpWNq2vHdqFpWgqJMZUrMF9SO7RV6QrmWyBFuenXO9mDwR2ZEs2vAyZ/wpaNyDmjjSgt+GNh5McXy6bmThcpgepTgaRi6O1/pF1qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46720 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBB7U-00DokO-OJ; Wed, 13 Nov 2024 12:01:11 +0100
Date: Wed, 13 Nov 2024 12:01:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	eric@garver.life
Subject: Re: [PATCH nft] json: collapse set element commands from parser
Message-ID: <ZzSG8xWKI5Re0Xcy@calendula>
References: <20241031220411.165942-1-pablo@netfilter.org>
 <ZzPAE3Gj6qoA8ZAk@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZzPAE3Gj6qoA8ZAk@orbyte.nwl.cc>
X-Spam-Score: -0.8 (/)

Hi Phil,

On Tue, Nov 12, 2024 at 09:52:35PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> > Side note: While profiling, I can still see lots json objects, this
> > results in memory consumption that is 5 times than native
> > representation. Error reporting is also lagging behind, it should be
> > possible to add a json_t pointer to struct location to relate
> > expressions and json objects.
> 
> I can't quite reproduce this. When restoring a ruleset with ~12.7k
> elements in individual standard syntax commands, valgrind prints:
> 
> | HEAP SUMMARY:
> |     in use at exit: 59,802 bytes in 582 blocks
> |   total heap usage: 954,970 allocs,
> |                     954,388 frees,
> |                  18,300,874 bytes allocated
> 
> Repeating the same in JSON syntax, I get:
> 
> | HEAP SUMMARY:
> |     in use at exit: 61,592 bytes in 647 blocks
> |   total heap usage: 1,200,164 allocs,
> |                     1,199,517 frees,
> |                    38,612,257 bytes allocated
> 
> So this is 38MB vs 18MB? At least far from the mentioned 5 times. Would
> you mind sharing how you got to that number?
> 
> Please kindly find my reproducers attached for reference.

I am using valgrind --tool=massif to measure memory consumption in
userspace.

I used these two files:

- set-init.json-nft, to create the table and set.
- set-65535.nft-json, to create a small set with 64K elements.

then I run:

valgrind --tool=massif nft -f set-65535.nft-json

there is a tool:

ms_print massif.out.XYZ

At "peak time" in heap memory consumption, I can see 60% is consumed
in json objects.

I am looking at the commands and expressions to reduce memory
consumption there. The result of that work will also help json
support.
