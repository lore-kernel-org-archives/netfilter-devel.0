Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521C9359FB1;
	Wed, 19 Nov 2025 18:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763575972; cv=none; b=qRzRLOjQKGem/5yX5A2XVM6J3IXqFAkJwSdcjba/9CnGWTGb4ha47k/NrhxoPmTVbAoaqC1NqOETjZnSwfC5kj0i2Pi8WLqXpY/6WkK6uWXowXfUk3zqxMBnaHYsxIyT8XJRQQrDIwDuNawxVce3RYJ+GU0WlamXlG3CxEotW4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763575972; c=relaxed/simple;
	bh=1+R/jD6BeO8KvyebKrvTKHputtcxzE5mZ4pHwCZ1RFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1gSa4Xxm1CX2XnNFptho1dp1iNZ/uFi31H9eeCNctHBAnyljIKURjI3E0zt/Vxk7vYBAL+s6lW3Shuws/l58oivRmMfvNAAtcCDg2kTEijPw8QSpw5BZjv+wAhe+dn0vtG3+tCqW5z5zBZC9q4dAxuMZ8QXBfizj+4WP7o6HMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oThTouGi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oThTouGi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Lb0RuLrEtrxm5hDt7hLd5sqiXnHwhSuspbLvm2GQm8o=; b=oThTouGiWnTxtSrxxb4iKkrKl6
	pgtjNqeit6rhixy5EdF0kVkxQv7201CPtXdMNiIt4oS0bO1G1N0ukDcyQMmUWKKpFFlXPHfen4R/W
	rGimbifFGL5+xY5JxhZCpi2IYbpw1E7wRihLm05kzRP56zZo0FuUxjxpYZfsNigkhxVIuKIW5NXAC
	W4hNtdP5Qo0TqiPSprZEAS6DN/dNRy6VXKjqnLfpP+0FtHuxwLYJNjm/Ss4QvjjNZIl6a768w/bj2
	dWYeqQoEVX+EN8qJKV4aakYvim2il+UKCQygkYuWXes3aCOyZc42jLhtaUplzcA4glyVhFVpKEClC
	AG01JhQA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vLmfV-000000002DW-49Sl;
	Wed, 19 Nov 2025 19:12:38 +0100
Date: Wed, 19 Nov 2025 19:12:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <aR3pNvwbvqj_mDu4@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR3pNvwbvqj_mDu4@strlen.de>

On Wed, Nov 19, 2025 at 04:58:46PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On nftables side, maybe we could annotate chains with a depth value once
> > validated to skip digging into them again when revisiting from another
> > jump?
> 
> Yes, but you also need to annotate the type of the last base chain origin,
> else you might skip validation of 'chain foo' because its depth value says its
> fine but new caller is coming from filter, not nat, and chain foo had
> masquerade expression.

There would need to be masks of valid types and hooks recording the
restrictions imposed on a non-base chain by its rules' expressions.
Maybe this even needs a matrix for cases where some hooks are OK in some
families/types but not others.

Cheers, Phil
