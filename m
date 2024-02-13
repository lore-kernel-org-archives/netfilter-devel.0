Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F322572
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 11:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707822276; cv=none; b=fIT8KBO9aVK2RbwMKGn/QnReCs+kTn0Rzw5R2YKkzVw5v8spHXSRbTlXcgbERwLeMjH0AqkAuhKL0qCzltwpjUbpyQt7QqiahA2rcF0fsioN8qO2cQjR1A6r2/3tc/ailgHe+Jq+pk26rlR9PHMt2j5jRpY9lhFp5nQgA9VPHYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707822276; c=relaxed/simple;
	bh=lXS1a0iHiU8iqVh54dpxaLIAgpIudeJqoy8578ktYUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ugy4yp6eJbj0WAcmvuZu9uBFWYNrqyoDq7eMoLvj+QPNVRKbgF2Lg/Di9dGVPzvu7LNtW03V4+0+/M8UvTaW4IrihfE+VKpUvRop5d/c216jwUcAnhrNWfqU0ytsQ+tP8uKfp/Q3ZudZLmC8RKYLbzCQSi/Te66DcRLt4JgH5GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FY58jEoY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FY58jEoY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zK45diUsbLMQEsk2q5HSfQt45/snxgZ7YTYJm4Lg39Q=; b=FY58jEoYgDcSGIMNr/5P5DRBlT
	FZuBsZePdZNk0ndQNKU9iL04KMt4fVBgLrxSC6pyDGATTAD3ECk+HUJuqJg3YzW9uui04KLCcV/yV
	aeWZhVTGRuEOJUhTJhf2HkjTAU4sgeEjtPWwV2w0JV/OcJ4eN6SaUtqALJthDZZO68FALAzIwihnF
	kL2iuEmb3WtgjzhZYcEPP4xCPQWggkr6ymX71AnmiAgXiNhXq5q/cxT70n6eiMtbR68xNQDqdWDqX
	jZAzWK2MN91HZ7eAoz+UhbI8CXvqm4NPWXaVskqxWbTijsudTrbh7cJVO0kTpeLh85T/Eo1m3iZZe
	/4uL4UaQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rZqaP-00000000423-2qcq;
	Tue, 13 Feb 2024 12:04:25 +0100
Date: Tue, 13 Feb 2024 12:04:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, anton.khazan@gmail.com
Subject: Re: [nft PATCH] cache: Always set NFT_CACHE_TERSE for list cmd with
 --terse
Message-ID: <ZctMudRsOO96pNGg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, anton.khazan@gmail.com
References: <20240208130859.17970-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208130859.17970-1-phil@nwl.cc>

On Thu, Feb 08, 2024 at 02:08:59PM +0100, Phil Sutter wrote:
> This fixes at least 'nft -t list table ...' and 'nft -t list set ...'.
> 
> Note how --terse handling for 'list sets/maps' remains in place since
> setting NFT_CACHE_TERSE does not fully undo NFT_CACHE_SETELEM: setting
> both enables fetching of anonymous sets which is pointless for that
> command.
> 
> Reported-by: anton.khazan@gmail.com
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1735
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
