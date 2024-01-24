Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04917C0AF
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 14:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706107032; cv=none; b=QeIBak38cCnuK5YZj70NJ8lRDx6mBwuBbmrtlG76HIk1CBnMLLUjeNvToRCvV1rDjNWmiP8HwN1nq7mx/AdGc7LxK1r+Ho93zLtjdYJX25itJ5QLtr6pgAH045TiYVBdF6eAMBsW9O5MLLLbAmr4fnEdEo1tCGw8P+ZHul05N+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706107032; c=relaxed/simple;
	bh=iHxTaFcl0DTjaWhDttaRIcAK32pO9+8MmH0jMM5cpnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuXRgnk07n46JoE5zI6SyXWqB6+tlIyUecIBBpqV09IGcYSYkOz7D1C/h9SsLzFoqVkFNVT7EfaXpW6ppdeyhU+wkfwOuW1Xti6oB677JdbFd+OxtCN2vZfmpHG5F1jerVgv+hn8HdWm70immoYfSxpyzGfnkKEs6O6+Adb2hh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=C/F6dC/C; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="C/F6dC/C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=32UKuGaDtUXLoJDSEPYszNdFhB7u5AqgztwnaMXTauc=; b=C/F6dC/CSo/j5dZeCcGgfhPcdx
	CYKsprlGhWR5/PQ2AvqpIWkLE0dsFHHDOW6xWtOUQptQOfserwAb3ijwOjbAEk6d5IouRPNc4JYWY
	yYD5BNpFsXXpEGYFxvi/W45uKTl7QetbqZ/sZWO8dEiLcMnLikBjWkCztDKeOsiyEno6K2jGKziVf
	GMfHIrSVtWdRs6hxjSqPJa6VGm8gT++e/PUIXVScfx4ndnMNj/uTOeoPZb6d/aM5KzYMCEZueHTok
	O2C7v6aKXjQNDxf5Et2Jg2qDlhO3Js0dUgzJpGoO6eLrG4hxbAPmomSwXYCPQzf8bhZc6cjSqt6gt
	c1RotpUQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rSeNH-000000002V2-1b5e;
	Wed, 24 Jan 2024 15:37:07 +0100
Date: Wed, 24 Jan 2024 15:37:07 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jacek Tomasiak <jacek.tomasiak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Jacek Tomasiak <jtomasiak@arista.com>
Subject: Re: [iptables PATCH] iptables: Add missing error codes
Message-ID: <ZbEgk7AFH3pptw6o@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jacek Tomasiak <jacek.tomasiak@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Jacek Tomasiak <jtomasiak@arista.com>
References: <20240123101428.19535-1-jacek.tomasiak@gmail.com>
 <Za-yLDmJofXFCuPu@orbyte.nwl.cc>
 <CADd2idYTR0bhpm2rPc_BYoXyO2fxyxKa=pzSVf_vN1eSe1GsPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADd2idYTR0bhpm2rPc_BYoXyO2fxyxKa=pzSVf_vN1eSe1GsPQ@mail.gmail.com>

On Tue, Jan 23, 2024 at 05:14:50PM +0100, Jacek Tomasiak wrote:
> > (...) I failed to find a working reproducer. Do you
> > have one at hand? Would be good to add a test and maybe add a Fixes: tag
> > unless this is a day-1 bug.
> 
> Unfortunately I see this behavior only inside our products. I couldn't reproduce
> it in any other environment. I suspect that this is related to some
> kernel configuration
> or modules which are present there but I didn't investigate it further.

Thanks for your feedback, I applied the patch as-is.

Thanks, Phil
