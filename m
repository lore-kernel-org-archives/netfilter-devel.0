Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DB01AC44D
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 11:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746702943; cv=none; b=JIyviY4mbbGXO3ibBHhFILY7FK6gDLYfQOo8WGB4mnwlVe/6tzZQu/LS1GoITuhcWeRr7NjqenzFAgSvDVeXL1GQRj+J/jzmt5xkxAiQx2cEzIEZ9J0b3jxDpfeIA2pAtuhSY5fJ4Y5BUN9108ujuh589OTdbYF1rH0uikzdxP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746702943; c=relaxed/simple;
	bh=z5y1rJw0LusB2aMmZgyjN8gcqLFrEJAruzbzG8+nZLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pw6XNvdSqQQ0nwkkm9/VF6CbG2E9vJKFTHw0kxg+Dm0RqQmiXekkfO9zIDHs21UBLeKP9KtswwnypV8dMhVAdbt/T73oijIQ2kvUDrOEUwGqb7yG1K6Zl79VJc6JpMUMv080RjvhGLtv69VMPZYP2w7C0Jpb3rDDlBCAuf773lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=STuh8fMK; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=STuh8fMK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="STuh8fMK";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="STuh8fMK"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DB664602A9; Thu,  8 May 2025 13:15:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746702936;
	bh=DtHNUtGMRwepvyjOVX+hRTE8LGIHHTF6QHLsiozz7oA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STuh8fMKDp2DUW9yoi1kugXxSqgW4Ze6PxammEDq4rJWdOQX2DR7BEoP1YwdIIiwR
	 IJ4xmUtLZlo3Yq4txzM9Tcp2p6HO/voAHlVk4Hus29Qjr79RCl40ORnpvk6LiRynkl
	 tfhdgOfTFOCyh10f9bGqc4fgmBf3oGJNID93aIbLWNrMQVZnQGU8cIR39obhq546VD
	 hXmO8RBlk63CJrS2PxfQMibp14YVpro5O9YxtXNaQwbUVBYWiLXZrSTu0WRKy+0GL/
	 syPkIZtE4w0GHrOKBU0T1KBhHGe9uk2fx5S5ZsOLXNJ6EgDusSRy3F//nHj3o1CTKL
	 nqGUgyfTWiimQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 326DC602A9;
	Thu,  8 May 2025 13:15:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746702936;
	bh=DtHNUtGMRwepvyjOVX+hRTE8LGIHHTF6QHLsiozz7oA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STuh8fMKDp2DUW9yoi1kugXxSqgW4Ze6PxammEDq4rJWdOQX2DR7BEoP1YwdIIiwR
	 IJ4xmUtLZlo3Yq4txzM9Tcp2p6HO/voAHlVk4Hus29Qjr79RCl40ORnpvk6LiRynkl
	 tfhdgOfTFOCyh10f9bGqc4fgmBf3oGJNID93aIbLWNrMQVZnQGU8cIR39obhq546VD
	 hXmO8RBlk63CJrS2PxfQMibp14YVpro5O9YxtXNaQwbUVBYWiLXZrSTu0WRKy+0GL/
	 syPkIZtE4w0GHrOKBU0T1KBhHGe9uk2fx5S5ZsOLXNJ6EgDusSRy3F//nHj3o1CTKL
	 nqGUgyfTWiimQ==
Date: Thu, 8 May 2025 13:15:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/shell: Skip netdev_chain_dev_addremove on
 tainted kernels
Message-ID: <aBySVYDLHjnqC8TF@calendula>
References: <20250508102654.17077-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508102654.17077-1-phil@nwl.cc>

On Thu, May 08, 2025 at 12:26:54PM +0200, Phil Sutter wrote:
> The test checks taint state to indicate success or failure. Since this
> won't work if the kernel is already tainted at start, skip the test
> instead of failing it.
> 
> Fixes: 02dbf86f39410 ("tests: shell: add a test case for netdev ruleset flush + parallel link down")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks, Florian made similar patch quite recently for selftests.
