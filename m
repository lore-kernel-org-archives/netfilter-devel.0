Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961DF74402
	for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 10:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716288530; cv=none; b=NX8k5SwI77k7mO3+8eN9FClvlIO7s61QLZiPW3vk5MrQIHYxiIJT2eGp9uBIoLtvBnv3tDd80aM6oYYJRrjnBC+jkI1EHF8jR4bUqMPwerQNbfKIW1t+1skV6Hn5as7/J7E2fWa4gPArt4Yi+Kx/PPDLq6En0z/6LP2IsmqV/aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716288530; c=relaxed/simple;
	bh=pJxATN/GxDk91IyqYTaB+Noxzw9t3jo1t4u7Bqv+0gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PqSmPi16U6tPZy1bceUXJLca19Ny51JIfHU1J50s8prv/IywrxP2Ug07Fn4GQnZM7igz+dum8NmAe9/37m656OJ9Eiq7+EWVRIkXqMtawSPRzcdo+UDiiOiKSxCNv3Y/ncPxN3HDBIvAPZMfvnHjLNqJWM/NT0DHNuc/5T+zqBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 21 May 2024 12:48:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <Zkx8BCuu6dyTDjcX@calendula>
References: <20240513220033.2874981-1-aojea@google.com>
 <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
 <ZkuasOTMseQKGUr_@calendula>
 <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>

On Mon, May 20, 2024 at 07:59:06PM +0100, Antonio Ojea wrote:
> On Mon, May 20, 2024 at 7:47 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Mon, May 20, 2024 at 08:33:39PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, May 20, 2024 at 05:44:35PM +0200, Pablo Neira Ayuso wrote:
> > > > On Mon, May 20, 2024 at 01:27:22PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Mon, May 13, 2024 at 10:00:31PM +0000, Antonio Ojea wrote:
> > > > > > Fixes the bug described in
> > > > > > https://bugzilla.netfilter.org/show_bug.cgi?id=1742
> > > > > > causing netfilter to drop SCTP packets when using
> > > > > > nfqueue and GSO due to incorrect checksum.
> > > > > >
> > > > > > Patch 1 adds a new helper to process the sctp checksum
> > > > > > correctly.
> > > > > >
> > > > > > Patch 2 adds a selftest regression test.
> > > > >
> > > > > I am inclined to integrated this into nf.git, I will pick a Fixes: tag
> > > > > sufficiently old so -stable picks up.
> > > >
> > > > I have to collapse this chunk, otherwise I hit one issue with missing
> > > > exported symbol. No need to resend, I will amend here. Just for the
> > > > record.
> > >
> > > Hm. SCTP GSO support is different too, because it keeps a list of segments.
> > >
> > > static int
> > > nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
> > > {
> > > [...]
> > >         if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb))
> > >                 return __nfqnl_enqueue_packet(net, queue, entry);
> > >
> > > I think this needs to be:
> > >
> > >         if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb) || !skb_is_gso_sctp(skb))
> >
> > This is not correct either:
> >
> >         if (queue->flags & NFQA_CFG_F_GSO) is true, this also needs !skb_is_gso_sctp(skb)
> >
> > I can see the current selftest disables the NFQA_CFG_F_GSO flag (-G
> > option in nf_queue test program), I suspect that's why this is working.
> >
> 
> I see, so I fixed the bug in one direction and regressed in the other
> one, let me retest both things locallly

The check to force GSO SCTP to be segmented before being sent to
userspace, my proposal:

              if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
                        return __nfqnl_enqueue_packet(net, queue, entry);

              nf_bridge_adjust_skb_data(skb);
              segs = skb_gso_segment(skb, 0);
              ...

and extend selftest to cover for the case where -G is not enabled.

> > >                 return __nfqnl_enqueue_packet(net, queue, entry);
> > >
> > > so SCTP GSO packets enters this path below:
> > >
> > >         nf_bridge_adjust_skb_data(skb);
> > >         segs = skb_gso_segment(skb, 0);
> > >
> > > to deliver separated segments to userspace.
> > >
> > > Otherwise, I don't see yet how userspace can deal with several SCTP
> > > segments, from nf_reinject() there is a list of segments no more.
