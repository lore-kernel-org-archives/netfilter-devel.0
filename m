Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BEC21CC59
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786281800; cv=none; b=MqWCyuh2hFrtVEk/xOsk0AePY4H3QXBFc+LXHqq2gxci2TD7SANriBxNR1D8ra+91cTo7mjRsyZ7xb5mfxQaEVgHlFqtB88x8tDQ7RAmQS9s6C585fFGRk6stW+XTyFld/Xb0errUkdlYvgCKsxeKL8yp5Lp8jFCBcUsOeZM1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786281800; c=relaxed/simple;
	bh=OnAfjDQgn5ibhY+g3MJuO7gorUacU33B0knVQAjqWy4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Yy3heps2/yYXZsGhum73qary3Ni3uCBr33uwXYJBWN+QzmAc6k+G7W4vcsM7qvfEv605QeMOqiktL1WM/SLdmMo3FKm2GgcZUwFf3N5+XhN0OrHiMakK9N/YhsAXVA0aaKUPmS8ktDO9xvugTsoG4Yin24oxAoPSdsDcYwk0XsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4hHz903JxZz3sb0R;
	Sun, 09 Aug 2026 15:23:16 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id LgadbWnC8_8D; Sun,  9 Aug 2026 15:23:14 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (78-131-74-220.pool.digikabel.hu [78.131.74.220])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4hHz8y19X3z3sb0N;
	Sun, 09 Aug 2026 15:23:14 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id ECA9C140E07; Sun,  9 Aug 2026 15:23:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id E9AC2140986;
	Sun,  9 Aug 2026 15:23:13 +0200 (CEST)
Date: Sun, 9 Aug 2026 15:23:13 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: fix list type element drift bug
In-Reply-To: <anS7hI05QHjxQ-B9@strlen.de>
Message-ID: <8922b66e-9ff9-f900-755c-c172aabc85cb@netfilter.org>
References: <20260806135341.8896-1-fw@strlen.de> <anS7hI05QHjxQ-B9@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%

Hi Florian,

On Thu, 6 Aug 2026, Florian Westphal wrote:

> TL;DR, more unrelated drive-by findings, probably even wrong.
> 
> Florian Westphal <fw@strlen.de> wrote:
> > If list_set_uadd() calls list_set_replace() to swap an expired entry,
> > the element count remains the same, therefore the increment must be elided.

Yes, that is correct and your patch "netfilter: ipset: fix list type 
element drift bug" fixes it properly.
 
> > Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
> > Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Jozsef, could you please have a look at the LLM sauce below?
> https://sashiko.dev/#/patchset/20260806135341.8896-1-fw%40strlen.de
> -- LLM sauce follows --
> When inserting before a reference element, does this mistakenly identify the
> element after the reference as the candidate for replacement?
> Similarly, when inserting after, does it replace the element before the
> reference?
> Could this lead to incorrect rule ordering by placing the new element on the
> opposite side of the reference element than requested?
> -- LLM end --

I can't really make sense of it. There's no replacement here, the code 
tries to identify where to insert the element: before/after the reference 
one, if it was given. The only replacement happens when the same element 
is re-added and the extensions may change, but then in that case there's 
no before-after.
 
> I had a look, even if its correct, this change is super old:
> 00590fdd5be0 ("netfilter: ipset: Introduce RCU locking in list type")
> 
> It is been in RHEL7 for a long time as well.
> So even if its correct, I'm reluctant to make changes.

The testsuite contains tests to verify add/del/test before/after 
functionalities. So I don't know what to fix here.
 
> -- LLM sauce follows --
> This is a pre-existing issue, but does this code fail to enforce the set size
> limit?
> Just below this hunk in list_set_uadd(), the element is added and the counter
> is incremented without validation:
> 	else if (prev)
> 		list_add_rcu(&e->list, &prev->list);
> 	else
> 		list_add_tail_rcu(&e->list, &map->members);
> 	set->elements++;
> Since the list:set type accepts a size parameter during creation, should this
> code verify that set->elements is strictly less than map->size before adding
> the new element to prevent unbounded memory allocation?
> -- LLM end --
> 
> ipset man page says size parameter is ignored nowadays, so this
> looks intentional.

Yes, exactly. The parameter is kept for backward compatibility reason 
only.
 
> So the only complaint about this patch that is valid is this:
> 
> +		return 0;
> +       }
> +
>         else if (next)
> 
> Should better be:
> +		return 0;
> +       }
> +
> +       if (next)
> -       else if (next)
> 
> .. as its more readable.
> 

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
