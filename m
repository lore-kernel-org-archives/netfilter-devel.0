Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB20263F2C
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747738447; cv=none; b=GCgcDiKiw75ZSUZmrLAIImVC2YR8C6PKn1Ssugzofg5BNqv2pRy1kbhlUbKXlRD+ytINhia2Icw4dIe4VrQxxfblS5MoZAFtIA18kJ5X1EmDfWQ6lrr/VuTfTLo1VwG7A6QRNC0dHGwsK25IIJ+Ra1a9r3AknQLP8YUnEaiI6qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747738447; c=relaxed/simple;
	bh=/Ghy1DPcQ8sWnbpX2QWdPD7irJcaZNZtRu3093FUBzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ex+kTDOocx6iZT7q7Pau6jraJB0lJLitumoW/jeN0qPVyWJUTdfB+qTjZwjxPLUY1VjdwXNBPRYQUeVBJT/tmN/wGR+b2gPh3BnFlJIVvv3Gfjz5EZdfbMCTwrL79AcZ7An2WC0uc5bKtb/98GfqGcF8K2r7XhKt5t5qYufmDzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jPiHThf5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jPiHThf5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gG9f0K8SkpiU1qUPmfkR8gFmkh+A4C8XkYVSYW15h0A=; b=jPiHThf5QpEtWjTsi4f8wswByK
	iLlzmlLxcGmKoOeaW65C4gyGwdL3ylOVvauZvEAezmbTCyCAyhd1hzQwwLUgykAUMQVip36TEtfPo
	FS3ug0XARrnwBiHNCqotwv2fKTzivKYkeWC+WxjmUeUsClN/UWV2n0I/WAqwSvVdgKp1M4fU21gPS
	FjnM8RvUqdzbUvtpuqTsMNDjPhKSmEoYZpTa4xlD0HHfffVvGCU4hfj8P4weF3YguF5TFCPANNBqw
	AJXvqI2edLBW1JHsyd9IMMKFAlHPki/ft0cPCzT6k5KPe4RJCCvfKHsLIOF+8SUAmn+xsc5YBZb5k
	6nyp4hKw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHKbb-000000008K0-2igN;
	Tue, 20 May 2025 12:53:55 +0200
Date: Tue, 20 May 2025 12:53:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/2] Sanitize two error conditions in netlink code
Message-ID: <aCxfQweTusR9IJM_@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250516182533.2739-1-phil@nwl.cc>
 <aCxa0jpNVApPQyLP@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCxa0jpNVApPQyLP@strlen.de>

On Tue, May 20, 2025 at 12:34:58PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > While reviewing netlink deserialization code I noticed these two
> > potential issues. Submitting them separately from other work as they are
> > clear fixes (IMO).
> 
> Thanks Phil, please push them out.

Series applied, thanks!
