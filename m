Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7904F39E177;
	Tue, 11 Aug 2026 11:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447949; cv=none; b=PNIBzhxEqnOjvwH+nZFIZKFu4EUl2fuRxwi+afni7vflRtT/fDxquF4cCZgIwQNvSv3QAIPq54ybIdCtsDDRmSML/LRo66p1COESYQnpNZ1Qv7YG8rwx5mSG5GG96FM3vEipd3SbSqjSKY0EOa46gX/c9woYKRj89vmazdS+Nro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447949; c=relaxed/simple;
	bh=Z78MZaK8DRBVinq5Q4HCh8R9g6hfmivhjCgUpWGK350=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxwvLDY9/1XP9tHryiZ9iVGfO7XrM1VHDif76L507H3wQgPEZJ0ZcmG4GoNkFBOWNsI3yhmS6WgU2OZvSgDnopIBMFsRHVZvMCx0TSoFZlX/T5FmXtzbB5GfkCuOxI81R6vXgv27RtkY4sUojEoOKoa4oEp1Mqq4jlUoTuS4EqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F002360299; Tue, 11 Aug 2026 13:32:24 +0200 (CEST)
Date: Tue, 11 Aug 2026 13:32:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Wei Fang <void0red@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, k.chen@smail.nju.edu.cn
Subject: Re: [nf_tables] pipapo: inserting an interval that strictly contains
 an existing one is accepted; rbtree rejects the same insert
Message-ID: <ansISMIJIOfIUrAA@strlen.de>
References: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>
 <anr3YZJrnS_2RbEp@strlen.de>
 <CANE+tVr69qqyreBbWWk_2FqpMfQAqde-JF=weECditGJF=uZ3g@mail.gmail.com>
 <anr-MVb8okTwL1X2@strlen.de>
 <CANE+tVqc+NNN8EfpK+cEYV63Pmn3OHS81PBAGqB1RHidraChLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANE+tVqc+NNN8EfpK+cEYV63Pmn3OHS81PBAGqB1RHidraChLw@mail.gmail.com>

Wei Fang <void0red@gmail.com> wrote:
> The report is about inserting a *new interval that strictly
> contains an existing one*.  On a pipapo set: first insert
> [1.1.1.1..1.1.1.11), then insert [1.1.1.0..1.1.1.12).
> On the kernel under test:

There is currently no way to detect this is in an efficient
manner.

Kernel would have to lookup all combinations of
1.1.1.0..1.1.1.12: 1.1.1.1, 1.1.1.2, 1.1.1.3, ...

It checks start and end key only.
