Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A78884DF1
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 20:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718225080; cv=none; b=sSaEdpIj+ysgWkyRhhb2mNTzSev03Z6UfMreysfMsqYeEEGY08FaCAipfGN3UL3PXzPLfx6S+SKCqk5ZtcPN3LEnZyx9+itQA2qrLrV/TSCHIUzVaPIPVBQdbdCvL7sVe8eADs/krmKDd+S83ERFfWdjZOkR2MtpADiM8HTJRJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718225080; c=relaxed/simple;
	bh=qm6RDNjCbeUkYgTsG8AYCoTQZ8JPq2MfPPkBcg5brXU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TiNN0h5Kj7u/yx7p+kh90/50FAhAJjleAEVwGHZ1jQX03ztQF3T3/siixe0tcgs+JvsFJbe1ynJ6zHUYeTkt8t2po2XgWf6CaJpHyEO4l9sojyVL9NAs/7OrD9PWzFdg4AhIVpy45xxfqg/mANPkc6vQtnY8JBXheIIkE/VP/8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SAh3/yk4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SAh3/yk4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KzV1OUPMfL5S0qe98FqlbpyEPcKogJV+5T8axJMEg2s=; b=SAh3/yk4ZgYGu4TrgPdSpFTor2
	OPGa6LXYlzGxk+qvkewSswxN9zCLxq5PeEnUcnb58sjAkhHHZPvhsvCEJax/2Vh53BzZ5cEg690Gv
	cPHwHftJbB3RWGcduJMai8IMjIhpqpA+Cavs26DDZGwObUSRQz9bHAUXYDoM7hUdDQewcnbKcdGrp
	uBYrGYKndgxFfAdjiCKcio/RJZqzj4eZMeq/LYD4IjxuIanpCdaSTkKypl7O+dz7sPbiIxDxdLBKl
	y3/CiiUHTmDp/OACAcKDdfHXSuFV+RcUqXkzLc6a12CHd7zT4KORMpNlIEzGxJ4LtRO15eVSE6sKB
	4dXTJAsQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHUpf-000000001po-2I1x
	for netfilter-devel@vger.kernel.org;
	Wed, 12 Jun 2024 22:44:35 +0200
Date: Wed, 12 Jun 2024 22:44:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] man: extensions: recent: Clarify default value
 of ip_list_hash_size
Message-ID: <ZmoIsys7LmnJznQ2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240612124109.19837-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612124109.19837-1-phil@nwl.cc>

On Wed, Jun 12, 2024 at 02:41:07PM +0200, Phil Sutter wrote:
> The default value of 0 is a bit confusing.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied after adding some missing tags:

Reported-by: Fabio <pedretti.fabio@gmail.com>
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745

