Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556A43F092
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 09:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316432; cv=none; b=e6MHo2yTWT0l+Afz+ch1wvSk8RqI+L11snMDdF38Ocqb+XrFk/aAN3A+4ioxyfAd0Q49xJmyOb32FThhSS68xeZT2YgtMMupsm8zKW6HdOZvsmtsD2HmRM1MM6qJKBeEFfTbDSempgyGkcGKxMALyX0Bdlx8UUZWhugWI3t+7hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316432; c=relaxed/simple;
	bh=iMFetc8RO3lHnLMAyfLE1xjKMotFZ/HKUFXa39DZCVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZmCI4iK+auMRNMEWEY2jz4WnxSIJ+EGFflLe99KWAH79WkryvjlCtga4ziCZDcsHIsMjKuIrGhNGYcf6lx162GrkFKWY5DQOE58RHwVJ1MA/2e6H/zBtWElEFUtjJvVeAFYWi2Md2Bo+JjhStj3lIB1ffrt3t57IE0ex9QsJ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HZq9EWfA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HZq9EWfA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KdUld00d3gKgU4U10UPG2RLAMQCIAofR4hibvQzEdos=; b=HZq9EWfAE2gpsMjpEN94uqyt8J
	7EerS2ifRiiLIgNA8bbYCoCdYq45WSeTlDBhOvHBoagPqBDQtfeBmDh25F5k/YY77XRCJSOXtA+w/
	rLPvYNklhyGaVNvmKgDX8TAb7/JnCqovddQlSe4MQBSOeiBUAyc2ccOOIf8CCY/QVbjPhRg/o0Jzc
	WzAHYTQLshQMhL380OeGeGktxoeTFHvh8mbqW3/LhhlHO1J9uNZA8xI/iTvNTtbkHtqbPYoVegC87
	/lPkwyh6NzCymkMwLDosAKB8Kp/EA2z/TyQD8fOqBELu7fNaBZdVR/cZCLh3xVPx2HIszEcO5Lpy9
	1jy99HTw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wp0MF-000000006im-1Ovg;
	Wed, 29 Jul 2026 11:13:47 +0200
Date: Wed, 29 Jul 2026 11:13:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Avinash Duduskar <avinash.duduskar@gmail.com>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Message-ID: <amnES354HC-zVZJQ@orbyte.nwl.cc>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com>
 <amjWjTkt1Dsh66Xv@orbyte.nwl.cc>
 <amkAJuVZmpGy7pvY@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amkAJuVZmpGy7pvY@chamomile>

On Tue, Jul 28, 2026 at 09:16:54PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 28, 2026 at 06:19:25PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Mon, Jul 27, 2026 at 01:54:27PM +0530, Avinash Duduskar wrote:
> > > Once a cgroup is removed there is no path left to resolve, so the listing
> > > falls back to printing the raw id:
> > > 
> > >   # nft list set ip t s
> > >   table ip t {
> > >           set s {
> > >                   type cgroupsv2
> > >                   elements = { 50834 }
> > >           }
> > >   }
> > > 
> > > That output is not valid input. cgroupv2_type_parse() only stats
> > > /sys/fs/cgroup/<identifier>, so handing the id back fails:
> > > 
> > >   # nft delete element ip t s { 50834 }
> > >   Error: cgroupv2 path fails: No such file or directory
> > > 
> > > The element cannot be addressed by key at all once its cgroup is gone,
> > > which leaves flushing the containing set as the only way to remove it.
> > > The json dump does not reload either, since the id is serialised as a
> > > string and reaches the same parser.
> > > tests/shell/testcases/packetpath/cgroupv2 works around this in its
> > > cleanup(), added by commit 9fbc77c127e7 ("tests: shell: add cgroupv2
> > > socket match test case"), because "nft can't find the human-readable
> > > names anymore".
> > > 
> > > Take the id back when the path does not resolve, accepting a decimal
> > > number and nothing else. integer_type_parse() converts with base 0 and
> > > expr_evaluate_integer() does not check the sign, so it would take "0755"
> > > as 493, "0x1f" as 31 and "-1" as 1; strtoull() alone still accepts a
> > > leading sign or space. Requiring a leading digit closes both. The path
> > > lookup stays first, so a cgroup named as a number still resolves as a
> > > path.
> > 
> > So with nft printing non-existent cgroup names using PRIu64 and parsing
> > code still performs the path lookup first, what is all the fuss about
> > non-decimal number input?
> 
> They claim they cannot delete entries via numeric value, it seems.

Sure, I wondered why parsing must be so strict. If the string we get is
not a known cgroup name, something's odd anyway and I don't see the
problem if the fallback parser also accepts hex and octal or even
negative values and whitespace-prefixed number strings.

Is it true that integer_type_parse respects negative values as such?
Because that void avoid the mentioned issue of '-1' becoming '1'.
Negative values would just not match.

IMHO we should once try to change symbol_parse to try basetype parsers
also if the dtype parser is present but fails. This might simplify some
datatype parsers. Or cause a big mess because "anything" may then be
written as a number. :D

> > > A plain decimal name that does not resolve now becomes an id rather than
> > > an error, the way meta skuid falls back to the numeric uid when there is
> > > no passwd entry. nft accepting what nft printed is worth more than
> > > diagnosing a mistyped path.
> > > 
> > > Fixes: 38228087252c ("src: add cgroupsv2 support")
> > > Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
> > > ---
> > > cgroupv2_type_print() still ignores -n and prints the resolved path when it
> > > can. This patch only makes the id nft already prints acceptable as input;
> > > making the print side honour -n is a separate change.
> > > 
> > > dumps/cgroupv2_stale_id.nft is empty and the json dump is the metainfo
> > > boilerplate, because the test leaves no ruleset behind and the ids it uses are
> > > not stable across runs. There is no .nodump, so the dump comparison still runs.
> > > 
> > > No NFT_TEST_REQUIRES: the test uses no socket expression, so neither
> > > NFT_TEST_HAVE_cgroupsv2 nor nft_socket is involved. It skips with 77 without a
> > > writable cgroup2 mount, and the json arm skips unless -j actually works.
> > > 
> > > Searched the netfilter-devel archive for cgroupv2: 133 messages, 2021-04-21 to
> > > 2026-05-28, none proposing that a numeric id be accepted on input.
> > > 
> > > Tested on b315dd55 with a libnftnl built from git 363b0e3, since master needs
> > > nftnl_set_elem_set_imm which is not in libnftnl 1.3.1. The suite gains this one
> > > test and no regressions; two pre-existing failures are unchanged with and
> > > without the patch.
> > 
> > Is this AI output?
> 
> Looks like so, yes. It is very cheap to write lengthy reports these days.
> 
> We will soon have to funnel this text to a LLM to "please, summarize
> in a terse description what this user reports", then write a reply and
> say "please expand it to make it as lengthy but formal as you can" :-)

That's an interesting approach, indeed! Reading the lengthy reports
causes extra work, so make it more expensive for them by requesting more
elaborate reports.

Cheers, Phil
