Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0625119D09C
	for <netfilter-devel@vger.kernel.org>; Sun, 25 May 2025 07:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159906; cv=none; b=a//8uQQatSS9Kyw+dJZgAgI6aNxdnRbonIIXzZ1yPDdZALe1liN8fPLAmvI5GOu5ygEfmFWGNQ49rbwWmZ7pdfiX/ywngHcYNKT8Y14TI2WHeFOCz6luQta9Mq/Elwbyrm0B4uk4hkEJ5PgZSW9SwCLwUS+Te42Z1KRwIJ2/qvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159906; c=relaxed/simple;
	bh=PlARokZZqJrHvoD0+d8Fl4sW557jQZr7bc3lR946PyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6ODd2X8rCg8ScfOqOivoutRQhv51DvgxlOUqooMuVzS0mc79e2WNEe9rV2hUusoAWiWTRyWTMsDaV2+HmbXgeaGQndLJE6e0JGdSR/W9kzHwHVB95ME0WAPIUqSvHhDK1Tuc+Q6FTOk7jSRGhdbj9xI3NUJLHA64j+61SZhAKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h4TQT2qe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h4TQT2qe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7YEP8ws4xeCVuSBKTG8JBBqmyZSr5beLOG756W28cPA=; b=h4TQT2qeP6Lpo5Kwebji7ddPeC
	+cIGizALubQDeYJU6HNxlLZAFbDuo/tFNA7PU+CTpTp+EItoI5PQo+atc3CPpjnxDCQ8FM+VYtFnr
	Bzoo0g4wuUoXMWMcZma04b4as0iG1qBcTDvvYVFJN6aTZ/ZyUSv5BIgRivtpofgCk9fqz/yorB/0C
	/59GXx4NUreuFjxPRZfezVGZs8Ib0GrwBDu4FmT/UMNukTtrVTgtSoCu43TXEqMbcOauUqXF+H787
	6LPUPP9E0yCN/5oj/KpT/utPyLbCGC3QmqGKim+c68z2TL2BvdRzoe/rWbMyCJCtTQ7j0cF3pmdvJ
	edRXM32w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uJ6FK-000000004lb-3XGM;
	Sun, 25 May 2025 09:58:14 +0200
Date: Sun, 25 May 2025 09:58:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/4] Continue upon netlink deserialization failures
Message-ID: <aDLNlhktZLCtTlBp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250521131242.2330-1-phil@nwl.cc>
 <aC9cVrmOpQKNs1MW@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC9cVrmOpQKNs1MW@calendula>

On Thu, May 22, 2025 at 07:18:14PM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 21, 2025 at 03:12:38PM +0200, Phil Sutter wrote:
> > Faced with unexpected values or missing attributes, most of the netlink
> > deserialization code would complain, drop the nftables object being
> > constructed and carry on. Some error paths though instead call BUG() or
> > assert(0) instead. This series eliminates at least the most prominent
> > ones among those (patches 1 and 3).
> > 
> > Patch 4 prevents object deserialization from aborting upon the first one
> > with unexpected data. If netlink_delinearize_obj() returns NULL, an
> > error message has been emitted already so just return 0 to the foreach
> > loop so it continues with the next object.
> > 
> > Patch 2 is just preparation work for patch 3.
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied after dropping two explicit newline characters leftover from
BUG() to netlink_error() conversion.

Thanks, Phil
