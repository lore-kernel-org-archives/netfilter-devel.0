Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D826027453;
	Fri, 13 Feb 2026 02:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770950089; cv=none; b=t7oHm4Ogzg1FtEwNBJzDZDRhZmNjrnv/ZRPUn5uoz13qfn5Nb2PlsciCQ7Yhn5bUvxF1+k4d2YFAzGeF5kwxbGyY1QYlWeY5nUMn6v2wi845fAIOfjMVevkfT7QJtY/h9HL5xAf9oltThLVr4RJAncktKTEnD7eMwvYuBuVEU10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770950089; c=relaxed/simple;
	bh=oJ2VLZkLPB+wC1zHMEWxk0UwVj+u7Y1pSmHc/1naJr4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GJwOs/rJnvmUkOs8nPdxkMNfuCDC0/RRGfvheTSp3HbektKhleOMHN1Pbx2YzuIhUxu+9benj0KXHtHfWLq7aVtpmiUTwC1trNoSpBYRfTrCN6za0cX5TfilB8kmxd09Xqj2jpMDHqFfASil1WSfqf6A15moZoGd/4hpmsiQUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyBGwzWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyBGwzWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6A7C4CEF7;
	Fri, 13 Feb 2026 02:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770950089;
	bh=oJ2VLZkLPB+wC1zHMEWxk0UwVj+u7Y1pSmHc/1naJr4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QyBGwzWEgYRisP2hqQYWhJH3o7NIDqXLF+HSiqCGlhRl9xRvtDJo9lGTnr7Zzu/B1
	 0xVdh+ErgxmZHzjBY1PIl63SCv5R3mMQHhwpGLAscKnbG5oH2uBW+YX34iZxLqbAN7
	 2xXs0ZU+tE3oSgEvj+cnAlYyWSRhngIxl3jrmr8vul6je0NwG6OFJGXGELJshDDxox
	 a28GfTYGzYNRL4MDMlYkGRb5AMXRJIn21SfaTd2NibOxBAOOWEBTER+Kjiwxnc8OQj
	 HVQp+U1uVXk8VRVr8wi22226bZVh1t9hfrcFyyi+8BsDZb0lrYW00B2Z+ujb1rglyR
	 SbT7DPY3h+uHQ==
Date: Thu, 12 Feb 2026 18:34:47 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Shigeru Yoshida <syoshida@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net] net: flow_offload: protect driver_block_list in
 flow_block_cb_setup_simple()
Message-ID: <20260212183447.2d577f5b@kernel.org>
In-Reply-To: <aYxw2CpxOKLh1wOz@strlen.de>
References: <20260208110054.2525262-1-syoshida@redhat.com>
	<aYxw2CpxOKLh1wOz@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Feb 2026 13:06:48 +0100 Florian Westphal wrote:
> Shigeru Yoshida <syoshida@redhat.com> wrote:
> > syzbot reported a list_del corruption in flow_block_cb_setup_simple(). [0]
> > 
> > flow_block_cb_setup_simple() accesses the driver_block_list (e.g.,
> > netdevsim's nsim_block_cb_list) without any synchronization. The
> > nftables offload path calls into this function via ndo_setup_tc while
> > holding the per-netns commit_mutex, but this mutex does not prevent
> > concurrent access from tasks in different network namespaces that
> > share the same driver_block_list, leading to list corruption:
> > 
> > - Task A (FLOW_BLOCK_BIND) calls list_add_tail() to insert a new
> >   flow_block_cb into driver_block_list.
> > 
> > - Task B (FLOW_BLOCK_UNBIND) concurrently calls list_del() on another
> >   flow_block_cb from the same list.  
> 
> Looking at the *upper layer*, I don't think it expected drivers to use
> a single global list for this bit something that is scoped to the
> net_device.

Maybe subjective but the fix seems a little off to me.
Isn't flow_block_cb_setup_simple() just a "simple" implementation 
for reuse in drivers locking in there doesn't really guarantee much?

If we think netdevsim is doing something odd, let's make it work
like real drivers.

TBH I thought block setup was always under rtnl_lock.
