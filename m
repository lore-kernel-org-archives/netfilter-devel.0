Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D261EFF9B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920419; cv=none; b=Vyi4ma8hrx1BEjJhdWD4+uSuQHSLyc9RhXsHFzQDRwh6tmvwhF1vFl2zpoMJi/xCftuK3Gam81jDBvnhBXM33oxCx41YTjJ9cSPHcl2A97tY79jN5Oo9Z2Ll9FgrzOQ2yL9EpWY6jzReDiPGBmk71jXfhZy+KMxoxCVZiBU3PNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920419; c=relaxed/simple;
	bh=v1ClaqhK3GBAbxHQX9atoBF+S+IIvyOzKScAIbwHTMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YI9rnwrS+1aufuWvRwD12gRNTTDsovyDlj6/Y1XFzNH5seY2WPnCdX7mqxPpnW19CYHW++hqwM2Ho9Q9WlhVEu5cTqfW5N3zKP7HDYpCO5erUeStCCF24Od6xuuAfEaJCWbPNgxArpY7kZu8rKeAsY+jkGQnEICqDM3/lP3v7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nm4EjPkR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nm4EjPkR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6mX8HevwjLdceZQ6Tskljqp7794BNSm4Ln1NHvQzb+U=; b=nm4EjPkRojt0ou824LmPDAf5rG
	dkVHfRDWLJ9Dr8sg2zMQ38H9xJLw6X+Ctxju2PuwXiWImIpgOEcb+VpH9HPnCu+AB56ISYD8UqNCJ
	SYa2DmW4zS+wJo+gfsL9m/1H9ETJlX9KnLLceYw7qVluh8xTj+V57IBcOXfxnhNAKB0q65hRGeZ7g
	SeC2Vmr3QcJfUegWyLbKXMk/7FWHsaMfglc/wSGbv/ttQV9Fpk7NqTFhLcBMKED9cUaOUQoM+UQFA
	EYMJagQhXhTTgvFcl+kRYkNteYmQYdkIR6DcvyaafeGCkcr4yAeF23EaQvOWnGgz4AmFndYi4DxjP
	k2Su2cgw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viD0R-000000008Ij-17vZ;
	Tue, 20 Jan 2026 15:46:55 +0100
Date: Tue, 20 Jan 2026 15:46:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v5 3/3] tests: shell: add JSON test for handle-based rule
 positioning
Message-ID: <aW-VX8qZtJy2Kk8K@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20260119140813.536515-1-knecht.alexandre@gmail.com>
 <20260119140813.536515-4-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119140813.536515-4-knecht.alexandre@gmail.com>

On Mon, Jan 19, 2026 at 03:08:13PM +0100, Alexandre Knecht wrote:
> Add comprehensive test for JSON handle-based rule positioning to verify
> the handle field correctly positions rules with explicit add/insert
> commands while being ignored in implicit format.
> 
> Test coverage:
> 1. ADD with handle positions AFTER the specified handle
> 2. INSERT with handle positions BEFORE the specified handle
> 3. INSERT without handle positions at beginning
> 4. Multiple commands in single transaction (batch behavior)
> 5. Implicit format ignores handle field for portability
> 
> The test uses sed for handle extraction and nft -f format for setup
> as suggested in code review. Final state is a table with two rules
> from the implicit format test.
> 
> Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>

Acked-by: Phil Sutter <phil@nwl.cc>
