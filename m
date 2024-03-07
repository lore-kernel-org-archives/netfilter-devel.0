Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841BA12F5B0
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709834335; cv=none; b=e3XDncijT72cT0NZJ6JnZPFVBw8fHHfg8DULYF/ebp5jz1btijhxAGt5jfovWPR2oy4qwBETSz4tjLeSjG5CHQaLDXvL5RUYu32ihq3gP8KB3iMwaN7+gTTTVIH6HWu9O2AinAuEKyYFDf9zMX2fwbxGQ5MsMov+V0tm/FNaDGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709834335; c=relaxed/simple;
	bh=myLEe9YeWMznT83DA+sIK8V8QHgqdgrWh+PBMUNSbtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O17BMMVvi4wzbaPA0Wxag9yCuvCkI2/MKWLzU73cxQeXa6AKgpzIAYSmXQWOofcpNaMGSFaYoQBBQBe5Hsaysw52mJHjcjANapq4MIcSrvEIY1EpvPFLBeYlXjddLoUvQ+J7kBHsHnrHNkhl52NX8RBcucKiVrJXRVT5PyvySbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=i2SOKKNA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="i2SOKKNA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Kyk/f5Tur9ex+9AaqrVj+4UodiHA+Dh+jGmOYSC2RQs=; b=i2SOKKNA4qUJT19BoHKXLcu6XV
	G9uqYG/kClK7QlXgt5uoy4le/D/GBGEzIoLIZDR1aDJotPA4JcmIF8YhPUOdk0cI8sIGqnbJjGsVJ
	etVdWY5vfLuBAwmy8drDc6pEHQ2rhsFfTA1kHcAEGNByTp5Gp28YGaySA8dYg+zuCyZUGhfZG++Wu
	581+Fsy6CiPzDQL1X1QKK1vvgA7Sdd+yylywz2TU2tHwlvJM0b4RpcjTl+uSIBJ+LKK0HKIqyitAk
	76JowNufN35W6SRZ/8Wkpochu/uwmWq1TN5B6G+d5S9xr9d0zStPE/gnjPB8Ak9Zjo1OyjTKgY6CM
	bl9nEa1Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riI14-000000008G2-2BjQ;
	Thu, 07 Mar 2024 18:58:50 +0100
Date: Thu, 7 Mar 2024 18:58:50 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/5] parser_json: move list_add into json_parse_cmd
Message-ID: <ZeoAWivnRYDjrpfo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240307122640.29507-1-fw@strlen.de>
 <20240307122640.29507-3-fw@strlen.de>
 <ZenP32bq9xtJglJQ@orbyte.nwl.cc>
 <20240307151005.GM4420@breakpoint.cc>
 <Zeni1X75HHJYpu_l@orbyte.nwl.cc>
 <20240307164422.GN4420@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307164422.GN4420@breakpoint.cc>

On Thu, Mar 07, 2024 at 05:44:22PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > So IIUC, JSON parser will now collapse all new ruleset items into a tree
> > and use the existing nft_cmd_expand() to split things up again. This may
> > impose significant overhead depending on input data (bogus/OpenShift use
> > cases involving many chains maybe) on one hand, on the other might allow
> > for overhead elimination in other cases (e.g. long lists of 'add
> > element' commands for different sets in alternating fashion).
> >
> > We may want to do this for standard syntax as well if the benefits
> > outweigh the downsides. Thus generalize the JSON-specific helpers you
> > wrote for use within bison parser, too?
> 
> It tries to do same as bison parser when using nft -f with a standard
> 'list ruleset' input.
> 
> A 'batch file' with sequential 'add table x', 'add chain x c' etc.
> does separate 'add' requests.  The json parser is supposed to follow
> this, i.e. 'ctx->in_ruleset' is only supoosed to be set when this
> is a json listing, not when some input daemon is feeding independent
> add requests.
> 
> > An alternative might be to reorder code in table_print_json_full(),
> > copying what nft_cmd_expand() does for CMD_OBJ_TABLE. AIUI, it should
> > solve the current issue of failing 'nft -j list ruleset | nft -j -f -'
> > for special cases.
> 
> Its indeed possible to reorder things but I was not sure if there is
> a simple way to do this.

It seems there is! Taking nft_cmd_expand() as an example, all that's
missing for table_print_json_full() is to move (bare) chain listing
first and later list rules only instead of chain + rules. I have a patch
at hand and am currently tickling the testsuite to get things tested. It
should work though, because what nft_cmd_expand() does is proven to
work.

[...]
> If you prefer to resolve it by sorting the output (input) as needed
> please let me know.

I'm more confident with the reordering as it must work. Your approach is
interesting, but it may fail if e.g. input does not contain the table
(user knows it exists already). Though it may still be of value for
other purposes. Also my "reorder output" approach does not cover for
user-compiled input (although one may call PEBKAC there).

Thanks, Phil
