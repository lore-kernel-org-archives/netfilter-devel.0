Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2313B1635A6;
	Thu, 18 Apr 2024 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713459115; cv=none; b=gUQLCtXZr+vtajx31Y8nYDW2WCOooLGta1WaDg7eihXJkxCDpWttQHks103mC51jiKUZRCH4d5gTBsSphgmBUvXNgv1UrMcvjqtHj/R7kOc7yuiLxeqPfmrQFSgTgnUeh6Jo0B09GSxg7hwnzcopRJ18d9/sYuTQEbjJf/wsBTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713459115; c=relaxed/simple;
	bh=2FQJtEzz9rqrA7A6GSqhlQLjyYXUEdlyTHByrNoXFPE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0a10LSTBhN8xlwTLf5050J/ULOIiZf8OfdzU69I0i3Crt2sKNVLDAHSw20dcQdEyzMszJohJ7K+38rlfkixOz+oDb3VAua1x1t1IAf4gFgzF6tHtLuSevwE8xFQvVX0n/ZaI7P/L5anFBHrMfXgea9zPD6CornHZ5AGQ80eN1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PO0v7eXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PO0v7eXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B3EC113CC;
	Thu, 18 Apr 2024 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713459114;
	bh=2FQJtEzz9rqrA7A6GSqhlQLjyYXUEdlyTHByrNoXFPE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PO0v7eXdFmLLWiPGFN6l/qbYmA63Onr2VDULSaRTa18HZLT1cePfxgWQK6DnKzwya
	 Bc4blew8Zr3/tYqfVMGnyU6zk2dQupmpV48Kc34DPwH8adnn7ooYmSI/4o6y5e6/JY
	 ocIrvs71dwYdGGK5tdTn3ELesJQ45rFN0QBbOkZ41f3z9NxgmeK5N7OR/x174y2QlJ
	 pL1BnYk/CcPL8meCrWYKwHQehwNEc+ZpVCmosuJN9RLTO/xvnzCixZj7sGSKdmWPXr
	 jgcgNww3DZXoi/g/JX3MoOZ90gJXyRdz7cAv7XdhSHvpZ/nd5lEIzkLR5HAlMrfbpw
	 DRMIG2450ZLuA==
Date: Thu, 18 Apr 2024 09:51:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>, Jacob Keller
 <jacob.e.keller@intel.com>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
Message-ID: <20240418095153.47eb18a7@kernel.org>
In-Reply-To: <ZiFKvyvojcIqMQ3R@calendula>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
	<20240418104737.77914-5-donald.hunter@gmail.com>
	<ZiFKvyvojcIqMQ3R@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 18:30:55 +0200 Pablo Neira Ayuso wrote:
> Out of curiosity: Why does the tool need an explicit ack for each
> command? As mentioned above, this consumes a lot netlink bandwidth.

I think that the tool is sort of besides the point, it's just a PoC.
The point is that we're trying to describe netlink protocols in machine
readable fashion. Which in turn makes it possible to write netlink
binding generators in any language, like modern RPC frameworks.
For that to work we need protocol basics to be followed.

That's not to say that we're going to force all netlink families to
change to follow extra new rules. Just those that want to be accessed
via the bindings.
