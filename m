Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE44C2CCDF
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 13:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709905049; cv=none; b=Xdl4vYssu6KXe4dA/HJkrT5FEIQnxevAcRgpRpASERFx49lcJpP9wYgTA/7dTQZ3u5foiTWsEue2Lhgns8RyaJF8bQFG61/WcGeLnUTv0vukFTlrDUOND9SNc7b9qj1vUj5rhNyNjeDd8pIaxx5ChH0A5pvbv+H2t1kiuNKi3eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709905049; c=relaxed/simple;
	bh=AyslgvXLwJ2nzUiICHc011KPyGPw3iphDsgndpOkEq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHnyugvm064Er88IezSdL/yeNxzqLDqgs3kHa9fqblSakF/fH+0KsK2yppJBAKDvHKco/yrCE6vgdotV0FT3pdZfmihO8jChOhO7ACbOXkVW//GaH4GRugBQ8rUCO65X2hEoJsj650M1hxIGRAqoF6LhVIwQAJgrrdfS5E9MvrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riaPW-0007xQ-R5; Fri, 08 Mar 2024 14:37:18 +0100
Date: Fri, 8 Mar 2024 14:37:18 +0100
From: Florian Westphal <fw@strlen.de>
To: Sriram Rajagopalan <bglsriram@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables-nft: Wrong payload merge of rule filter - "! --sport xx
 ! --dport xx"
Message-ID: <20240308133718.GC22451@breakpoint.cc>
References: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sriram Rajagopalan <bglsriram@gmail.com> wrote:
> diff --git a/src/rule.c b/src/rule.c
> index 342c43fb..5def185d 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -2661,8 +2661,13 @@ static void payload_do_merge(struct stmt *sa[],
> unsigned int n)
>         for (j = 0, i = 1; i < n; i++) {
>                 stmt = sa[i];
>                 this = stmt->expr;
> -
> -               if (!payload_can_merge(last->left, this->left) ||
> +               /* We should not be merging two OP_NEQs. For example -
> +                * tcp sport != 22 tcp dport != 23 should not result in
> +                * [ payload load 4b @ transport header + 0 => reg 1 ]
> +                * [ cmp neq reg 1 0x17001600 ]
> +                */
> +               if (this->op == OP_NEQ ||
> +                   !payload_can_merge(last->left, this->left) ||
>                     !relational_ops_match(last, this)) {
>                         last = this;
>                         j = i;
> 
> Please review the patches above and provide your feedback. Please let
> me know of any questions/clarifications.


Probably better to do:

diff --git a/src/rule.c b/src/rule.c
--- a/src/rule.c
+++ b/src/rule.c
@@ -2766,7 +2766,6 @@ static void stmt_reduce(const struct rule *rule)
                        switch (stmt->expr->op) {
                        case OP_EQ:
                        case OP_IMPLICIT:
-                       case OP_NEQ:
                                break;
                        default:
                                continue;

