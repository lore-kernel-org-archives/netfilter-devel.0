Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34B0156243
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jul 2024 10:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720519791; cv=none; b=cxIcPD1H8kXfeQEThdG5Pn6gx/Iv9WTkxN1tyqfpF4lLZjfE2A7aKxCKV6XfPBFV2LEVdgYyl6Baqj80XhFcqYjuBjYnbcU6Nn0mZUUpumJuOkPdrz7wlkKn8d/Q5SornqCc5TsFoz9yxaYX+K0+lGS21cdSvslGJj4bNXV+0YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720519791; c=relaxed/simple;
	bh=qUeLATkTTannbncMKJIb3BessQXbLHm8vP4sYkkY7h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnKg1U44fDIJHYL0UqPZXeirIqqh+6NisMXZyWMAl4iYQQ9/7rWm0tywaWET6BBNiLwgi7fh/qw4v+K1XegZmkEVDeIxHIBPrZXU0vomvzoISNXCdhMqKQd+Sjg5BKW0mjgyF3aLRfc8hL0aMbzdkY7s27XV17RjJsV/dU45sEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XWbQalZy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XWbQalZy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OePWEt8qaLhWDbcLd8/rJ2eIi+ixHfsWn8cFN/bAhhY=; b=XWbQalZy8b8NcnzrDM7l+xPZfz
	lSIHp67i4Yfskut3gxR9KH0GxZxBcVH46/TAbULuW0Q0CiVYinKYHbf8Oof4jeq70fiVdV0ChGnIN
	AMIz9Oh83oPgR3Jt7GyqnAt9+XieYfIJHfpeiRq7+RdEEe9dESBVw1KBaAdnEfZMoc7Vql0r1MGQk
	DXWUl+OlflRugW35ZmvFrW4SD+CEfWI0aqnfJMf8ViK011zL8E4vTjfLi0VT4d46DGuAG9JD5KqQ4
	Ot/vnJn+oB353H6WloQfkVlF9N3zkZhDWudQSKVLf/iu40nfsvXC2FTngJiMz393NJm8OlvwV26zX
	oh5HakIg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sR7n1-000000006Xc-2c7K;
	Tue, 09 Jul 2024 12:09:39 +0200
Date: Tue, 9 Jul 2024 12:09:39 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Cyril <boite.pour.spam@gmail.com>
Subject: Re: [libnftnl PATCH] expr: limit: Prepare for odd time units
Message-ID: <Zo0MY_SLhZgisPn4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Cyril <boite.pour.spam@gmail.com>
References: <20240413030500.15593-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240413030500.15593-1-phil@nwl.cc>

On Sat, Apr 13, 2024 at 05:05:00AM +0200, Phil Sutter wrote:
> When limit->unit is not a known timespan, use the largest possible unit
> and print the value along with it. This enables libnftnl debug output to
> correctly print arbitrary quotients, like '3/5 minutes' for instance.
> 
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1214
> Suggested-by: Cyril <boite.pour.spam@gmail.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
