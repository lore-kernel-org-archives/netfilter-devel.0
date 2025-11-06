Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F45A2D7DC4
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762425409; cv=none; b=A3eq/oTsMvpteXCwLcLprc5CGLpKQSF3mCLy304XBD2Le/Ifplr5URmGFPgQYJXT3ztCoC3G8szfmM8Oq6gOlgKkxuM6i9p56awbJilXC9ukCj363e/nGwmwz9P0f4XYK1kCbo6fQ4OZAevXCCqE/a/ta4iEyejceosQXX9n/iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762425409; c=relaxed/simple;
	bh=ANM5iTix5GzMGqZg/sGiC99opSm5i22UQj0nCqdWe7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liFJsmaYZUgOTqrIbRpeFyPCh+PDBlJMNnkJGK6KysJu+wIXxO1WjH3Gz2V8wvIVyUk328tT6mE3J5zeS0mcONtrHOL7rd3NmxvxpH8rRbl2qtTNu6RyGqRJwsHBPrOP55MBPy8vmfEEeJBldwFZi2UshMoPrGWVQjimCLbIhGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QD+Q65d3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QD+Q65d3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XUa4T+RVM+THgbXQo16lahuVCteGkP6VrTmfMK5R/uQ=; b=QD+Q65d3yXOv6eqJzh6VZnI9rj
	8cwHWTfRkIkDxw+a1kWniSOMn9/W7lpvI1nzFAjYLvBW6O8uQbmfmC6Gq7MrF5ENv7U2hHxNPCmT3
	bW44tx9AVKLauiM4gvSShWqYqUZYPhjmOvwYXy4c0dLTSNujSAoM7QLckNqsgCX38AbCeXwl8DoHT
	8iGNBRsAdSzZ5NBJJPji452Wif9jHIVI2sZmtMh7IQFr2nlKg0hdTR1lDt6M6QUwO9L7jBUo6xQeT
	POqjK8uGQy/j5WuRR+FvIbFSg1aOvaF3i9qQ15oKLRs6JXdE32avdf45Bg8Gf6EssTORHEGvVoX6d
	CtAMoC7A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vGxMC-00000000523-1KuR;
	Thu, 06 Nov 2025 11:36:44 +0100
Date: Thu, 6 Nov 2025 11:36:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf v3 2/2] doc: clarify JSON rule positioning with handle
 field
Message-ID: <aQx6PEYRIv68lUAj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20251106091609.220296-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106091609.220296-1-knecht.alexandre@gmail.com>

On Thu, Nov 06, 2025 at 10:16:09AM +0100, Alexandre Knecht wrote:
> The existing documentation briefly mentioned that the handle field can be
> used for positioning, but the behavior was ambiguous. This commit clarifies:
> 
> - ADD with handle: inserts rule AFTER the specified handle
> - INSERT with handle: inserts rule BEFORE the specified handle
> - Multiple rules added at the same handle are positioned relative to the
>   original rule, not to previously inserted rules
> - Explicit commands (with command wrapper) use handle for positioning
> - Implicit commands (without command wrapper, used in export/import)
>   ignore handle for portability
> 
> This clarification helps users understand the correct behavior and avoid
> confusion when using the JSON API for rule management.
> 
> Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>

Acked-by: Phil Sutter <phil@nwl.cc>

But please let's wait with this until the related code fix is ready.

Thanks, Phil
