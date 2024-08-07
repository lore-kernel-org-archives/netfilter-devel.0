Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028C384DF1
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723050918; cv=none; b=LagEaaxlVC2ZrXfidnK7QVGmKxtWsgeWdzWmz6JT1sru8OVG30rqFbk6U3DrlP+MlHpwAyKKPQ8Mg4SsJqc9Ad5X9Q8S8Ufwfi35KxMkXk2jfCOwtfoA4MOtj0M5g+1HRpTnNzatnxuwfiZr5+S9VHIStqisHszURqeRKeeXY0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723050918; c=relaxed/simple;
	bh=44amH/0YCL7j8KQpq/0zj0gv8hcsqJmjE5h2wJyxRCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjJZfcS9mV4rFT5dUSsVIAgLd751QAB3rYFwFy+YHagnzRGjV5wv0zb94o1nnAyPjX/+tUpSzcRjzSKBHzQsVc5kOECtSdxOkDfWcx4KPvVuY2kB4N5w0Mw/0oMGtvojT4DeCTY+eqmxdPxvgWYqIHMoNPJKdkGNFfUAw1Am9Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41692 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sbjvT-005CZz-3m; Wed, 07 Aug 2024 18:54:17 +0200
Date: Wed, 7 Aug 2024 18:54:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 0/5] src: mnl: rework list hooks infra
Message-ID: <ZrOmtXN5iEghxLRU@calendula>
References: <20240731165111.32166-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240731165111.32166-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

Hi Florian,

A few suggestions:

- nft list hooks could probably take 'ip' family as default for
  consistency with other commands? There is 'nft list ruleset' which
  is special because it is family agnostic. Otherwise print all
  hooks with 'nft list hooks'? leaving netdev out of the picture
  unless 'device' is specified. I guess this approach you follow
  is to be conservative with the existing behaviour.

- Maybe plain reject 'device' for arp and bridge families?

  nft list hooks arp device enp0s25
  # device keyword (enp0s25) unexpected for this family

  instead of displaying a warning? I guess you are being conservative
  again here, that is fine.

- I understand you don't like the inet/ingress hack. It is there to
  address the shortcomming of not allowing sets to be shared accross
  families, and it does not even address it fully. I admit it is not
  the best approach, I'd like to explore better ones to address the
  need for set sharing.

  Going back to your approach: this is a bit low level, it exposes
  internal implementation details, such as the inet syntactic sugar
  (this is all hidden behind after the {register,unregister}_hook API).
  I understand that my attempt to describe the pipeline was
  incomplete, but I still wonder if, from user POV, it might makes
  sense at least to show the inet/ingress hook when listing the inet
  family to give an idea of what hook is registered according to
  priority. I would still show the inet/ingress in netdev family too
  (yes, it would be redundant).

Documentation looks good.

Thanks!

On Wed, Jul 31, 2024 at 06:51:00PM +0200, Florian Westphal wrote:
> Turns out that not only was 'nft list hooks' mostly undocumented,
> there was also confusion on what it should do.
> 
> First, clean this code up and make it strictly a tool to dump
> the NFPROTO_X registered functions.
> 
> Then, remove the 'hook' function argument, this was still passed
> from back in the day when one could ask to only dump e.g.
> ipv4 prerouting.  This ability is of little value, so don't restore
> this but instead just remove the leftover code.
> 
> Next, allow dumping of netdev:egress hooks.
> Lastly, document this in more detail and make it clear that this
> dumps the netfilter hooks registered for the protocol families,
> and nothing else.
> 
> Once this gets applied I intend to make
> 'nft list hooks netdev'
> 
> dump device hooks for all interfaces, if any, instead of a
> 'no device provided' warning.
> 
> Florian Westphal (5):
>   src: mnl: clean up hook listing code
>   src: mnl: make family specification more strict when listing
>   src: drop obsolete hook argument form hook dump functions
>   src: add egress support for 'list hooks'
>   doc: add documentation about list hooks feature
> 
>  Makefile.am                 |   1 +
>  doc/additional-commands.txt | 116 ++++++++++++++++++++++++++++
>  doc/nft.txt                 |  63 +--------------
>  include/mnl.h               |   2 +-
>  src/mnl.c                   | 150 ++++++++++++++----------------------
>  src/rule.c                  |   6 +-
>  6 files changed, 179 insertions(+), 159 deletions(-)
>  create mode 100644 doc/additional-commands.txt
> 
> -- 
> 2.44.2
> 
> 
