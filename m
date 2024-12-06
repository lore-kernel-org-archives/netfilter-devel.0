Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540E41AAA2B;
	Fri,  6 Dec 2024 20:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733518719; cv=none; b=NLVaHm7mdd/cMrZaxboj+VdoKT9uK0nQOX/znDyGflM3oeCBCg7nL90oaFYzoF81plANBwCDnB43Zs/nQ9dIsluP/BF9z+tCgXwjxYet1o8kJMPfcErZBq+dk6C9qVb/aZKPpqRrAh+5y4hn5JHZTP0OPXG0aCIbHtXfivuwXlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733518719; c=relaxed/simple;
	bh=W2maDa1Gl94YQC1GdMNwaimsBgJBUMXVg6CCTmDJu7I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l4MXfjZu7GEeV0bJohdkwSOwES3G/BSI9cFdgrQduZUgHEte9p0ST1naqTrLsx4G4n6DA4bnCRHlcwEK+EPIzHAHu9WK3QYqHVYk81K+WcxglfToIHjT/e4sPQuKSBWXsL8bZkraDuqnTkRJPkzGb9Tq+8qG8mj9EQIpE0yKX3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=t3UsSFDI; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="t3UsSFDI"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 6ECDA21D93;
	Fri,  6 Dec 2024 22:58:30 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=4mzhTxfyer3pXCCutNPdBm4ebsOpNX+qmHb589hpJEA=; b=t3UsSFDIjjo9
	9YpFOYo1J/D81iTJz2RzrFXKfmaII/WXesh0Dc5N5on1An9bH1QWb8nB3oGH9Tg2
	fkjTeWyzosNG0cbUqMOXnl2tGM4hYQ0Vcu1rBhT8A4LZDrdq9M5sQQ/RqQ6cnnSj
	c0Bqv5LmmMCWq3vN1LqP+9trPWhMEgY2LVp6DkjdNYfgSVxLdoH/7v2lp0045qYk
	0N+zLxweluiNWZaF98nN4XdK8VIfLEQtOK1+o0AP5utHqlCnK6lWeLGeFp1e9FFO
	u9fteAPfLaSBSl9IundxYpH2Y/9QtA6MlBZ/3hGleSL6YA5NlgnuZKtlTLMQl2To
	wTju1EWyMr6FY9eT5SxiEagKeC8mN+qwDD3e6eay06fnLTjqQur7NKPQaIe2fD6a
	rdOkcJ+jf0moCEVA83RCsajcOJYcDtAqqnvtgyNkCiMD21mS5PkGLpFaNVt/Ks2/
	+/lkEygRzXTllCnvCiZgSyWdAOMpcGauqlbJcBzyFTqw7dqEd1s//YcqSkCch8fB
	BLoPR9dEG+4YKgDcyZCXmsHsmXc0Ax35NkPEvvCBSVIPY2vfrsMcHHfz63FshGaw
	rr11pPRVHEk/KluC97orXlAvJJnCVtGwFl1sVwSGP2ZgfY0hIeRRhp4OKPGFJ+ng
	1lc0gwoEI8v7LIG4fRcDT+rGr46d9Q0=
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri,  6 Dec 2024 22:58:29 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by ink.ssi.bg (Postfix) with ESMTPSA id 34E4315F19;
	Fri,  6 Dec 2024 22:58:17 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.1/8.17.1) with ESMTP id 4B6KwDGo064449;
	Fri, 6 Dec 2024 22:58:14 +0200
Date: Fri, 6 Dec 2024 22:58:13 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: David Laight <David.Laight@ACULAB.COM>
cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "'Naresh Kamboju'" <naresh.kamboju@linaro.org>,
        "'Dan Carpenter'" <dan.carpenter@linaro.org>,
        "'pablo@netfilter.org'" <pablo@netfilter.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'lkft-triage@lists.linaro.org'" <lkft-triage@lists.linaro.org>,
        "'Linux Regressions'" <regressions@lists.linux.dev>,
        "'Linux ARM'" <linux-arm-kernel@lists.infradead.org>,
        "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Anders Roxell'" <anders.roxell@linaro.org>,
        "'Johannes Berg'" <johannes.berg@intel.com>,
        "'toke@kernel.org'" <toke@kernel.org>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>,
        "'kernel@jfarr.cc'" <kernel@jfarr.cc>,
        "'kees@kernel.org'" <kees@kernel.org>
