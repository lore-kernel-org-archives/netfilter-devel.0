Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179FB38A70C
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005515; cv=none; b=c322LHQ55FSbAwjrofA2rtkteAUcI2qHiBkGr009pSV+2QbpJhJSnI1wiN7a5ZbXK9y9MJ9kWwPX4Ox2HjrIFYR2KvwMlDLILWiwvzlf6ryn5MdsWp8E8sT3m6bTY1UF8hchiM0tf3VVcEeVi/r+UgY/dzIxpouCZpuAOLHHLjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005515; c=relaxed/simple;
	bh=tc5kTKQ68mNBDbTrci9JS1m8Y0eM0w3qEiruMdi4Z0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1ytIXSBNxdDCoZ64g/0k15NkmGFiAMo7D8lXA8LdkkRU4vZSlQszQN0jfyD09P2UFhY30soclbioGdZFgD2FPbXug3WKjgTs09wa7ohOTA7RwL1oIhWBosXELXXkV9wqfol1sGRADjSoxMWrEuzDFC7nVbU9AGh1HHSYW9Lm+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 433B36090A; Fri, 20 Mar 2026 12:18:32 +0100 (CET)
Date: Fri, 20 Mar 2026 12:18:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab0tB2o90FukwQxU@strlen.de>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
 <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
 <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Fri, Mar 20, 2026 at 11:17:00AM +0100, Phil Sutter wrote:
> [...]
> > A remark from a practical perspective: Florian's suggestion to dump the
> > nat-type chains in their order with the dispatcher's priority value is
> > super-easy to implement (just have to pass the priority value to
> > nfnl_hook_dump_one() via parameter) and does not require adjustments in
> > user space.
> 
> Famous last words. :(

diff --git a/src/mnl.c b/src/mnl.c
index 4893af8322ae..b9efd3cfd3ce 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2520,7 +2520,7 @@ static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
                        continue;
                if (!basehook_eq(hook, b))
                        continue;
-               if (hook->prio < b->prio)
+               if (hook->prio <= b->prio)
                        continue;
 
                list_add(&b->list, &hook->list);

?
