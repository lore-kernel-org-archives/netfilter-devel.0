Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DBA2EA48E
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 09:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760951096; cv=none; b=Rs7R4AwILpq+uPg4OeHNRh+N4IduVFcOLcgyU5/L8ZgXjNYpZi7gIBph2kaht5MFzeyB4n6i9YvInprqGy0GA865lWEGEJ4XfUnGuY88SCFZ8hSdc+1GOTBYkxa3lgETLcnR754WK8O7QpXuluCwwQ7Swv/KU0kKbyBumHXxmbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760951096; c=relaxed/simple;
	bh=I0azBmpeajdL7nLLvIjmVbhFKsHpG+fxlzfnSDCmWpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eyVh/NdXf9uU+byjB4HFpbUe7B/BhBruAzZZ8yvt4XOBIUkCK7ObJ8S13PW8XEbhxlmMOAsM2kofP4fGhbBg6w8KnsXnWvRsNmN0g43jDg/kNvcw0XiPInRfkb+k5bUSQMPIbJUKBOONIz5a0cbLgCD2IcteZL0mAfHs77T5arc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F1E1D61117; Mon, 20 Oct 2025 11:04:47 +0200 (CEST)
Date: Mon, 20 Oct 2025 11:04:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v3 2/6] doc: minor =?utf-8?Q?im?=
 =?utf-8?Q?provements_with_respect_to_the_term_=E2=80=9Cruleset=E2=80=9D?=
Message-ID: <aPX7Ly8FcFTW8RE3@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
 <20251019014000.49891-3-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251019014000.49891-3-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> Statements are elements of rules. Non-terminal statement are in particular
> passive with respect to their rules (and thus automatically with respect to the
> whole ruleset).
> 
> In “Continue ruleset evaluation”, it’s not necessary to mention the ruleset as
> it’s obvious that the evaluation of the current chain will be continued.
> 
> Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
> ---
>  doc/nft.txt        | 6 +++---
>  doc/statements.txt | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 78dbef66..49fffe2f 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -932,9 +932,9 @@ actions, such as logging, rejecting a packet, etc. +
>  Statements exist in two kinds. Terminal statements unconditionally terminate
>  evaluation of the current rule, non-terminal statements either only
>  conditionally or never terminate evaluation of the current rule, in other words,
> -they are passive from the ruleset evaluation perspective. There can be an
> -arbitrary amount of non-terminal statements in a rule, but only a single
> -terminal statement as the final statement.
> +they are passive from the rule evaluation perspective. There can be an arbitrary
> +amount of non-terminal statements in a rule, but only a single terminal
> +statement as the final statement.

This is not really ideal as its hard to see what changes.
I will apply this like this:

-they are passive from the ruleset evaluation perspective. There can be an
+they are passive from the rule evaluation perspective. There can be an

... as its much simpler to see the actual change without any of the
formatting changes.

No need to re-send this patch.
