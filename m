Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACC912FF74
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709829872; cv=none; b=WhZz8VCTZ74v7bb+ZALR6wmh3NXSe+BlwHDPWMhy2wO6pMmX2masFW2wXgrTypSrDoA3TC08p4IBAchZH6WKcosy2LJGF7q45ED6sb/FdZ40f4Pckv01g5DnGVx4ZSDrSRCYLnMNmp5VgyWVTnLx/adAXnHK8EFhshBbwvNUoRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709829872; c=relaxed/simple;
	bh=mlns9NU2Dne6s/socOBLacCBUbKHyesM6TedMyS6WYw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2Ef9KxbnJL2NyW3fIfGx84gJ0F/kYXc6QZ9wkhxJ/iGC2eyISkAijJoThPAaR9u/Sasz+dxF0uyZIEloRTuqiyFAUaw3h1aE2Q3qMz4PURAog+2jKMQJSczu3gxnWwgbL+l7iMHwsVELKfrBby8ihjjMJiUrVqL7O3SRshfMuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riGr0-0000SI-Qa; Thu, 07 Mar 2024 17:44:22 +0100
Date: Thu, 7 Mar 2024 17:44:22 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/5] parser_json: move list_add into json_parse_cmd
Message-ID: <20240307164422.GN4420@breakpoint.cc>
References: <20240307122640.29507-1-fw@strlen.de>
 <20240307122640.29507-3-fw@strlen.de>
 <ZenP32bq9xtJglJQ@orbyte.nwl.cc>
 <20240307151005.GM4420@breakpoint.cc>
 <Zeni1X75HHJYpu_l@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zeni1X75HHJYpu_l@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> So IIUC, JSON parser will now collapse all new ruleset items into a tree
> and use the existing nft_cmd_expand() to split things up again. This may
> impose significant overhead depending on input data (bogus/OpenShift use
> cases involving many chains maybe) on one hand, on the other might allow
> for overhead elimination in other cases (e.g. long lists of 'add
> element' commands for different sets in alternating fashion).
>
> We may want to do this for standard syntax as well if the benefits
> outweigh the downsides. Thus generalize the JSON-specific helpers you
> wrote for use within bison parser, too?

It tries to do same as bison parser when using nft -f with a standard
'list ruleset' input.

A 'batch file' with sequential 'add table x', 'add chain x c' etc.
does separate 'add' requests.  The json parser is supposed to follow
this, i.e. 'ctx->in_ruleset' is only supoosed to be set when this
is a json listing, not when some input daemon is feeding independent
add requests.

> An alternative might be to reorder code in table_print_json_full(),
> copying what nft_cmd_expand() does for CMD_OBJ_TABLE. AIUI, it should
> solve the current issue of failing 'nft -j list ruleset | nft -j -f -'
> for special cases.

Its indeed possible to reorder things but I was not sure if there is
a simple way to do this.

One case is 'verdict map', where the elements need to be created
after the chains.

The other one is rules, those need to come after the chains.

So what could work is:
1. tables
2. chains (but not rules)
3. flowtables
4. objects
5. maps and sets
6. map/set elements
7. rules (they could reference maps and sets or objects)

If you prefer to resolve it by sorting the output (input) as needed
please let me know.
