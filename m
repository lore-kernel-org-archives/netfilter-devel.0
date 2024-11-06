Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3108206515
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730913232; cv=none; b=Edz1B9suqaZ2mIO4iB1TswvQtW+dCdH6R/y8qIV5PkVVMPyCUgrMrA/54Zf2bTjd0mtuD8q1TECkDUUeXsKZtT27O5P4Ylin38GHOBSOYH2nMMIjdR4zyesh72atLQxL4HBRo/UZAvhsG3kGK0OzVjBwnc7ASDo6/vdgT9fYTxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730913232; c=relaxed/simple;
	bh=Uqp8q28RFHP9bm17HUI0ix1MU//UVDMncA/oz9M9pPA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyFxAsy07e9u51dVtbuQ01miyBOGi9Nalooygp4il33inKmIWVZfmOCIIHcJU/v9qFi8GC9m5gWPb9mLPOpsm3qOHsbvb7TOUUU6zXrXy+it/caDsGLL5StMz8bE5bdolFKoz18c8OVtuzM7e4GmR4edPeLBk+ZL93F6X4HiqrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pVv7uGtd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pVv7uGtd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zwwbSmm3JNpVdLco4n2v2KlN9Ger+P2mbHbc/amkrzg=; b=pVv7uGtdQdrLya4bZfQDeiQ7Ha
	BMahv4d8aDW2J4thYDrnpQn04fRA4AoZuAFWkfveS3B3iSduBVklTyjKEkfks1eBTXzUb/rR/gqgB
	qMAO5SQd5XaFNEzvb8GTTKGR8CjNWkFZiuN2f94qxTvqetEsWmk4iqj7JwlC/XRHyryHjrSOvVET3
	wldYVczbCw22TkhTrzU93t+ae9adx5T5WM4Ax+rAeGeKko6EpYy/JnbHh7Mq45T3eqQO9Rkdnk7QG
	7h8qPh/TVYKPa8WLd+mdGxMsBwzgfCIQcckSX236gqkfwvDhgSLlc6ynpgNujANeN4EXev5+9ERWJ
	DXQYyK4w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8jbJ-000000005tb-0Xdv
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 18:13:49 +0100
Date: Wed, 6 Nov 2024 18:13:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/5] tests: shell: iptables/0010-wait_0 is
 unreliable
Message-ID: <ZyujzTjLqffHNlPy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20241106164232.3384-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106164232.3384-1-phil@nwl.cc>

On Wed, Nov 06, 2024 at 05:42:28PM +0100, Phil Sutter wrote:
> Sometimes the test would fail, especially after removing
> /run/xtables.lock file. Looks like the supposedly blocking
> iptables-restore coproc sometimes takes a moment to set things up.
> 
> Fixes: 63ab5b8906f69 ("iptables-legacy: Fix for mandatory lock waiting")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
