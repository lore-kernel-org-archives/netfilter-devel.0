Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BDB1487C1
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720193305; cv=none; b=Bda70V0AyjAv5A6Dt8MpCHssbe6wG6SFf/A5Krn0yvmvCzPwiez76KkpsE4dXs8TCWR/8MQf2xWv2IyWevZ3yB77tIM4VisYPf6TxcePiQ9Iz9n3UgCWGzZ/8LpUFPaaiJIq1z+N7RmUU9Ie8pEG/siLkbKR1xE4SxxpPXK+aM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720193305; c=relaxed/simple;
	bh=lJ1US1dQWt3zsgdIjkwhbxabtGIrY+CcZRKV9nkVFw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SIOL8+jTdbxwJtRdxjDXG45iI44s+/TCxsaF/1oTkETf9qnKzEeWJQ6saBb8YnrgFn4QN0xasX/dagLe+UQTgu8TSnfLPSgjwScqjhFZq2P6eWXItLuvCBKK64mPL/dVeb226CqP/nkUsV1euWZOkSBvsik4/CPoMXz9ofqnxgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=V6AzEDf9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="V6AzEDf9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5MjxiBKysMVYYsFlVMKZt082pajPhKJvV9wcjZPezGM=; b=V6AzEDf9ieHUCzx85SG1ozwAei
	ANZ/0/9meCTAsstsx6XKwbfZNpbLcahmX/4Ged89v9gakPDo6VDaXp2zk/dAX0BD2967DNt5BibHd
	fA7ARYTtdAgKzDdm16HZptcPw3RZKcmIhICPwToEpqLGoUwwdn9c4m5CfcVNHRj8hQfxDt4p7Wsy9
	RBeJ3xWjyweq5juS39JngmazJkrg1vi6zNIpqoOuYDKoCtMx6bq1NgJAB16L9nmYJqYrHlzGlH+D5
	1n0a1t2zOamcaxXt9kS7EOOAGVFBs/MPwx8DNWuh6sueJmG1n6fj6jDXiLsuP91Zo/hNfbg524cCP
	QH5vtnGw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sPkr8-000000001mn-1fdP;
	Fri, 05 Jul 2024 17:28:14 +0200
Date: Fri, 5 Jul 2024 17:28:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: josh lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org, josh lant <joshualant@gmail.com>
Subject: Re: iptables- accessing unallocated memory
Message-ID: <ZogRDinLhQeOhY6O@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	josh lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org, josh lant <joshualant@gmail.com>
References: <CAMQRqNLQvfETbB6rpAP+QabsVGdwDmA0_7bxhK2jm0gcFQYm9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMQRqNLQvfETbB6rpAP+QabsVGdwDmA0_7bxhK2jm0gcFQYm9g@mail.gmail.com>

Hi Josh,

On Fri, Jul 05, 2024 at 02:47:19PM +0100, josh lant wrote:
> I am currently trying to port iptables to ARM's new Morello
> architecture; featuring hardware capabilities for memory protection.
> 
> One of the ways Morello affords protection is by enforcing bounds on
> memory accesses at the hardware level. On Morello a segfault/bounds
> fault will occur at runtime when an illegal memory access is made...
> 
> When running some of the iptables tests I am encountering some of
> these faults. I have not investigated if they all occur in the same
> spot yet, but at least 3 such occurrences in the same place are in
> tests:
> chain/0005base-delete_0
> ebtables/0007-chain-policies_0
> iptables/0002-verbose-output_0
> 
> Let us use ././testcases/iptables/0002-verbose-output_0 as an example
> here, since I see different behaviour in two different versions of
> iptables and libnftnl. (I had to update the package versions due to
> another unrelated issue that I may ask about separately).
> 
> Bounds faults occur: iptables (1.8.10), libnftnl (master), libmnl
> (1.0.5), kernel (6.4)
> Bounds faults do not occur: iptables (1.8.7), libnftnl (1.2.1), libmnl
> (1.0.5), kernel (6.4)

Could you please try with current HEAD of iptables? I think the bug you
see was fixed by commit 2026b08bce7fe ("nft: ruleparse: Add missing
braces around ternary"). At least I don't see a problem in
testcases/iptables/0002-verbose-output_0 when testing with either
valgrind or ASAN.

Cheers, Phil