Subject: RE: [PATCH net] Fix clamp() of ip_vs_conn_tab on small memory
 systems.
In-Reply-To: <494a4dc2ba2041dfb9f45d86e972b953@AcuMS.aculab.com>
Message-ID: <184af1fd-2bc4-11c1-9319-0ca879e53d99@ssi.bg>
References: <33893212b1cc4a418cec09aeeed0a9fc@AcuMS.aculab.com> <5ec10e7c-d050-dab8-1f1b-d0ca2d922eef@ssi.bg> <2a91ee407ed64d24b82e5fc665971add@AcuMS.aculab.com> <c0a2ee53-f6ff-f4d4-e9ab-6a3bf850bec5@ssi.bg>
 <494a4dc2ba2041dfb9f45d86e972b953@AcuMS.aculab.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Fri, 6 Dec 2024, David Laight wrote:

> From: Julian Anastasov
> > Sent: 06 December 2024 16:23
> ...
> > 	I'm not sure how much memory we can see in small system,
> > IMHO, problem should not be possible in practice:
> > 
> > - nobody expects 0 from totalram_pages() in the code
> > 
> > - order_base_2(sizeof(struct ip_vs_conn)) is probably 8 on 32-bit
> 
> It is 0x120 bytes on 64bit, so 8 could well be right.

	That is already for 9 :)

> > > Is all stems from order_base_2(totalram_pages()).
> > > order_base_2(n) is 'n > 1 ? ilog2(n - 1) + 1 : 0'.
> > > And the compiler generates two copies of the code that follows
> > > for the 'constant zero' and ilog2() values.
> > > And the 'zero' case compiles clamp(20, 8, 0) which is errored.
> > > Note that it is only executed if totalram_pages() is zero,
> > > but it is always compiled 'just in case'.
> > 
> > 	I'm confused with these compiler issues,
> 
> The compiler is just doing its job.
> Consider this expression:
> 	(x >= 1 ? 2 * x : 1) - 1
> It is likely to get converted to:
> 	(x >= 1 ? 2 * x - 1 : 0)
> to avoid the subtract when x < 1.
> 
> The same thing is happening here.
> order_base_2() has a (condition ? fn() : 0) in it.
> All the +/- constants get moved inside, on 64bit that is +12 -2 -1 -9 = 0.
> Then the clamp() with constants gets moved inside:
> 	(condition ? clamp(27, 8, fn() + 0) : clamp(27, 8, 0 + 0))
> Now, at runtime, we know that 'condition' is true and (fn() >= 8)
> so the first clamp() is valid and the second one never used.
> But this isn't known by the compiler and clamp() detects the invalid
> call and generates a warning.

	I see, such optimizations are beyond my expectations,
I used max_avail var to separate the operations between
different macro calls but in the end they are mixed together...

> > if you
> > think we should go with the patch just decide if it is a
> > net or net-next material. Your change is safer for bad
> > max_avail values but I don't expect to see problem while
> > running without the change, except the building bugs.
> > 
> > 	Also, please use nf/nf-next tag to avoid any
> > confusion with upstreaming...
> 
> I've copied Andrew M - he's taken the minmax.h change into his mm tree.
> This is one of the build breakages.
> 
> It probably only needs to go into next for now (via some route).
> But I can image the minmax.h changes getting backported a bit.

	OK, then can you send v2 with Fixes header, precised comments
and nf tag, it fixes a recent commit, so it can be backported easily...

Regards

--
Julian Anastasov <ja@ssi.bg>

