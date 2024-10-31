Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CF919DF62
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 13:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730380055; cv=none; b=Oamu99DeB3je+ykv+BaHlosdMQqahwDl5O3xq80Io72i46NLHQgDHHNxxOlr0vKBYfUqjXmAVAEf9CUmTwhnIDbDt8kHdZJO5Ak/KAgASiDOvVL81WI1aQWt1AJZAzj39GkvwvjDOCWsJVM/h4X0B69KctdNYoCTOsZ75I0naGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730380055; c=relaxed/simple;
	bh=ftHsxWYBKh23h0X3nZAkt1maV+ukmCIaJQgz6qiWnPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJEjfoEKEvS1ns6ac6bFo2XWqhcpahBQhbrXbRwPSjwSYEpenJFIArQUf0xTRt4VKI86Jxg3fxhsQFUcLRMXhf+d4Mo8+atF+GqEIi/NNcyDsk/TSFDVNTMJLbrb+K3pS8ub7cIhpiHkX+GCNhsDPifT2okB/QJRH8Ylm6n8Qq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FiHDkvC1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FiHDkvC1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5xCMiGQexnBtfyoxcdrbaCQWqD7oKAD7KWGJ7ZsX9Aw=; b=FiHDkvC1GDENXBeVfcA3xPj4m+
	zDkBXHP+7uQOW9FIs15jLjIj5AhtxvciLoOoym7UYMWhuyyxhJgmes/XuddvWOjPtvOKNNqiAWjcR
	ccTKDkOdpyK+w1MznEEZuksJYmqkteOvDmFF28gC6ncKoAKSq8NFYqeFHM2spjKFM7Ss6YUBpnife
	URU9h3qb7YHuA4lUwl9m9WmY3NkmMey0PC1IB+Gj6ZG/8aBJkbTwmBKt0F/5YmF/f2PYp5P5veoMT
	3G3ngdZwvLE0mGXWO69NRZyH3fefRu1YmN8WYkhHKweVeLB+hgJZiGYf+F0nVShH+K1eA4jifwqgA
	jSBqs5NA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t6UtX-000000007h5-3FaR;
	Thu, 31 Oct 2024 14:07:23 +0100
Date: Thu, 31 Oct 2024 14:07:23 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: fix up test case breakage
Message-ID: <ZyOBC-BKwa1JqTwa@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241029201221.17865-1-fw@strlen.de>
 <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
 <ZyKnPxdGwh1X3AwT@calendula>
 <ZyKxY6WZJrKioMDt@calendula>
 <20241030232914.GA31019@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030232914.GA31019@breakpoint.cc>

On Thu, Oct 31, 2024 at 12:29:14AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I can also revert the patch if you don't like, but it is saving _a
> > lot_ of memory from userspace for the silly one element per line case.
> 
> I think your patch is fine, the question is if we should ditch the
> test case instead of reordering the expected output.

ACK, that was my thought. Looking at the test case and seeing how later
tests depend on these elements being present, dropping it is not
practical though. We could reorder the I lines to match output, but the
commit is upstream already, so ... nevermind. :)

Thanks for the fix and clarification, guys!

Cheers, Phil
