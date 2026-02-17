Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A601330B52B;
	Tue, 17 Feb 2026 22:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771365947; cv=none; b=VyZ5z/QeIZQZFDZfzNVhSOkiI4Hin71+LxAdp+waLCfuSCQPS7FRQHb8FI8Qv+wMo2SiKhM1qqmrW3w5sY85Wowr5+rHsOHOqutjfxqdwqIZ1ifdtmpzSSnMC64N8IlL0uIsdrHsaC/aOuQJyrITiHdljlD6I6PyLX/ENChyV2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771365947; c=relaxed/simple;
	bh=N352cReU/v+Zqk74ksFe2bI5YmBJMQ10oDYOnJpnozQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tdhez4jQPzIKysNmZJzfbOy6pJeddFhifMjtwVIdm7E+O9lZOAOId9GlF650oiZE/ic9iFrecZGyaOVxUdpcNC9yny4/u77tcAwts/O+P3bmjMu7iWIMm23JTmROmSVCzJJU3dqCwbM53VKCqJN2Po/eFyebiblB80ybbbghtcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cz6l3Fev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cz6l3Fev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84B9C4CEF7;
	Tue, 17 Feb 2026 22:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771365947;
	bh=N352cReU/v+Zqk74ksFe2bI5YmBJMQ10oDYOnJpnozQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cz6l3FevT8m57fUF5vkT2hXikEzplXJDCyA/dICZ7WiMnC4+IWrcAHGS+0xPo3z5B
	 t0Qbgb8SIAh5aDkFekwdWqhq1FpQGmp4gub8Gr5o2BXuBCqX3Hg8GWBbYm2rdGeMOY
	 fhEgy5ipWGrQywWWfdeSwQJVSpRLuGGGSy+jq8Sevh+bVmK1ZeLcO6X5ftTSSjP0cg
	 bWKZI4K6RQfmf0lGOmpuD1j2T4+v9N1hDHAZpyjacBCbCR1F/KRn+uVrzBd12eDhXJ
	 Wa2IyYvF+2xfFIfu3f8gIpvSjULetr2Kjd8RB9dQhUKxhg8xgwXYFlE4c0RgDe5lHp
	 ykUJJLtcxhYzg==
Date: Tue, 17 Feb 2026 14:05:45 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Shigeru Yoshida <syoshida@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Phil Sutter <phil@nwl.cc>,
 syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net] net: flow_offload: protect driver_block_list in
 flow_block_cb_setup_simple()
Message-ID: <20260217140545.325067c0@kernel.org>
In-Reply-To: <aZRUFQGKzEdcjNHG@chamomile>
References: <20260208110054.2525262-1-syoshida@redhat.com>
	<aYxw2CpxOKLh1wOz@strlen.de>
	<20260212183447.2d577f5b@kernel.org>
	<aY8LcgPsoYYGEH5s@strlen.de>
	<20260213081749.3b3ede9c@kernel.org>
	<aZHE4r18hkxdITD-@strlen.de>
	<aZRUFQGKzEdcjNHG@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Feb 2026 12:42:13 +0100 Pablo Neira Ayuso wrote:
> > static int
> > mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
> > {
> >         struct mtk_mac *mac = netdev_priv(dev);
> >         struct mtk_eth *eth = mac->hw;
> >         static LIST_HEAD(block_cb_list);
> > 	~~~~~~
> > I have a question.
> > 
> > [..]
> >         f->driver_block_list = &block_cb_list;
> > 
> > Now I have many questions!
> > 
> > How is this supposed to work?  
> 
> Last time I met people, I asked how is hw offload actually working
> with netns (6 years ago?), someone told me: "maybe there is a driver
> that supports it...". I have never seen one, but I am very much
> outdates on how this has evolved TBH, I might be wrong.
> 
> I don't think any driver really supports netns + hardware offload, so
> I suggest to restrict it, see attached patch.
> 
> It would be better to add a helper function such as int net_setup_tc()
> for the myriad of ->ndo_setup_tc() calls in the code, then move this
> check in it to consolidate, but I think you want something you can
> pass to -stable at this stage?

I don't think we need this restriction for TC side, it should be under
rtnl_lock, IIUC. I have a... strong suspicion(?) that TC works, some
drivers explicitly support devlink reload into a specified netns. 
I always assumed this is for the cases where something like OvS offload
is supposed to be handled outside init_net to avoid netdev explosion. 
I could be wrong, tho, could be an RDMA thing.
