Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD952853F7
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760999052; cv=none; b=LLHugJHlmcr9XuWwpkeNmL3AI1Jsf4XTGtUA9OSDsP/BsrZu8UcNPna0RCHulQK33JaeJ8wXkbodalyjqmjtGiDlN2AXHL6oRpgxHF5C0Xoc12irH6DJpFFR1ruV6rgKxyiIxi1Aqkn2gCC9tyMBacIpFTQuaoLhRE3bCt+ibgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760999052; c=relaxed/simple;
	bh=Edjuh3sEVvL8tNnIMn0RILnTQYEGFAV1OBK+4fWBkXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmIvrckrKDw7Bg63NfmH2WiQE7iFf1IyI34G8grZ0H3MnkOoUoCwYBHvxU4fsORTpiPQvsokXs38fFYnJGmo5gbov4W3RbL+RfsrZvzpHWJrkv2LqnSxExTsdGXsusbaThSpUOFfFQuf5Ye5vDTXvwDiBXHbuAPtXNrvPNPQUEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kDvlhhQu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kDvlhhQu"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0EFD4602C0;
	Tue, 21 Oct 2025 00:24:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760999048;
	bh=5tYGmfwuwCIn+EJfOBSKCnluk8ZiaWyHHCaNcgQvmDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kDvlhhQuDTgcAQvJNh9+OwHIBu17DIYN7TsssEtBQ//lVNvinuOhkUGhQctIAjuAJ
	 NdEdfDtJfuHM6ln7Jd53iqYyUoD2HpB+9NUjdoNvUsCKnwTkgOTVo/N7vJ8b5jgB2o
	 xjQ6XJNyR17ac+O2p8eewSv8kfIizyN3WcqwQfDVm64eoAVSmCk7LG6c2nYZouWVCG
	 b4vIOwYt6jhkxfG3ycAV6UeRo7QOzeXbWOyKLJibaf3j/OOLH3Qny8M5ZdQaI5v+oC
	 LYlvlsFU4/v2P59siHa92vYsZbCwAnbqX2nBdPNk8PbMXBnRA91n1aNODdNgfmWBrY
	 YEfDLGjbAG98A==
Date: Tue, 21 Oct 2025 00:24:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
Message-ID: <aPa2hTdpyAb1y57R@calendula>
References: <20251017115145.20679-1-fw@strlen.de>
 <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>
 <aPTzD7qoSIQ5AXB-@strlen.de>
 <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de>
 <aPZGOudKuDa5HMmS@strlen.de>
 <a641ebd1-c2de-478d-bbba-68eaed580fd9@suse.de>
 <aPaA8itLIaGqDoyM@calendula>
 <aPaIepWRL2u1HsLb@calendula>
 <aPauJ9saxZ-Mn3bZ@calendula>
 <aPa1wsoHHKjZ89hG@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aPa1wsoHHKjZ89hG@strlen.de>

On Tue, Oct 21, 2025 at 12:20:50AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Can this be controlled from control plane instead?
> > > 
> > > Oh well, you refer to the patch that checks this from control plane.
> > > 
> > > I remember an issue with abort path, has this been addressed?
> > 
> > I think this does not handle rule/set element removal with jump/goto
> > correctly.
> 
> I haven't reviewed it yet.  There are buildbot warning reports and
> submitter seems to have abandoned this patch set.
> 
> I will review and toss it if needed, this bug exists forever so its
> not like we must apply this right away.
> 
> If absolutely needed i can scrape time next month to work on this.

I think this is also broken from commit path, when two tables are
validated, first succeeds then the second table fails. Leaving the
first table with incorrect jump count.
