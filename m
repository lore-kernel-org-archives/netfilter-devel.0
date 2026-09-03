Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97843164C5
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 08:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788423064; cv=none; b=e0h/JVEDJ8yQjvx61pdfGRVwreI+kU+1+al2Ks62G1fWEGNj6HhhyucL/aLKHk0T5naSHXae00qYrYJcAJBDCGQSn67NXpc76tx0Gd7G5VrOT1yCX6COaKye7gk5NZJCLY0yEriNCG+hNU3l/0rtkM6eg2nnyA5GrGlfNuKRSv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788423064; c=relaxed/simple;
	bh=yW+zJ+WrMEh6GVU0mbaswbeJq94S/3LXSkASp1cgT8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/qaqPE1Gu/5QHwFL46qcoEYtszGOx5R8t8WgpD6ggD2aCULQ2YvSQStntd61J9KqP0E3FNRfgoTObwNqJTSK8UmPT0mUBy5xyWKQwpENjL7Od9erVpysPRk6QlZCurUyA6UK678Dbfx5Om2PGMsCyzV++Ly/HLjFxfoRDIGs8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pOUAgXOv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pOUAgXOv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fyXkySHwnOy8p9cdPTEPbLikVkf+fnXSNXVmhoUZQes=; b=pOUAgXOvqQvQ1yNVBX/G12FxjW
	RVkJENfnqes4OUZAFiTkaWwpSsVZK0uGBhQNMNuWh01lmYskdPaitAU4zs9Csnkj0BVaeOu5bFfWf
	1AQwUbBOyzimK42a6k3LUkqdn6bPOFqE448UIkzYbHDjrzQZ/L7VtzUECI0mRdyvWb+zax7linxHY
	q4ybbGOwTRiqUY4zmz0xiQGXhi/d3oidgLgnu4bwRjDVRkTiGeJTJqctCLaXoC8PkiJ1neaxfghin
	vJwT/rsE9QDCWFrcoPdOL0sFzqhHz8EUDlRO/Z3CHw3qu8lS2oDqeiC9EGe+xHVkFRhuvYeqr9Idp
	5ZOmdQSQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x22XD-000000007jc-1IVh;
	Thu, 03 Sep 2026 10:10:59 +0200
Date: Thu, 3 Sep 2026 10:10:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Test odd netdev hook updates
Message-ID: <apkrk6yl5etmE364@orbyte.nwl.cc>
References: <20260827204255.274666-1-phil@nwl.cc>
 <2fa302ed-71bc-4136-8955-cddb234b5e24@suse.de>
 <apagf_aZh7-dre1O@orbyte.nwl.cc>
 <apbns1SLfAn5zClE@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbns1SLfAn5zClE@chamomile>

On Tue, Sep 01, 2026 at 04:56:51PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 01, 2026 at 11:53:03AM +0200, Phil Sutter wrote:
> > On Tue, Sep 01, 2026 at 09:54:27AM +0200, Fernando Fernandez Mancera wrote:
> > > On 8/27/26 10:42 PM, Phil Sutter wrote:
> > > > These should cover what Fernando fixes in his kernel patch "netfilter:
> > > > nf_tables: fix device name and prefix match in hook lookup" as well as
> > > > some bonus cases I came up with.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > 
> > > Thanks Phil! These tests cover a lot of different cases.
> > > 
> > > Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > 
> > Thanks for your review, Fernando!
> > 
> > Pablo, I'll push this out now, which means we'll get two failing test
> > cases until kernel fixes are ready and deployed. Fine with you?
> 
> We usually wait for fixes to propagate upstream before applying tests
> to userspace.

ACK, will do.
