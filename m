Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC69381E91
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035091; cv=none; b=JNCYDQPua5TIqdxpDKtxmpuQkCNK7oZUgjyNyiV4YZ56qsLFgnmM3iIDyV4r3rgtc10qI3SINO9Kxha+qiG/3Jotxk1aUaUeb36uzaff8RFM+TSgHU26E2XDAjk9E34JxBR7DMi2fK0w7Mn2sxq4aiDAz64P9YYDtZgRqwlnnLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035091; c=relaxed/simple;
	bh=fqobJya5RSKrzGQrd+qgN5nhNqjZMBiiQm5rw2myE7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6HB/zu2iS39W4/oklX4LT817PwTqlzvf6GzSgdpX3CuHGX1j8vEyfq4uod9i9C/Iyzttg+M0xwwsr/VqmKiv4UlY4SkayHme/ygdG+/+0kmFROeDZKoH4JhsmIAl39KR/wfJ5ldRrumbUiY3rgMoATsGYsdeHaRBI2OlZFlvb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0FA6D602AB; Thu, 06 Aug 2026 18:51:18 +0200 (CEST)
Date: Thu, 6 Aug 2026 18:51:16 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ipset: fix list type element drift bug
Message-ID: <anS7hI05QHjxQ-B9@strlen.de>
References: <20260806135341.8896-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806135341.8896-1-fw@strlen.de>

Hi Jozsef, hi Pablo

TL;DR, more unrelated drive-by findings, probably even wrong.

Florian Westphal <fw@strlen.de> wrote:
> If list_set_uadd() calls list_set_replace() to swap an expired entry,
> the element count remains the same, therefore the increment must be elided.
> 
> Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
> Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
> Signed-off-by: Florian Westphal <fw@strlen.de>

Jozsef, could you please have a look at the LLM sauce below?
https://sashiko.dev/#/patchset/20260806135341.8896-1-fw%40strlen.de
-- LLM sauce follows --
When inserting before a reference element, does this mistakenly identify the
element after the reference as the candidate for replacement?
Similarly, when inserting after, does it replace the element before the
reference?
Could this lead to incorrect rule ordering by placing the new element on the
opposite side of the reference element than requested?
-- LLM end --

I had a look, even if its correct, this change is super old:
00590fdd5be0 ("netfilter: ipset: Introduce RCU locking in list type")

It is been in RHEL7 for a long time as well.
So even if its correct, I'm reluctant to make changes.

-- LLM sauce follows --
This is a pre-existing issue, but does this code fail to enforce the set size
limit?
Just below this hunk in list_set_uadd(), the element is added and the counter
is incremented without validation:
	else if (prev)
		list_add_rcu(&e->list, &prev->list);
	else
		list_add_tail_rcu(&e->list, &map->members);
	set->elements++;
Since the list:set type accepts a size parameter during creation, should this
code verify that set->elements is strictly less than map->size before adding
the new element to prevent unbounded memory allocation?
-- LLM end --

ipset man page says size parameter is ignored nowadays, so this
looks intentional.

So the only complaint about this patch that is valid is this:

+		return 0;
+       }
+
        else if (next)

Should better be:
+		return 0;
+       }
+
+       if (next)
-       else if (next)

.. as its more readable.
