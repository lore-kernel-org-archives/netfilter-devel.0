Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1A26989E
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741882291; cv=none; b=vFIPaxAJItoodh0UPsMklXkFOuc30grVRKdBZhgg8zUCo/ZMET27qMqNvtZbe1TDIYAaGGMPDKtJ0wU5Nt098thIWt4pTDBshIWygahjKk93ouKdvhMl02LgOr3oaPprSMhfm1yyQc0rNps0WAEGZoFuc1HK+aRoQqBdIEZPk9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741882291; c=relaxed/simple;
	bh=X9/7/nJR9eOZXCN/aMwz9vOV6gtUP9qMPvH4vVJAVf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPfvKZ1hGoZ4yCWqpUPD7o8ifijFrvHIK/bVlP4vAXmzgqgvQP1pacevaNjUMq5dJKWzTZu6Mu1XSaF0RdHPmYTguu4HETElgasEb5vUGCdVT4D56a859f5IxJIqrc23u2T24sqTIT+moPeCiWC7Wt50AcWjgkSbfMJTCZDqxgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsl9U-0004Qa-MW; Thu, 13 Mar 2025 17:11:20 +0100
Date: Thu, 13 Mar 2025 17:11:20 +0100
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?0JXQs9C+0YAg0JHRg9C00Y7QutC40L0=?= <zhora.budyukin111@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Minor memory leak at iptables/nft.c
Message-ID: <20250313161120.GC32238@breakpoint.cc>
References: <CAAv0m29bukaAnKkM=ht2vPA=0_8Fii24aSTj4MMcXTW5kNJJkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAv0m29bukaAnKkM=ht2vPA=0_8Fii24aSTj4MMcXTW5kNJJkA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Егор Будюкин <zhora.budyukin111@gmail.com> wrote:
> I'd like to propose a patch fixing a minor memory leak found with a
> static analyzer. It can be found at __add_target and __add_match
> functions, where info is callocated as a buffer and not freed
> afterwards.

I don't see a bug in either of these functions.
struct nftnl_expr assumes ownership of the allocated blob.
