Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC001A23A9
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2025 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760529081; cv=none; b=BzOClJd1VNTHxtzoyx7kfUPhd/jxqhg+9PLwXFEAuusW26MaoEym5JizObrYVAMDS0VOpW76qPydc3AmoiBHhS6Z+RMux11KhNkcZZxBOWFYfMJjnbqTI2ZMM1xe6RSYdY1O9FXa7J/WLKuqXBwQjobtJCFy1NRPNEepUXcjr0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760529081; c=relaxed/simple;
	bh=ZOzvR+1X1LwQehYjqAVMrPzgWutCY5M5Qdb/XIhgcAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LFflOCrqrDwA1ltNjNe+rXnUDx5WcgA0AnzXEGbKEEQAFieXg7WWqn6OaV2GA+CT3rOnJPvpuubrihn6nPYuimCn0o9Rf1DHJrzPQhkB21wBYHqpgdn1eKeLqYBnqqU8gU640QYvXjR5ol6pmHCOy9AijBb1msZzu3UvnWxfTLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6BE0360156; Wed, 15 Oct 2025 13:51:17 +0200 (CEST)
Date: Wed, 15 Oct 2025 13:51:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 3/7] doc: minor =?utf-8?Q?im?=
 =?utf-8?Q?provements_with_respect_to_the_term_=E2=80=9Cruleset=E2=80=9D?=
Message-ID: <aO-KtYJ46NfLYtiM@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-4-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011002928.262644-4-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> Statements are elements of rules. Non-terminal statement are in particular
> passive with respect to their rules (and thus automatically with respect to the
> whole ruleset).
> 
> In “Continue ruleset evaluation”, it’s not necessary to mention the ruleset as
> it’s obvious that the evaluation of the current chain will be continued.

LGTM, can you rebase this on top of nftables.git?

I doesn't apply without the preceeding patch, but I don't want to
apply that one, yet.
