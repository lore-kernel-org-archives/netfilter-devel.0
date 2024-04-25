Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5F1EB3F
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714042204; cv=none; b=mso2n1rPgvbC/rhtowpWuQb3ZPaqboJZ5S4MJY4YWGPaLplLp/XltjRujP0wSpbh/64dpMeq1Ccd4HYcT1WNkKzhDLEh2aG4EEiy1x+0ZLdWY6cfJqP9qaTMeIxrGGuagEOKHzEaaHH7Qpfo9eAAdqKR7LtlUKz6eSYrlVs5Zq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714042204; c=relaxed/simple;
	bh=zsM8mIq7DQEFkH3QP0soRioEMf+huzWwddaui/7+rTk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8r5OSAdWp9Y892uEcW/bf7I0G7OMsqhFRffXdZIEr3VURqHO/P5ADJIf/8BkDGeuMtLpyvUZI1NuOJW/SCkjHijj1kxG2q1Jog7LIux+SEKpgmfpD7BAz4/k41E9SedZwTm40HGZ7XI/dyJi1JZsWnfxO4I5TYK54xBvLJkmO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DBX2TGv1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DBX2TGv1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FPoiB6MmLgBwxTA8/r+U3i/dt8QlitjsohZe+JHoklU=; b=DBX2TGv1Qf8U1vxuR6HhMyjK01
	L2RlBuzdnxGQ1cPe/SiF9rVYGg9gastBSfk6VpXkfYJxkmbNpozMG7Z7VQLKopqDabEb/v0pBBAIO
	8O1F5eSU/5Om6cPG7klelc+NV1SZOBvN2O/E4saNnSuZRm5hkp+1lKUajsMWZhWk3zC03Iwxn4AEC
	8s7/GTU2/ACgTh0gdnluAhNlWt9Mnp40MPiedBaGNYhMvFiyKUERVsFoRVje8mTN8VMg3o0WhamMX
	el50fZrG+6iT6bAWgJaHAgN1ALu9VHEhXTbrBxQusWbKrNHydljyK9s+OnYv4Y83nhDkEIiHFdtJz
	RYdDylEA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzwfw-000000004TV-1dDY
	for netfilter-devel@vger.kernel.org;
	Thu, 25 Apr 2024 12:50:00 +0200
Date: Thu, 25 Apr 2024 12:50:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/2] doc: nft.8: Fix markup in ct expectation synopsis
Message-ID: <Zio1WNANHhRjZFK0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240424220048.19935-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424220048.19935-1-phil@nwl.cc>

On Thu, Apr 25, 2024 at 12:00:47AM +0200, Phil Sutter wrote:
> Just a missing asterisk somewhere.
> 
> Fixes: 1dd08fcfa07a4 ("src: add ct expectations support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
