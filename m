Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD6260590
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Oct 2025 11:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759664569; cv=none; b=AMXpUTkpUv3sCHo6bMmFAnApX/0dPs2mHyaoOWjxZ6jCxstA7peyS1tH/+Wq92z0zA3+PSPZbdwB0N3ZW2RfEQBPgCaBxVhQbvSMgQd+UsrOqoUb37CRJCrRZ72LtQ+LBEu+kN2X99aDyUc6JgZVO+tBKUAb9Ujs07fLwlXGGwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759664569; c=relaxed/simple;
	bh=2MPm/XygBUX8Ntc6d22hMrVdDuc2RHWcsy//nMNGpv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khzCSY4JucDWikoOSrixgKf7OlI64XdRrs9M374MpXQsDfnpZWP2XCm0MMLhAxDvcPcouzbJqyMqqHW/uUgEllaZT0yXyIySN81aVZ/Qq2iKrz3dmSJf3+4Uq0RrE4Fdr0oJ23reIQ5LNydCYYFTAEqtc8ZJxr+IPpYucsQK2Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 27D8B604FB; Sun,  5 Oct 2025 13:42:39 +0200 (CEST)
Date: Sun, 5 Oct 2025 13:42:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Subject: Re: [PATCH v2 2/2] selftests: netfilter: add nfnetlink ACK handling
 tests
Message-ID: <aOJZn0TLARyv5Ocj@strlen.de>
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
 <20251004092655.237888-1-nickgarlis@gmail.com>
 <20251004092655.237888-3-nickgarlis@gmail.com>
 <aOD7IaLqduE9k0om@strlen.de>
 <CA+jwDR=0riXXHig1wcq4BjbGDUngksrUTxdgJgD4S8PUqAvO=A@mail.gmail.com>
 <aOEScmNyuP_k_YsU@strlen.de>
 <CA+jwDR=ryt_yTj7Y7B9ZdbKVeb7XsN40zASO1MXC75suYaceXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+jwDR=ryt_yTj7Y7B9ZdbKVeb7XsN40zASO1MXC75suYaceXA@mail.gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Is this to exercise replay path?
> > Perhaps add a comment to the subtest that depends on this.
> 
> Yes, that is the goal. I can add a comment to the test explaining that.

Thanks!

> verifies the number of ACKs returned and their order, which is what
> bf2ac490d28c broke. I have tested both builtin and non-existent cases.

Great.

> What do you think about something like this?
> 
> +++ b/tools/testing/selftests/net/netfilter/nfnetlink.sh
> @@ -0,0 +1,5 @@
> +#!/bin/bash
> +
> +# If nft_ct is a module and is loaded, remove it to test module auto-loading

Looks good, can you also mention that if removal doesn't work this is
ok?

> +lsmod | grep -q "^nft_ct\b" && rmmod nft_ct

You could just "rmmod nft_ct 2>/dev/null" with
above comment in place.

> +./nfnetlink

Since you need the shell wraper for the rmmod you could
also make this

unshare -n ./nfnetlink and not do it in the .c setup
function.  Your call.

> I can send a v3 if that looks okay to you.

Yes please.  You can just send a v3 of the test case,
no need to resend the fix.
