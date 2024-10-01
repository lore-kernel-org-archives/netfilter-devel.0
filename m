Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C998F1B86E6
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 19:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727812225; cv=none; b=JLtQ6/vxlMtONbwfPHKfVIM+Cv8VpxiLvANG68X1HjlIhfZ6JlqGCtRrnT+F2EDMbmLSB6R+BseZDo2DGMSr9y1p3C4lLTYoEBtm0yiVv3L+Teu6F2ZDusZuiozu2BCVXTcMytflYfoED3gVR323eI0RGTdb4BpDN9zYuMRX43o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727812225; c=relaxed/simple;
	bh=2+C8LyMu1WsBwh0B/IpfYc98Bb7W85OVUCFgjhS0qgA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eX2XVA+5Zw0/quycTbGfGlli5JAlvz7pxA5i1ERvmGZbu5aOVaXkdF6EeN6zWwwCw7SPyXN4Dfhnj6JfdiEVcQISFtGYpnMN2KPWyhhx+nxbLmmftNHi6SKCg19z+C563XqXLoXtmt6zO/VUhKOPU2kSOYpQ3ciwYYz/pvsCFWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EDp73Xbh; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EDp73Xbh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1yLUI59jVAEx1l0miUQRBuvJbFCU1GOCn2x2dMSwQIw=; b=EDp73XbhEQ1Wuqpf0LD8ysak//
	QLNksHmerdW4peWosnTuIEEw6LURwNaIvhVL5JeUmpbfShl1YCfGp90VUcimawdg3c5NcpK+3jvhs
	FF76zsBxGhuUmYrPucmFWnWvnAUgJdwmiIibNfpkDU0Ryx9KM67aInclCpk64jabfzcbkgywdMnfv
	rg4d/NZN1l2iJNNxFu7s29WBQh9nzHXWSEu1VuHXq0WO7zKNl/Z/R2ktYZWk0lJK7DVIo6XxuzrD7
	v59kUpgdi9evPsySbybwrIexu/4QgV5/SLvchGkrclDBsOgR21/kpWbqnVAN83JOcvImNfklsxa/6
	GnnQ7z/w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1svit3-0000000049J-0m7R
	for netfilter-devel@vger.kernel.org;
	Tue, 01 Oct 2024 21:50:21 +0200
Date: Tue, 1 Oct 2024 21:50:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Adjust for recent changes in
 libnftnl
Message-ID: <ZvxSfWh_giVQwhlS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20241001194844.17817-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001194844.17817-1-phil@nwl.cc>

On Tue, Oct 01, 2024 at 09:48:44PM +0200, Phil Sutter wrote:
> libnftnl commit a96d5a338f24e ("rule: Don't append a newline when
> printing a rule") affected nft (and iptables-nft) debug output in that
> no extra newline is appended to rule bytecode output anymore. Tolerate
> this in the sole test case it breaks by ignoring changes to blank lines.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Also applied.
