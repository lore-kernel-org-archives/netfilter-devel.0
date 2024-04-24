Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24361591F2;
	Wed, 24 Apr 2024 09:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713952534; cv=none; b=BgLNE0IJrlxUpnO0W9x2+J4tIWDBjw4k+j173u7dr09q9NTPZYULQ3b4yNjdMyZdorBn8I6sEY7cpNVi2pM0yC0E95cNNus4j4rDVoH0iNaoLCdIWkwBl5TptapOv4BpKQrH4LTlvExV4TT2a9CbYc62n1lXpAG6OtQ5lOJre3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713952534; c=relaxed/simple;
	bh=tqx02517OoyYZccy7jG2gdRYlCG/NE+sgT4AgbMCTmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZTzOUbpkul7iCNjJb5npCDJu83yFmhpOYkQbs32o+JLGxpdtGa75UYAG/lJLa2127KYOAlIcDHImnNI/jmR97N8JKQwbS4JQVt7aO4+6FYF8vxIN8rFlyNbmgtE+sIFPxtuMWe4gnKzleVTmfU35Noa41SIv69+o2ARo1pNNXl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rzZLX-0006x0-Hg; Wed, 24 Apr 2024 11:55:23 +0200
Date: Wed, 24 Apr 2024 11:55:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next] tools: testing: selftests: switch
 conntrack_dump_flush to TEST_PROGS
Message-ID: <20240424095523.GB31360@breakpoint.cc>
References: <20240422152701.13518-1-fw@strlen.de>
 <20240423191609.70c14c42@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423191609.70c14c42@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 22 Apr 2024 17:26:59 +0200 Florian Westphal wrote:
> > Currently conntrack_dump_flush test program always runs when passing
> > TEST_PROGS argument:
> > 
> > % make -C tools/testing/selftests TARGETS=net/netfilter TEST_PROGS=conntrack_ipip_mtu.sh run_tests
> > make: Entering [..]
> > TAP version 13
> > 1..2 [..]
> >   selftests: net/netfilter: conntrack_dump_flush [..]
> > 
> > Move away from TEST_CUSTOM_PROGS to avoid this.  After this,
> > above command will only run the program specified in TEST_PROGS.
> 
> Hm, but why TEST_CUSTOM_PROGS in the first place?
> What's special about it? I think TEST_GEN_PROGS would work

It works iff I run 'make -C tools/testing/selftests TARGETS=net/netfilter'
before running vng ... make -C tools/testing/selftests
TARGETS=net/netfilter  TEST_PROGS=conntrack_dump_flush TEST_GEN_PROGS="" run_tests.

I'll send a v2, will check if it works in the CI or not.
