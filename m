Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2308A14A62A
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 09:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732181073; cv=none; b=ucpg3+DIvfKze6c4mQlPI4+t5bRtFPwyRfh9/iG1WHDLrkAxlgHHZGWhccPObg7MIgYyHfId21amQy+twdJ/1/kCX+6rqxo7tf8iyMuCLk/vWfMjL/6a0LLhVDT6s4s+IxEgCsw3wnMPN6NKC/5IRijbl90bq1GdVbsEhaHqyB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732181073; c=relaxed/simple;
	bh=xOzxrstBFZ9AlG0Bcp8sU8y+/iLoW/YzPnBofwb8CqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmJ7unvBs4Tgr+hKUJ1AlD8a3kmvbXRl8Rj3b08n1ua//XuAw0u7+OVK7kmRLQY1sZTzcxJH2QcblO+fbeqUKfRP2KQ7X7onjdyi82OtPMnc9bdw4Q2+yJqRRA1835SbYk2lnH9GTz82miMOqqusjx8LkE8XQF+GLZIoR6SdEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tE3QJ-0003iU-IW; Thu, 21 Nov 2024 10:24:27 +0100
Date: Thu, 21 Nov 2024 10:24:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <20241121092427.GA12619@breakpoint.cc>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120233854.GB31921@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> >         set y {
> >                 type ipv4_addr
> >                 size 256        # count 128
> >                 ...
> > 
> > We have to exposed the number of elements counter. I think this can be
> > exposed if set declaration provides size (or default size is used).
> 
> OK,  I will update libnftl then because this means it will need
> proper getter for nft sake.

There is a problem with this, shell tests break:

W: [DUMP FAIL]    9/430 tests/shell/testcases/sets/0057set_create_fails_0

cat /tmp/nft-test.latest.root/test-tests-shell-testcases-sets-0057set_create_fails_0.11/ruleset-diff
--- tests/shell/testcases/sets/dumps/0057set_create_fails_0.nft 2024-11-21 09:46:16.888431831 +0100
+++ /tmp/nft-test.20241121-101956.182.zWvUOZ/test-tests-shell-testcases-sets-0057set_create_fails_0.11/ruleset-after    2024-11-21 10:20:00.046431831 +0100
@@ -1,7 +1,7 @@
 table inet filter {
        set test {
                type ipv4_addr
-               size 65535
+               size 65535      # count 1
                elements = { 1.1.1.1 }
        }

As shell tests coud run on old kernel, regen dump file won't work.

Only options I see is to add a feature test file for this support,
and then either disabling dump validation if it failed or adding
additonal/alternative dump file.
