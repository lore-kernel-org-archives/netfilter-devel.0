Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2661B40FD8B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 23:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768951233; cv=none; b=ZqFcdN6ugfcIgFMtiNQs1hKLP/gKu/wBE3uLOFehvepE8VNISMeeE2lE7zms3ZoUCR/JZMX8irE9eJZwFL57dgk0JdfI3IhuTK5XOo1sjFFHNandfJukFvCy4muDDuGFanIFJbfF5uDyqxG2FeTAm16bH8JDGJVOaiKBGjC43Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768951233; c=relaxed/simple;
	bh=3j19VJ+YOCmxn5gFAHr3ojUEOAs+042Nh0Rfly/NMps=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ogkpzL5Qh/mYoCdMqGlHcE8Q2THc7vwD9t7k/hraflT0/D6WLmgWX+68LE3XBiOXdEp2Dxvq8tbKLmqt1t2s9kHQOc1Mj6suDJwG05I5cZLCsNqhojEwLedj8io1MvulIVmL7Y3NrA1XykG59MrmIccaMrbxLIdDQcYtiE/UPYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=O8IAhFKg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="O8IAhFKg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3j19VJ+YOCmxn5gFAHr3ojUEOAs+042Nh0Rfly/NMps=; b=O8IAhFKgaPvOTqltbMg29LuCsK
	hX4+r2b938Y3WiZ385znKxUS0pKFly9ms0LFfyyn8sM38d6QlYiF5WVs6Pw/Kn11E/x2r4xOylH+Q
	/5OPzMRIRa++ecuTryAF/HAfbK2x2T4p/cM8qkwRo/wlsY7puCZdE2oabbHXrW/lYMF3Wrk+DMb0a
	QF87z9noK9e61oK3+JqQchYLaS2jzsnobb6FXxcpC/OtGqhhMB2bHl4Y7qPTH/E9RHXtoi1vAhEKl
	b5aPz6nArRYtf0B6nA0J7CPx+vUxbNYHlKJXZK2mEHqfb4iFLz5N9WWEsA8H/v0aIV2mXlPvCjUwG
	v2ks1z7Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viL1R-000000000zh-0uAT;
	Wed, 21 Jan 2026 00:20:29 +0100
Date: Wed, 21 Jan 2026 00:20:29 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: FYI: Code coverage of nft test suites
Message-ID: <aXANvUVv8nX-wPeM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I recalled there was an effort to increase code coverage of the nft test
suites so I ran 'make check' in a '--coverage'-enabled build. Here's
the result for HEAD at commit dda050bd78245 ("doc: clarify JSON rule
positioning with handle field"):

http://nwl.cc/~n0-1/nft_testsuites_coverage/index.html

I plan to pick at least a few low hanging fruits from there, but anyone
interested is more than welcome to chime in!

Cheers, Phil
