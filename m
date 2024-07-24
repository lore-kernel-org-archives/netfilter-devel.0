Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850A56BFA6
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jul 2024 07:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721807081; cv=none; b=OlsM5tHgzXyC/YK1wte/BDlktTBkE+Dd0CM3YB4cLmFAYX7wV5IgIiym0xuH8xY3zniIZvV8mFwE7aPmTtciR7OSRcAKV4O1JMsZ/cUSkUJE2LsHRJwGqDhp4bb41VpR2MrqCJMtID1Di8dbHPNAnKMQyiEoQNZVZM4Z2OSK+zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721807081; c=relaxed/simple;
	bh=/HUo0Rnm2GAslSnsBFsiQab+ONGoOb4s7MFcew8NPSE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJfP/SXgniYYa69I9uibLb9ljNa7rIRNOLE0NUSwvIv0a6GUv3/rCzrijZet2Myv1Kc0aiGBoXnY+JVCOH/vRFfbmse4veSoaAtLk0RoFv9UchOAsPtm+Lk0FyVQjN23K0YZ6C43GodTxmcfuWTRQtXFsGgvXH0SQKLVHYHHNt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.6.251.194] (port=5484 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sWWfi-001otz-I3; Wed, 24 Jul 2024 09:44:29 +0200
Date: Wed, 24 Jul 2024 09:44:23 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <ZqCw126I4VRE0xKJ@calendula>
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
 <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
 <Zp-fx35ewU1n8EE5@calendula>
 <Zp-_adFRy9PbvYXU@orbyte.nwl.cc>
 <ZqAEv1grG6B8xzvt@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZqAEv1grG6B8xzvt@egarver-mac>
X-Spam-Score: -1.9 (-)

On Tue, Jul 23, 2024 at 03:30:07PM -0400, Eric Garver wrote:
> This patch fixes the failures around the index keyword. I see one more
> issue around set entries.
> 
> Notably, if the set add and element add are on separate lines (and thus
> round trips to the kernel) then the issue is not seen. Perhaps there are
> more instances with other stateful objects.
> 
> --->8---
> 
> # cat /tmp/foo
> add table inet foo
> add set inet foo bar { type ipv4_addr; flags interval; }; add element inet foo bar { 10.1.1.1/32 }
> add element inet foo bar { 10.1.1.2/32 }

Thanks for your reproducer.

I have reverted it:

https://git.netfilter.org/nftables/commit/?id=93560d0117639c8685fc287128ab06dec9950fbd

This needs more work and tests.
