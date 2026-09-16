Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DE03CF962
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789581579; cv=none; b=ZtW6T9AqfXZFMYRbaPpKb6xBnUybao4M4zC1JBBrrEEBlbsNDocNOi9o7qe9xMHZokQjlDt6rcj3d3s2LFG3210Bbji84NiVYJEkw2vOKSCHt7fBxeiw6H+pG5WeXAJp/dxjK0vJfaDBKO5O8EyYEPTck0yRbzM9XaDSAQAgQLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789581579; c=relaxed/simple;
	bh=J5YsDaqTAP/a/Xp/mxr8ip8hz2xGsZg88Nupmwqagxg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mMSr5PYZScrfRoVjl+E4nT9blH7EtEzn8yyTrjh6My3nTQ27gxAlfrm6oUbApTjGMPvF8drD7YzfNDn7K1F+XMeMnd723IulUD20vB0kLZvZ6UpoORFQo3XCe3+keKNHWN/WU+Idod0OMbXiZDIbMtK9QZPtPUEjTaewaK1v7/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4hlRLq5HJTz7s7x3;
	Wed, 16 Sep 2026 19:53:07 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id fULvcm_VrosH; Wed, 16 Sep 2026 19:53:05 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (94-21-166-123.pool.digikabel.hu [94.21.166.123])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4hlRLn4tBpz7s7x1;
	Wed, 16 Sep 2026 19:53:05 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 524DF14023E; Wed, 16 Sep 2026 19:53:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 4EB9F1400D8;
	Wed, 16 Sep 2026 19:53:05 +0200 (CEST)
Date: Wed, 16 Sep 2026 19:53:05 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/6] ipset: replace internal hash table with
 rhashtable
In-Reply-To: <aqqZJ8mgGIS48TJt@strlen.de>
Message-ID: <1f62539d-26bc-9083-667e-8c94deb46c82@netfilter.org>
References: <20260916125151.28062-1-fw@strlen.de> <aqqZJ8mgGIS48TJt@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

On Wed, 16 Sep 2026, Florian Westphal wrote:

> Florian Westphal <fw@strlen.de> wrote:
> > v5: add Herbert Xu's new rhashtable_flush_and_free() to rhashtable, this
> > replaces my own version from v4.  I also dropped a few follwup patches
> > with further changes/cleanups, not strictly required for initial
> > conversion.
> 
> I hate this world.  More LLM mumbojumbo.  No idea I can ever get
> this in a mergeable state.

The comments to patch 4/6 are not bad and can even be ifdef-ed the special 
case for IP_SET_HASH_WITH_MULTI when the total number of elements is 
required instead of the unique ones.

About 5/6 I share your feelings and can't really make sense of it.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
