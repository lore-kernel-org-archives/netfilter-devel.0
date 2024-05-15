Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB484149DEE
	for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2024 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715787165; cv=none; b=T8ohL49T1nxtX29OPcG1DYMkt6HouxO0gcfo4fiiN2QUCt3fekDmwFzDNOFgJi4xM7S/OhWIRiTpls6HUbL+36ENGtox9s5CSDlq+UjtJ6NgynP2XJOcCFXfBR1VMElFzzH7MFSk9UGX9CIHPV+oX/BBkpZaFqfTrVPm8LsuKYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715787165; c=relaxed/simple;
	bh=H1zlkgl94gbKRHcX0DLVHoGPmgfP460QX/N266GJVgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tC1FAWRedJyoE6c5Tn2e6I/vMMCjZBTyMaoUJSal6WeN2l96PWdgX6muF5HppIL857g+pa4IoYR7qg949mVKKz4h60GLeuAZ+tPBkJG/hwI3wyd17L4IBtdffu/z6qlpEZbKgNOaK+uedGTESv+Xg7jAmaEghJL6s2T7EyCoNfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aOsz7Vsy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aOsz7Vsy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G/xohgTu3a3mH289GdQBO007yfsdSZyYgNgnzl7CrKQ=; b=aOsz7VsyLzDbb6vt9PfTQJgk2r
	YOEbhRl6CdFtticNJCi9xzY3hPKjpvrwsaAjTJJxMGShNsbNCs3GZpQ3Do/mb4+lpSz0pZTtoUPiU
	74ksYSRfmfQ2vYasd0NKNrF7vnnijlq94jjx72jSRmI0nZsZyuAwJDJPcDGBpOD+eGZKBKvjLytkI
	ugC2LipXhmQehzOzSqWzpD3ABtOJmNTIlFSTYIQpllEFMx3D0kArVupp8HHP0uy6gc7hdHzlnbEvp
	kLSkcaTx+MBiwnhP4l4Emmr0ktsXLFFBN/eagLMNP73TP1Hky6BM05P3cUn8pUgJvziCNaMP3J5ES
	58+2VXEw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7GcR-000000007M4-05hg;
	Wed, 15 May 2024 17:32:39 +0200
Date: Wed, 15 May 2024 17:32:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Thomas Haller <thaller@redhat.com>
Subject: Re: [nf-next PATCH 0/5] Dynamic hook interface binding
Message-ID: <ZkTVlpWXGrIKmxXy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Thomas Haller <thaller@redhat.com>
References: <20240503195045.6934-1-phil@nwl.cc>
 <Zj1mlxa-bckdazdv@calendula>
 <ZkSq6nfq0fE9658S@orbyte.nwl.cc>
 <20240515132410.GC13678@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515132410.GC13678@breakpoint.cc>

On Wed, May 15, 2024 at 03:24:10PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > WDYT, is something still missing I could add to the test? Also, I'm not
> > sure whether I should add it to netfilter selftests as it doesn't have a
> > defined failure outcome.
> 
> Isn't the expected outcome "did not crash"?
> 
> You could just append a test for /proc/sys/kernel/tainted,
> i.e. script ran and no splat was triggered.

Fair point, thanks!

> As the selftests are run in regular intervals on the netdev
> CI the only critical factor is total test run time, but so far
> the netfilter tests are not too bad and for the much-slower-debug kernel
> the script can detect this and spent fewer cycles.

My script is bound by the configured iperf3 test time, so in theory it
should take the same time irrespective of system performance.

Cheers, Phil
