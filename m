Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A782C6BB
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2024 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727002109; cv=none; b=SiGnzQFwjRYKeh5slHDgdlr5kq1J2qRE8QOuFHvFRpCDXbhIpYMyLjyNi8J3MN8Gsgy5o/Vr5IE6hm7lA+qRYAoMQx09KTa/iNqa1dOSXIy+duGPuV2nZlB6M0b1Qrxk0uwcNsBdpcEQFRbqdopGWy3w8Hf7VYHeVFXS/1GyfWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727002109; c=relaxed/simple;
	bh=IaRd/b7DVX3WS9qyF2K47Trh1urF1L7BabGTa1REMf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyHRvlHzy+zseooweIoOSnpcI9+UrZr5wW3Ct8HKYcCy2jmAN8+ahdxvhStfmS1D/McE1ZRbKtopa01kAVM8VmzR1WHg56GsomwZk/EdHtBYSahC8DmM3lZy9qK/Lk1m2zYJnbEdQlUPu2krenBXb/YgPHr2EeOse0ztvDsAS3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XV9k3jxo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XV9k3jxo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QX2PADVIG5ZutjnBXhcwAoi81jWcdwiIc0Y9bt898E4=; b=XV9k3jxodqQ0mMUGoDiZOexF7E
	FtRECcEfqdB6ryoD6GS5CPEG5p4v6KM45asoHFiplWWb4puW0ZjGgbEOwuB6W8BQO9dybVsani+YA
	ZU1RkwltY38tO7rvbF5aNW/L/4xq9FA4LmC3HFwB2zE9NwGZDlRrsLuKBYs1ogjqgtd2mD/vd8nNz
	nNoYkdlNwLpavqB+O3fRcGU0I39pVJwzNIpz7upXkYKd0LjXI0U3D+BmsgzcnxqBpqeKVEXiBAZSv
	W+6aODCi0IOV6qMrv4uqzqx12odba8+2FlUBRqiutNZIKvhztToTO24TqceXjeZi7iSYjl3cPk8jj
	S9/Lz8lw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ssK8X-000000004Of-0Bf4;
	Sun, 22 Sep 2024 12:48:17 +0200
Date: Sun, 22 Sep 2024 12:48:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v4 13/16] netfilter: nf_tables: Handle
 NETDEV_CHANGENAME events
Message-ID: <Zu_18Az4-Boh9aCv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240920202347.28616-1-phil@nwl.cc>
 <20240920202347.28616-14-phil@nwl.cc>
 <20240922073224.GA32587@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922073224.GA32587@breakpoint.cc>

On Sun, Sep 22, 2024 at 09:32:24AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > For the sake of simplicity, treat them like consecutive NETDEV_REGISTER
> > and NETDEV_UNREGISTER events. If the new name matches a hook spec and
> > registration fails, escalate the error and keep things as they are.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v3:
> > - Register first and handle errors to avoid having unregistered the
> >   device but registration fails.
> > ---
> >  net/netfilter/nf_tables_api.c    | 5 +++++
> >  net/netfilter/nft_chain_filter.c | 5 +++++
> >  2 files changed, 10 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 2684990dd3dc..4d40c1905735 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -9371,6 +9371,11 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
> >  	struct nft_table *table;
> >  	struct net *net;
> >  
> > +	if (event == NETDEV_CHANGENAME) {
> > +		if (nf_tables_flowtable_event(this, NETDEV_REGISTER, ptr))
> > +			return NOTIFY_BAD;
> > +		event = NETDEV_UNREGISTER;
> > +	}
> 
> Consider flowtable that should claim devices "pv*".
> You get CHANGENAME, device name is, say, pv5.
> 
> Device name is registered in nf_tables_flowtable_event().
> Then, event is set to UNREGISTER.
> 
> AFAICS this may unreg the device again immediately, as unreg part
> only compares device pointer and we can't be sure the device was
> part of any flowtable when CHANGENAME was triggered.
> 
> So I think nf_tables_flowtable_event() must handle CHANGENAME
> directly, first check if any flowtable holds the device at this time,
> then check if we need to register it with a new name, and do unreg
> only if it was previously part of any flowtable.
> 
> Same logic needed for netdev chains.
> 
> Does that make sense?

Oh, you're right: Registering the device again (with new name) then
searching *all* flowtables for the device and unregistering it will
undo the previous registration, too! This obviously needs proper
testing, too.

Thanks, Phil
