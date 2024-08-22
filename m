Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B734B364A4;
	Thu, 22 Aug 2024 10:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724322099; cv=none; b=mQkNMLqbX4jVB4WI/gnKoRwIZbMAZ8je4fh4G83H2RzJHHqOt3wC7oM1+NfNvHb8nyvSxn91Gcbndo6PFkpUNcOIYkdJe6IUncGqOakODpkFqDQOzRG5E/QCmtG1be1/r68wztw80pf8XIiZyJAdj78JBofv5iaovibFyJJXt6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724322099; c=relaxed/simple;
	bh=TbJJN52kwu74q4aq4vCyDv2+fkg0W/Rs//AmqVZ0Nfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3We8G/wQ1aIJLRvX4FL3az44gsTjiLqfqtzgEBg64ZuK1VdH2+a097b9gGwRHNgYKqRzEiHQePEscirmXw5NwvfWpDpBml57I2cdQT6ZyDj/b7f1euzh30JNBIvhHrtuhAgNd3XoMTx/PNW6CRLUGmz1u2D/l2oIWlFoEsyfL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53098 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sh4wc-009W4h-HM; Thu, 22 Aug 2024 12:21:32 +0200
Date: Thu, 22 Aug 2024 12:21:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de
Subject: Re: [PATCH net 3/3] netfilter: flowtable: validate vlan header
Message-ID: <ZscRKbK11c75II8E@calendula>
References: <20240822001707.2116-1-pablo@netfilter.org>
 <20240822001707.2116-4-pablo@netfilter.org>
 <CANn89iL6DA3Gha1h8uje5U5rObnKCOrF360Q-U1bGaDCmm3wWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iL6DA3Gha1h8uje5U5rObnKCOrF360Q-U1bGaDCmm3wWQ@mail.gmail.com>
X-Spam-Score: -1.9 (-)

On Thu, Aug 22, 2024 at 08:39:56AM +0200, Eric Dumazet wrote:
> On Thu, Aug 22, 2024 at 2:17 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Ensure there is sufficient room to access the protocol field of the
> > VLAN header, validate it once before the flowtable lookup.
> >
> > =====================================================
> > BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
> >  nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
> >  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
> >  nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
> >  nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
> >  nf_ingress net/core/dev.c:5440 [inline]
> >
> > Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
> > Reported-by: syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_flow_table_inet.c | 3 +++
> >  net/netfilter/nf_flow_table_ip.c   | 3 +++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
> > index 88787b45e30d..dd9a392052ee 100644
> > --- a/net/netfilter/nf_flow_table_inet.c
> > +++ b/net/netfilter/nf_flow_table_inet.c
> > @@ -17,6 +17,9 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
> >
> >         switch (skb->protocol) {
> >         case htons(ETH_P_8021Q):
> > +               if (!pskb_may_pull(skb, VLAN_HLEN))
> > +                       return NF_ACCEPT;
> > +
> >                 veth = (struct vlan_ethhdr *)skb_mac_header(skb);
> 
> Is skb_mac_header(skb) always pointing at skb->data - 14 at this stage ?
> 
> Otherwise, using
> 
>   if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth))  would be safer.

That looks consistent. Done and I just sent a new PR. Thanks.
