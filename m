Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46AF14AB4
	for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2024 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779462; cv=none; b=CbxMPRAc3ESIguBzZ740Wj0Y0zgnsqJCWaoxsjdZ6zPyB4UYJZI1utMcI39veK+ym1wBAU9ftSP9plBMZsi4zI0poqLsxSXb45jLb9MQqrpv+N92dobEsmKy5+PrkUnyNN2JWMbU7uub429cG2AbxdUb2ux/4ynrQezkWza5NwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779462; c=relaxed/simple;
	bh=8AKrGYK+l6p+OoTxk5F+BXQi65ucysYHX/up05aYk6U=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c32+X3ZoCMTIqr+iHDwOif9JZSDD5QTcu51U0xePsP3GdtLt1uFTFsGunFdfyyar7OYUce8PcC4wxJblj0BP8DPv3lcMoxWMQPmeVvYpc0yRpRxkPYk9rzryeDsSPAVUGjFYXsHvb+ro6/TFWZyaCzul1/McJl0rpUA69g1VC/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s7Ec6-0001LH-NO; Wed, 15 May 2024 15:24:10 +0200
Date: Wed, 15 May 2024 15:24:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [nf-next PATCH 0/5] Dynamic hook interface binding
Message-ID: <20240515132410.GC13678@breakpoint.cc>
References: <20240503195045.6934-1-phil@nwl.cc>
 <Zj1mlxa-bckdazdv@calendula>
 <ZkSq6nfq0fE9658S@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkSq6nfq0fE9658S@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> WDYT, is something still missing I could add to the test? Also, I'm not
> sure whether I should add it to netfilter selftests as it doesn't have a
> defined failure outcome.

Isn't the expected outcome "did not crash"?

You could just append a test for /proc/sys/kernel/tainted,
i.e. script ran and no splat was triggered.

As the selftests are run in regular intervals on the netdev
CI the only critical factor is total test run time, but so far
the netfilter tests are not too bad and for the much-slower-debug kernel
the script can detect this and spent fewer cycles.
