Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4349E156;
	Mon, 19 Oct 2026 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401496; cv=none; b=HtX8swzqmmnGWSSQMVKIiWYmQ4ijXK3+wc2VEv4CYXk2MuQmVE3HmZxNbaOiA56bs+8J3xgJVGE+2MdOfTTNacdURA3wYV3wof1OncjsJZQJuu/EvoIYgcPdxR+tkS3+qogQ69b9svP6MZl54Gh5rxuuhKcvyAr+qaNvtIWHy40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401496; c=relaxed/simple;
	bh=yFFRhN98+/jrswzSTq+etr5ylTz9gRzvMXmzk+vr3dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFh8Y1W5EQHFEXaHjilkC+bfeaFbo6dpav9z44OQcg7St23UsgZEQVJgaRxBgy8TzaIxV3dOyRU3qqjEhyiweBZDoEzxZ0PhwTa4KI52Z5aFAbppwdRjstlwiAcKFJuw4P38qwFjlKGYWUbCMXnvrlKkOtrWUYHwrPXFCci/lRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NGX8oT+R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NGX8oT+R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792401492;
	bh=zgxFfZwpIWJd2uJFYP/HJwi/ibZolWu4hkfu6Lkz0vQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NGX8oT+RKqnhpXDkC6+6mh14TuN14GFThlORB56uN9nX7tW/K7HTBwrcNetJvtT4V
	 kvTQcFLcXvzMK08Vp3WmoNr9op4flE5CahyTdNxC4CLvGxRVZLPGDUM+CMrLn3vfTM
	 LM6JlEfOi6wq4122FQCyMC4Jn+VwxRJdqGB7oA1QxfbWRvZjQX/XhfnWDYLy6z6+9S
	 s19XzzX2fPegkKyTPasG4ws81B+P4W9NW3V5x1zfGvOZc0JjdoloLgBNUlmdugbRzV
	 7/mC7E94p75AOUhF94pJSQLbmv/1oYn3jNP5Iqu5pT/GnZkJiUX1+h870vsMbCtwhi
	 as8sysIxv5+fQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 84D5B60077;
	Mon, 19 Oct 2026 11:18:12 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:18:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: aojea@google.com, netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 04/15] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
Message-ID: <atXgURtsFB4UFXES@chamomile>
References: <20261018005638.1776148-5-pablo@netfilter.org>
 <179237288267.3135.9555179349652175002@kernel.org>
 <atWhayNce2rqLQUL@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atWhayNce2rqLQUL@strlen.de>

On Mon, Oct 19, 2026 at 06:49:47AM +0200, Florian Westphal wrote:
> netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> 
> @Antonio: TL;DR: if Pablo wants a v2, please send a new patch that adds
> the needed nf_queue_nf_hook_drop() calls in brnf and conntrack.

I'd prefer a follow up once this PR is pulled in.

All the LLM generated comments I'm reading seem weak to me.

[...]
> > Should nf_conntrack's exit path also flush with NULL?
> 
> Yes, nf_conntrack_fini_net() would be a candiate.

Sound like a pre-existing issue.

> But unlike the brnf case I think this one is relatively harmless.

That needs a follow up, I would suggest.
