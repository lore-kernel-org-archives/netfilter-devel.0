Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2BA28E7
	for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 18:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716230839; cv=none; b=PkuJodSjM27aIqNeQgkETImFMINiUi+J9jE7U+7z/IEQ+1Bh41iq8rk53ksrD5aCSTY9CogX3CK8v7YJDCAEgdSY6yuea09bSpBpWB7z450F9E5AGJslNQOHHAfU5OkxXX+2JHZN38r8YZGTGiMG1jBeBcJOHU8YWYsURO44+AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716230839; c=relaxed/simple;
	bh=lH+338ZBle5VjWeY5yZm3CTW8jIgoozwvDCt/vyhzJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bi+GRSkvGi3b7qWoO7SwO3+dKs7deKeMchKju55Rdim/HYwUPoprnFj3Q+YVCo/RdYhR9Y41qu2oAMtGvfFA4zC+fjqn6rJe/gGonc4hOAatTzRZUHoORlDo+dPAXBHGPPl4NeZA7zd6Xw5vTMH4kWnqolI+AlDzTeg8vh/aefk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 20 May 2024 20:47:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <ZkuasOTMseQKGUr_@calendula>
References: <20240513220033.2874981-1-aojea@google.com>
 <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZkuXgB_Qo5336q4-@calendula>

On Mon, May 20, 2024 at 08:33:39PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 20, 2024 at 05:44:35PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, May 20, 2024 at 01:27:22PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, May 13, 2024 at 10:00:31PM +0000, Antonio Ojea wrote:
> > > > Fixes the bug described in
> > > > https://bugzilla.netfilter.org/show_bug.cgi?id=1742
> > > > causing netfilter to drop SCTP packets when using
> > > > nfqueue and GSO due to incorrect checksum.
> > > > 
> > > > Patch 1 adds a new helper to process the sctp checksum
> > > > correctly.
> > > > 
> > > > Patch 2 adds a selftest regression test.
> > > 
> > > I am inclined to integrated this into nf.git, I will pick a Fixes: tag
> > > sufficiently old so -stable picks up.
> > 
> > I have to collapse this chunk, otherwise I hit one issue with missing
> > exported symbol. No need to resend, I will amend here. Just for the
> > record.
> 
> Hm. SCTP GSO support is different too, because it keeps a list of segments.
> 
> static int
> nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
> {
> [...]
>         if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb))
>                 return __nfqnl_enqueue_packet(net, queue, entry);
> 
> I think this needs to be:
> 
>         if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb) || !skb_is_gso_sctp(skb))

This is not correct either:

        if (queue->flags & NFQA_CFG_F_GSO) is true, this also needs !skb_is_gso_sctp(skb)

I can see the current selftest disables the NFQA_CFG_F_GSO flag (-G
option in nf_queue test program), I suspect that's why this is working.

>                 return __nfqnl_enqueue_packet(net, queue, entry);
> 
> so SCTP GSO packets enters this path below:
> 
>         nf_bridge_adjust_skb_data(skb);
>         segs = skb_gso_segment(skb, 0);
> 
> to deliver separated segments to userspace.
> 
> Otherwise, I don't see yet how userspace can deal with several SCTP
> segments, from nf_reinject() there is a list of segments no more.
