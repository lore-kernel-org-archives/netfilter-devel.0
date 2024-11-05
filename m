Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71F51FBCB5
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847342; cv=none; b=PyoMPQgL/W8XnKnIhqK2IaiQ47IsQU1M/szL4w4eXreoTplZsl7qKOamCUfI5MszSg9CKyIS4RN5YwANoVSh4sNvMrh34oAfUQvlDu5BMuymEW67gflwcVoYPuA7ir1kiavmOEW3br+5sNtooE3sKfI2fv7LH57YVCUeIoNURk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847342; c=relaxed/simple;
	bh=ohuf0kTll2IZNWPzrH8FydlkyltolxbkYgDalzljz4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSI9Ih67EBMdMAIlDeFbxZXyHfzkkgs17iY3kRaDBMtGeIeh6rpKvaq+LNNv1o3ZxiM70sQ735c4PwmT1SawznkFE2uCU+b/J+/d09Ehj+7EAwuEkjOGIX15C3ud9fgB64e2yRgx4sV2NZLvtdqThH+T79vIiSPfUe+2HC/p3OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XRFCO6jg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XRFCO6jg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8Gz4vYZ/MJeWTGz/78g3iEKIKgFuPEzb3fZsky2zFco=; b=XRFCO6jgqx+xbBRBJS2BFQFsLT
	LDHzna/v1QN9qgvvfOICVnA7Z63ad0fvKqmqZkZLvNyNvxRiCSqRr/S3WZVpnCqwGDB8Q3hQtd4Ke
	wTBl2FLU1ymKqKy9Go3/BwiyXesk83kHWnqAzUFrn8sSUp13TsylPZs19HmCdJMcqrkbmy6zCiAJx
	5PWoqjIK11Euf3zICoRx4EK8lZdrIWET6hPHO2CI8TYttmffJoCg5r/y8JqVwhsAkvmvrAOA2Ckj4
	pnyl5z0Qqu9n9ySpuDkKv2pNJglwLQsjmcSVBhxsrdkoNJw0aI6WT9WmWbM0mYcLmsVV2sEJKvyXk
	uqkptQwQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8SSX-0000000058T-2Sfr;
	Tue, 05 Nov 2024 23:55:37 +0100
Date: Tue, 5 Nov 2024 23:55:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] conntrack: Fix for ENOENT in
 mnl_nfct_delete_cb()
Message-ID: <ZyqiaUsye6SXeXts@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241105213310.24726-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105213310.24726-1-phil@nwl.cc>

On Tue, Nov 05, 2024 at 10:33:10PM +0100, Phil Sutter wrote:
> Align behaviour with that of mnl_nfct_update_cb(): Just free the
> nf_conntrack object and return. Do not increment counter variable, and
> certainly do not try to print an uninitialized buffer.
> 
> Fixes: a7abf3f5dc7c4 ("conntrack: skip ENOENT when -U/-D finds a stale conntrack entry")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
