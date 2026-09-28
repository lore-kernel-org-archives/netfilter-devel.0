Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A6296BB5;
	Mon, 28 Sep 2026 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612390; cv=none; b=Bd5tS6vYNx/9lcTfmlLhoOWmWoKBDSLphvbAbHc9kmRbueCKJW2PrGoFEllnTcNczkNpjXgKXR7Axw7FyBunG1ZQyv1jCLnunnJ/g9JhhypkTFQh1Qh30v5FelEomi31z2fC7X7RkgmEpAadYhQ318ArP24CBGI3r+jfbZ/5sWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612390; c=relaxed/simple;
	bh=T80pmibn7aSi6N9hDzJvCBDoLXDCN4HDH9fhrQVJ60g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I3rAQlulHQyGhgvxw/iz4K7HuFg9RmbxFnL9JNy3AoOh+IPscFUHLziumxsks8IvD3vZdTdpZLSAPt+BLpEkrUrKD9orL9A+IgFG26eKQrJolruKLpXeXS8wEIYzeRfjPmoznfdwRNH8rieVwDOt3zStjpyztCRGDnLWiSegha8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOwiCr9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOwiCr9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6CE1F000FF;
	Mon, 28 Sep 2026 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790612388;
	bh=ZCAoLYZlSrLohEk+mBrzJi43HvKosm2TxiN/tMhp9/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOwiCr9nqTO8nOQJgFfjCbHjXzP2hi5DPT5YSQ11oB0PBzddsScGVL47uDq3VdRgi
	 1v0Gd1qH5OzYSSLNcvcGV/aRDj/A+iGZ9ycoIcOiobZIiY/2/R+QeorPTpJAYPc4kp
	 QHbyHtI8yazJyxSe8jF2QYv2e8KT1TxeKFGd46bHKJmRVFEfHRCrgaHG9R/KTWKD+X
	 6S8u9U7ACz4keoiOA/t8aR6NJcISvP1W65YB4zdAFNvveDWrmwwT4O+UiL+WfIUsPq
	 pAR+Gi7xwemlGnwh8ru4gzkEEuOuc8it02faIGlHxM4zrGmhXnP0r0ukERhqGO1g5v
	 DwCdMVohzSKXQ==
From: netdev-bot+sinfo@kernel.org
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: br_netfilter: restore VLAN tag on
 refragmented IPv6 packets
Date: Mon, 28 Sep 2026 16:19:47 +0000
Message-ID: <179061238760.31693.2318453255259270234@kernel.org>
In-Reply-To: <20260928161830.351199-1-parri.andrea@gmail.com>
References: <20260928161830.351199-1-parri.andrea@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
