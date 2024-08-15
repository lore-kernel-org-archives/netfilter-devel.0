Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE8F1714C4;
	Thu, 15 Aug 2024 10:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723716214; cv=none; b=SpqZQaubfW/L7yPS97PXkgJzROg/l9NFQUZxUz7IpbJMyGSE1KMAWtLV2boyVOwTz/WVOd/I71aOSl/GBasn29E1Kx6jENDB88GbRGV1ShozY+6h+Y7NFjhip5X+RBpVRRMM2bkIRB3r6TCu7MNg66xukZriZ3B5Q0gmPke9CMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723716214; c=relaxed/simple;
	bh=hGrc0+7koAoE/zRVnogeniLcqspdZ2o824cLSZ7LmRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCmlOS7Qyo42JuFgSKgVU0gw3VznM0fTEAqNLJqSRx9a6xSW4o2hpzPvBGbwKhbxuB/4cJNmoK4VExF3tTxDLgb3a+HuTtymuqKoGRuUKqYVdL4sTovd6nK3R8lZXnhgY7x4Ah3opLRC/alaJ7hiuJsNPXCZeOZn3NXkA7RifA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=45690 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seXKJ-00Gvy0-1j; Thu, 15 Aug 2024 12:03:29 +0200
Date: Thu, 15 Aug 2024 12:03:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: icejl <icejl0001@gmail.com>, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: fix uninitialized local variable
Message-ID: <Zr3SbSEb6oD87FVo@calendula>
References: <20240815082733.272087-1-icejl0001@gmail.com>
 <Zr3EhKBKllxigfcD@gmail.com>
 <Zr3LQ4hGx-sN5T8Q@calendula>
 <Zr3Qh5FW7PsynJ4O@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zr3Qh5FW7PsynJ4O@gmail.com>
X-Spam-Score: -1.9 (-)

On Thu, Aug 15, 2024 at 02:55:19AM -0700, Breno Leitao wrote:
> Hello Pablo,
> 
> On Thu, Aug 15, 2024 at 11:32:51AM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Aug 15, 2024 at 02:04:04AM -0700, Breno Leitao wrote:
> > > On Thu, Aug 15, 2024 at 04:27:33PM +0800, icejl wrote:
> > > > In the nfnetlink_rcv_batch function, an uninitialized local variable
> > > > extack is used, which results in using random stack data as a pointer.
> > > > This pointer is then used to access the data it points to and return
> > > > it as the request status, leading to an information leak. If the stack
> > > > data happens to be an invalid pointer, it can cause a pointer access
> > > > exception, triggering a kernel crash.
> > > > 
> > > > Signed-off-by: icejl <icejl0001@gmail.com>
> > > > ---
> > > >  net/netfilter/nfnetlink.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > > > index 4abf660c7baf..b29b281f4b2c 100644
> > > > --- a/net/netfilter/nfnetlink.c
> > > > +++ b/net/netfilter/nfnetlink.c
> > > > @@ -427,6 +427,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
> > > >  
> > > >  	nfnl_unlock(subsys_id);
> > > >  
> > > > +	memset(&extack, 0, sizeof(extack));
> > > >  	if (nlh->nlmsg_flags & NLM_F_ACK)
> > > >  		nfnl_err_add(&err_list, nlh, 0, &extack);
> > > 
> > > There is a memset later in that function , inside the 
> > > `while (skb->len >= nlmsg_total_size(0))` loop. Should that one be
> > > removed?
> > 
> > no, the batch contains a series of netlink message, each of them needs
> > a fresh extack area which is zeroed.
> 
> Sorry, this is a bit unclear to me. This is the code I see in
> netnext/main:
> 
> 
> 	memset(&extack, 0, sizeof(extack));   // YOUR CHANGE
> 
>         if (nlh->nlmsg_flags & NLM_F_ACK)
>                 nfnl_err_add(&err_list, nlh, 0, &extack);
> 
>         while (skb->len >= nlmsg_total_size(0)) {
>                 int msglen, type;
> 
>                 if (fatal_signal_pending(current)) {
>                         nfnl_err_reset(&err_list);
>                         err = -EINTR;
>                         status = NFNL_BATCH_FAILURE;
>                         goto done;
>                 }
> 
> ->              memset(&extack, 0, sizeof(extack));
> 
> 
> nfnl_err_add() does not change extack. Tht said, the second memset (last
> line in the snippet above), seems useless, doesn't it?

Processing continues on error, several errors can be reported to
userspace.

        message A1 fails (set extack)
        ...
        message An fails too (but does not set extack)

if extack is not reset, then message B gets a misleading error report
that was set by message A.

Some error paths do not set extack, eg. EINVAL.
