Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C1B400962
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 09:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614289; cv=none; b=KqLd/qkA7UD2n2SZb48JfcRVwpK+ytbSVk8z7U1UnFWxKYL7u3xnavcWYDZvQHSGNkJKMqWhBn1n7vUqvy9u+OrKMJB2zIhVZdjFZULZz5LOnJU9NdTGlCNTM9Nl6qfi5Tt2aZ8TOoAwyR5MjSAaMH0LhWJALQ0ZWXb+pQ6RWio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614289; c=relaxed/simple;
	bh=pj/vKTP4DFR3Su2HklrQvYWt2TJfZ/Bb74lwY8dPp3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5nmpA4tiLbW9HonpQmuavExIGENE0g38WdfpG6JsNwmEKnJXRZCQnlZUwkPTwozcKIvbxZsK11cOx4hyy8OZFZhEF3ipILE7hi8yFzO0OdltDQgWQYP093Z28lc/0qyeabmmG9w7TsU/iJ5k9e4zTenOCLIrCZgK0VTJVDoN+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=I8Q6nego; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="I8Q6nego"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bjFkSFu4KSw5bgu4QxsXJx+8jl80lvrF6e84TXgxyZE=; b=I8Q6negogJfAZrmZsNdlTiUi2G
	KYIOMuysSIOwoUU8H3fZm1VA/hZEOhMuMID8Mo5DyL9/AwMD248f1fBIC7CFwFPl+WeCtDgGiJRVo
	f+cbuDCngRDpXTWjdRPcsdoQLptQcxBqIHk1MRWvouV/X5l4SHAIK5iCGgoTIOrSCKjb/lD/6TjLW
	YPdE8VJx4+FlIvtwtOH6ZR7j+eNzhUee27XLXBMkgeyTc0Gx0MwBRMfF5CfeojRn2Qf9AqCBkbWVY
	4QtiugdlQt2+h6L1VBvdtT0Xku9xpunJahXqqujQbLf2uY7Cg6aSmmwOYF1wWAvANLC9LDaHeMbfV
	H9rlgsIg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wuRyR-000000007Ty-0JNU;
	Thu, 13 Aug 2026 11:43:43 +0200
Date: Thu, 13 Aug 2026 11:43:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: use an unassigned protocol number in
 exclusive_start_cond
Message-ID: <an2RzmRXZBV26Y03@orbyte.nwl.cc>
References: <20260808013327.2766739-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808013327.2766739-1-avinash.duduskar@gmail.com>

Hi Avinash,

On Sat, Aug 08, 2026 at 07:03:27AM +0530, Avinash Duduskar wrote:
> nft renders nexthdr through getprotobynumber(), so the dump records whichever
> name the host's /etc/protocols gives for the value. 0 is "ip" on Debian, which
> carries the legacy alias ahead of hopopt, and "hopopt" where /etc/protocols is
> generated from the IANA registry, which assigns only HOPOPT. The test fails
> there, and the dump cannot be reloaded either, because getprotobyname("ip")
> finds nothing.
> 
> 200 is unassigned in both, so it prints numerically everywhere. 255 would not
> do: Arch's iana-etc names it "reserved".

Instead of playing whack-a-mole, we should pass '--numeric-proto
--stateless' to nft calls just like py test suite does. Let me submit
patches for shell test suite so we have evidence for a discussion.

Cheers, Phil
