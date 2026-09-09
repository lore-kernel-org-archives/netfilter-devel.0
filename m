Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778073D904C;
	Wed,  9 Sep 2026 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788997655; cv=none; b=UkXjr+nJXcFV4C9+WmEtSU7wqd81k5OsxuH2FWXtLY9Lrm/XYAPPiS5YGeF64d3B2XhzTmTxiPCzTd5lq5LQQ3epmNGW07VLbNvXa37uMq930ioVbtRuaKNsfybhXlh0n2pdB7pV95i/2aCwUj9xjrfEmDhJ+QqGBHKT3ee63rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788997655; c=relaxed/simple;
	bh=0t6cdrJ/tKGuxLRXtQjmTVjitEIU8/2a3+rWRTEdtkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtarZTImKkbPVckk7IEDO4e7eksKaod5Kw56ZSimuZFWhOwaw5hkVlOKkuJbUmAxk8IZOal1QVrdsyAP99qO2Eb37CK+45vqwwDpjRsFTGZ7yQkPQhA7I2bk6wWWsqrM8wzTUHM7jYH4zn9yXVKJEA5nJzsx+3OsdkNjU9p3Krc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IawtIx/j; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IawtIx/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788997651;
	bh=s8c8MvSOry5EphrDBQ5cN5s4Lt4IV9yYz4/fimO2gOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IawtIx/jDOyMPg9JdohgEEflDZAEI05acWU7Heq16v0GfBq8e+KUmLqN4RyVhA9oF
	 zjKO/htdM9sxfYevBbYyBwuXpjzPWg8vN+44c6xOM85O76g4wbOTE4KeIRBX7tS/Th
	 +YBzOChS3wUjk8wUFOkY/C6eKkcEtppn2gfMO4jUthevshYjUdzlhks9TtBRlnwZMp
	 9susHoJesG6+7bmVLmj+xato7H0NMsbWZlC6X8lS/jYjicP1bx07+FKw0xjYEU3FF5
	 Dpm0Zxs4w+sxWqYXDaCSjone8tkHGGtt0ynbDm1ADPrGrTQSs6vwnPA0Kx0DYz0rVO
	 WbGMqUJaZtqEA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E5FAF607BE;
	Thu, 10 Sep 2026 01:47:30 +0200 (CEST)
Date: Thu, 10 Sep 2026 01:47:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julian Anastasov <ja@ssi.bg>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 06/12] ipvs: bound LBLCR and LBLC cache growth
Message-ID: <aqHwEDfPTQBcLH2m@chamomile>
References: <20260903004149.1037028-7-pablo@netfilter.org>
 <20260904020140.3549818-1-kuba@kernel.org>
 <0afb3b53-f4b5-7cb8-0f06-7582a50ef83b@ssi.bg>
 <2051dadb-fa1a-02bd-42fb-57719e6acb7c@ssi.bg>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2051dadb-fa1a-02bd-42fb-57719e6acb7c@ssi.bg>

Hi Julian,

On Wed, Sep 09, 2026 at 03:24:48PM +0300, Julian Anastasov wrote:
> 
> 	Hi Pablo,
> 
> On Fri, 4 Sep 2026, Julian Anastasov wrote:
> 
> > On Thu, 3 Sep 2026, Jakub Kicinski wrote:
> > 
> > > This is an AI-generated review of your patch. The human sending this
> > > email has considered the AI review valid, or at least plausible.
> > > ---
> > > ipvs: bound LBLCR and LBLC cache growth
[...]
> > 	Yes, we remember this place from the previous Sashiko
> > review but the new change depends on the current patch to
> > apply gracefully.
> 
> 	I expected this patch to be applied before posting
> a separate fix for the missing atomic_dec(&tbl->entries).
> Another option is to post the atomic_dec fix on top of the
> current patch or better before it, so that both can be applied together.
> If needed, I can repost them together in a new patchset, so that
> they can be reviewed together properly.

Apologies for the inconvenience, I decided to keep back the three
patches that LLMs are barfing when I saw the "Changed Requested" label
in patchwork. Too bad.

Please, go ahead post them together, including a cover letter
explaining the logic, when bugs are multidimensional, LLMs become a
bit strict because they want you to fix all at once, that's hard.

Thanks.
