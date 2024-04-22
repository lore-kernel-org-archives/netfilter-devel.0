Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D6F181BB1;
	Mon, 22 Apr 2024 22:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713826570; cv=none; b=uvohRsvLadypVP41RXAKpuLBmvqTWsc2McO9SjlnABPwrLiVwPoOwFoZNvxTsyW9wfTs/0QAoxRa2XYtDb3mzfohkmIqFCKIdgZJykMZMC14ZmFxtk//7+YIS6foFpDDQ+t4kfEM0EQfIf4RwyJJprppegCgffBA1oMIVp9V+4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713826570; c=relaxed/simple;
	bh=hoj6xDWLRPDLdCPyAfiUdw/kz444tdSJ8efLP9X5pzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mkqq6ZU33sXWuIxFhXmikrJSqIWe4v4jWqR0wTO58oiXphiaNxBxxoTRlkYKte8Aofstj+1KZKQOwIFFtk3mEoo1xw8T1dj50eNsZZDclAiV4UO5p1jttQaqAUvezvcoHOae0LA0q33+dIS1hO0lZhisi1BYdTNGJPnhDzmQpYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 23 Apr 2024 00:56:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
Message-ID: <ZibrBFnV2kba2UUi@calendula>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
 <20240418104737.77914-5-donald.hunter@gmail.com>
 <ZiFKvyvojcIqMQ3R@calendula>
 <20240418095153.47eb18a7@kernel.org>
 <20240422133328.3d626130@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240422133328.3d626130@kernel.org>

On Mon, Apr 22, 2024 at 01:33:28PM -0700, Jakub Kicinski wrote:
> On Thu, 18 Apr 2024 09:51:53 -0700 Jakub Kicinski wrote:
> > On Thu, 18 Apr 2024 18:30:55 +0200 Pablo Neira Ayuso wrote:
> > > Out of curiosity: Why does the tool need an explicit ack for each
> > > command? As mentioned above, this consumes a lot netlink bandwidth.  
> > 
> > I think that the tool is sort of besides the point, it's just a PoC.
> > The point is that we're trying to describe netlink protocols in machine
> > readable fashion. Which in turn makes it possible to write netlink
> > binding generators in any language, like modern RPC frameworks.
> > For that to work we need protocol basics to be followed.
> > 
> > That's not to say that we're going to force all netlink families to
> > change to follow extra new rules. Just those that want to be accessed
> > via the bindings.
> 
> Pablo, any thoughts? Convinced? Given this touches YNL in significant
> ways I'd prefer to merge it to net-next.

No objections, thanks for asking.
