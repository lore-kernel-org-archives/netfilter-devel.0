Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3737462;
	Thu,  2 Jan 2025 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735824898; cv=none; b=bauQFSAYJiGpIAzu7fSyRhbzpMzKlUOe0wGBIXr8acDZCKE1ipEydV6yQfFuibil0gICbzt/chQP/G+kIwsmVQDXGW9VRknuBLRkO8lxZVQNOKkLEF87Zdo6F9d/NZDygG0EBodJ55FQ1VtAB7mBzh5IiKkETXSUFZznUF5MgwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735824898; c=relaxed/simple;
	bh=PSiUZK/dfMsmtDcPBEXOdL2rXKl5+Mlp8gri3v96OIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFvIQr8adjNRWKfY4lNn/RIBbc9kv+SBLDVxGGVSYnThsII/6eyyU90M2/NqKI9MWuZzGbhNNujfBPA501VZsqYP6mWvT/A4jV9W4R1QEJrkLDs8CLSDeFLJIcysIP1qAU0k6IatPZwW/lJeiuv3y596zqZQYSua3tQxmw1C0Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=dGppTydz; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="dGppTydz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=xzUcEPF4YQJyIJKfKWvHWQHgeh/qSHfSFR3B8gHdetY=; b=dG
	ppTydzjQltTFjWLccqXx5e6XVUwZztIFyidcP7oYTvnz+mrLXvXLRLNwzzDg3l3fGgbclGmhIXXAx
	uysq18BUXzQdCx/0vxMQia93JukdV1p56XJugoadg56RbfQMHdh4B31WBZMd7g12nRVHAqwiqR21m
	jKGFbpnYRvHjk2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tTLLK-000kTv-Co; Thu, 02 Jan 2025 14:34:30 +0100
Date: Thu, 2 Jan 2025 14:34:30 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: egyszeregy@freemail.hu
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <b3ddacb6-bb74-4030-aeaf-5d1f7e587310@lunn.ch>
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250101192015.1577-1-egyszeregy@freemail.hu>

On Wed, Jan 01, 2025 at 08:20:15PM +0100, egyszeregy@freemail.hu wrote:
> From: Benjamin Szőke <egyszeregy@freemail.hu>
> 
> Merge and refactoring xt_.h, xt_.c and ipt_*.h files which has the same
> name in upper and lower case format. Combining these modules should provide
> some decent memory savings.
> 
> The goal is to fix Linux repository for case-insensitive filesystem,
> to able to clone it and editable on any operating systems.

Hi Benjamin

As pointed out by others, this breaks ABI. It can be very hard to
change anything in include/uapi/linux without some user space code
breaking. Also, the use case of case-insensitive filesystem is not
particularly relevant today, how many are the in active use now? There
might be a stronger argument for case magic filesystems, but i would
argue the magic is broken, which is not really Linux's problem.

    Andrew

---
pw-bot: cr
