Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58554185B56
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731000811; cv=none; b=D8f1kSqjkvcT4zQQgHKRpUXFLmN6jvereH3J5nTJWL26GK1eklKRAP6U878nfKbcC4byXXCXuaBinJ2NgNX+Q4HOoJphnmMrHfPzy7I9CVl+N75SA1jVL927Z24xv+1acnZLMKn0nVtThLXyHocXDfSgjDBA7V89fpp47HVgkf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731000811; c=relaxed/simple;
	bh=xSlyG0t06zAHAefo88/wwHPOHl5xI4FMjwor8itpGlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYVUPkZjtj2dhOfSIU5XshVUxWTojRm1fLiVVCI6phxZGTtqymWLscLwBLtN13ZWv1CNbSEm2asEto+P9fCYdvb6FVURGix3u6yHeqXa6zqghSM/FXo0jebesRunZQ3VwV4+KVMsOjJkOgzQ73eRhj50UnZsngp3jccb5xh8sDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=d+1lA4h+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="d+1lA4h+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pWo5ra9W8npV+Tbl8j7zGF8tnFPdfwJbJlhask9fp38=; b=d+1lA4h+2Q8Y7BlMjf6gWzQtAz
	0iIBWmp3uQt0+UPribyszMKEdnbKt8vtqM6WqMuoYtRIlP7u7svqJLNNb+nvzNvwdxFxyJ4MXy48I
	geB8DGSwfFRH0stZ5hgm73splYcGmCUKCw8Eao2ESI5Wofw0Ko1bn+cXqkkXqnhFULej+UCyFKek8
	CnD2DyWTe+5NaTBUS9J4xFms/PIkYWmhnRY5s6VVssTbl0v3jQvhVt/E52ThJaxEJVN3sUkdUvwDm
	pAlJa7p4Ik/BJAPjBAVd3pa4s7skc0OPEv9TJ1nCozo+0sKjqpDz9W0CAFmXua8kbKguG12WfRLLf
	BXtn6cew==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t96Nq-0000000067H-3nUO;
	Thu, 07 Nov 2024 18:33:27 +0100
Date: Thu, 7 Nov 2024 18:33:26 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] tests: monitor: Become $PWD agnostic
Message-ID: <Zyz55j3XMzjUpIpg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20241107134636.9069-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107134636.9069-1-phil@nwl.cc>

On Thu, Nov 07, 2024 at 02:46:36PM +0100, Phil Sutter wrote:
> The call to 'cd' is problematic since later the script tries to 'exec
> unshare -n $0'. This is not the only problem though: Individual test
> cases specified on command line are expected to be relative to the
> script's directory, too. Just get rid of these nonsensical restrictions.
> 
> Reported-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
