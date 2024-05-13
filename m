Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CABE175A6;
	Mon, 13 May 2024 21:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715636476; cv=none; b=dOnTRwKpsNCU0s5+lSpLnWr/LJswcS1Lwe0YwHduFY/lwP27Mtm2mSQTcBDzFZ2dXmKghuOhGFdBXD02c689ofRPyKYQs3l6KZUD4bosK52yX//31oGboTk5GPXivVcz7mmWh9Y6L5u4+2R3KDsw3bM2/kiHOxU+wW6evDcuOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715636476; c=relaxed/simple;
	bh=Z7OtRm63hVPkbJZOCUm+lXNXgV6JU8c/vXE8yxm0Y/A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYaPrx+/yiDeLzm48DPgz64YZbPPBoMOjtO6cH8OyJnBSWe2rafal0bE7BHHiIkInhCQXl8sBRNkRteNX3XPbcRgn3wZ+/ycVAJsmZbryhdhLdq0X56oPxSgWIeqiqgBd8y8ld0aspOxWOJH910kGHp7KPKZzm47xM6lZYQfF3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJBQ+nEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJBQ+nEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56564C113CC;
	Mon, 13 May 2024 21:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715636475;
	bh=Z7OtRm63hVPkbJZOCUm+lXNXgV6JU8c/vXE8yxm0Y/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SJBQ+nEcTyBafJRDQezqx9buD7iqN35a6tIRzY1M0U5M8FtliJx6yqTrQjpkpPNLD
	 IiyOELa+4uVdan8j8lwxpAWhybhIVDpxa1OqOiQT0AyFvjtt4oZMlW9KqjIOwVubAW
	 CSEXVpEVFMo/pgfDAh/KOZvT8pw8tBUx10b3e6iH6I+1xqvrrdxyPBpompJAcRLj0m
	 iRPYbP0Xzs7g1Bhnw6rqpQvLpnSBp03lTtaZnVHztAGVLS8MfYpnhUTo1IyyL7TMCd
	 QSAFqKU10+my8rZtjDSo0pUqKtFwd3R54MdHERoN6iCCOSbDDILzQ7fRsowyIXmKtJ
	 u1CSM83fB4KMA==
Date: Mon, 13 May 2024 14:41:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 16/17] selftests: netfilter: add packetdrill
 based conntrack tests
Message-ID: <20240513144114.2ae7bf1a@kernel.org>
In-Reply-To: <20240513200314.GA3104@breakpoint.cc>
References: <20240512161436.168973-1-pablo@netfilter.org>
	<20240512161436.168973-17-pablo@netfilter.org>
	<20240513114649.6d764307@kernel.org>
	<20240513200314.GA3104@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 May 2024 22:03:14 +0200 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > Hi Florian, I installed packetdrill in the morning and the test..
> > almost.. passes:  
> 
> Thanks a lot!
> 
> > # packetdrill/conntrack_synack_reuse.pkt            (ipv6)                    packetdrill/conntrack_synack_reuse.pkt:33: error executing `conntrack -L -p tcp --dport 8080 2>/dev/null | grep -q SYN_RECV` command: non-zero status 1  
> 
> Grrr, my fault, I used a more ...forgiving version of conntrack tools.
> 
> I bet its because of missing "-f ipv6" flag, so changing the line to
> include "-f $NFCT_IP_VERSION" like in the other files should make it
> work.

Ah, makes sense. I added a local patch to the system, it should be
applied on the next test, just to confirm.

> I intend to wait for a few months before adding more test cases to
> see how stable these tests will be wrt. changes elsewhere in the stack,
> there are a few other corner cases that would be nice to have coverage
> for.
> 

