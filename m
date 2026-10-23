Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792737983;
	b=PMguuBWshUrgQvXtiW9SASlVC/I6LK/rX1jNwyF1XSy29N4NwQQKdx5+SntV6bGScqQ4
	 /9o4+bXF/eODGBO7wQHl+FHixWhp6iBJgefsfksAkdk3vGPvB5ywW6hMpbjy9FmzpY13D
	 U9AjL38ocWHFX7CF+c74Gs4o9Q4SXSgXyCawSUcygjaD8ly9LHwJQeuCpjex2DCJGXYNB
	 kcQgHL0UR1Y0d+D3kq2JBtcFz8g8A+ZkcNZF12Q0nXr0YyhbvFjc1V6qNs1EZAFUf0yEh
	 7Y85DPCKdBQfkBU60Yy8xVeXZsiPX8ol75KHbtWPWgN1gwxztOzjMlG6OblZJuGEaZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792737983;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yzphMCulyey7A6Hpiwuov45a4ASuSSbO2ebDQb+xFGI=;
	b=deuzO7ImMhceyJNCwSxHCXWq/GohMc6ECYAGbtCtSu5W2YnkQLSvPmTmyeqS+jkKTQLs
	 0YDZBlF8SYwyUCI3znrALB8bkJqgkXO//auQaVi3w/i9zvNEVcKPisoyYMqPA5GbuqkHi
	 7Sw6cJr43raALq9vGl9PeKhEIuTNbfCynSByg1RQGQ2iC2fk5ystxbBEd2tsp1jhfDG16
	 /vt7JcM9I/3qUZjPIrxorcR+iCIypefawkUe7kBLbqUBdZNWrz4iDFtERlsdgkPbYak3l
	 iVTay/PZJNmw3uAJTM9MN9t9cywsQttKQlOcTSGueisvdtCl1r0mJmg4CM89OwlCv4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22164606A31B
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 06:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22164606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 30A55600C1; Fri, 23 Oct 2026 08:46:19 +0200 (CEST)
Date: Fri, 23 Oct 2026 08:46:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhiling Zou <zhilinz@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org,
	idosch@nvidia.com, vega@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: ebtables: validate compat nentries
Message-ID: <atsCs5zS3x9wxBSN@strlen.de>
References: <cover.1792733039.git.zhilinz@nebusec.ai>
 <280a41badb424f8dc5fa22d03d6abf82025d539e.1792733039.git.zhilinz@nebusec.ai>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <280a41badb424f8dc5fa22d03d6abf82025d539e.1792733039.git.zhilinz@nebusec.ai>

Zhiling Zou <zhilinz@nebusec.ai> wrote:
> compat_do_replace() allocates per-CPU counters from the compat header's
> nentries before it parses the entries blob. A malformed request can claim
> millions of rules while supplying only a single empty chain, causing a
> large vmalloc() before the request is rejected by later validation.
> 
> Each rule occupies at least sizeof(struct ebt_entry) bytes in the input
> blob. Reject a rule count that cannot fit in entries_size before the
> compat path allocates counters.

Looks like a nothingburger.  User could also supply a larger blob?

Also: CONFIG_COMPAT should no longer be reachable from userns:
ec1806a730a1 ("netfilter: x_tables: disable 32bit compat interface in user namespaces")

@Pablo: if you prefer to take this, no objections from my side;
it doesn't look wrong.
