Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F8714D6E6
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 08:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726648230; cv=none; b=r/ZvR4MO0mA6PzDA9f0khZkvqh/P8PcbI8bBx8TUB36UsUjnP99XMs2l0sTqgaGzfN0bga5PbKWZDdVTKaAQk/ZD2zqibGArlxHogdhXo2yTot1YQMQ8VmZygsKI378LqhS3XF98p6k3AosjgnX/qFTUc86eZTranwQVi18RCn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726648230; c=relaxed/simple;
	bh=/sE0j9LVbiXhRCFHOiE1cbcS7+B1/1divAmkb/KDnzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnaNa+0xsZyqXhrwd7iOkNtcCxrRZuEGkikoYptlObkCly7xgtONLkp7IKhJSz8cETQW1rL0FClUitITLmsEJTVX8d/OsnRN/9/xFRDjf0WZ0GlW0Sgw3cWPzjKROXeuxQQ80hGzJxhIosSMvIdL8ob7sHa1oh/3TU/6mfC7p2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35288 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sqq4r-0019Sh-42; Wed, 18 Sep 2024 10:30:23 +0200
Date: Wed, 18 Sep 2024 10:30:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected
 packets from postrouting
Message-ID: <ZuqPnLVqbQK6T_th@calendula>
References: <20240912185832.11962-1-pablo@netfilter.org>
 <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
X-Spam-Score: -1.8 (-)

Hi Antonio,

On Tue, Sep 17, 2024 at 11:01:31PM +0100, Antonio Ojea wrote:
> On Fri, 13 Sept 2024 at 07:24, Antonio Ojea
> <antonio.ojea.garcia@gmail.com> wrote:
> >
> > On Thu, 12 Sept 2024 at 20:58, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed
> > > conntracks") adjusts NAT again in case that packet loses race to confirm
> > > the conntrack entry.
> > >
> > > The reinject path triggers a route lookup again for the output hook, but
> > > not for the postrouting hook where queue to userspace is also possible.
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > I tried but I am not managing to make a selftest that runs reliable.
> > > I can reproduce it manually and validate that this works.
> > >
> > > ./nft_queue -d 1000 helps by introducing a delay of 1000ms in the
> > > userspace queue processing which helps trigger the race more easily,
> > > socat needs to send several packets in the same UDP flow.
> > >
> > > @Antonio: Could you try this patch meanwhile there is a testcase for
> > > this.
> >
> > Let me test it and report back
> >
> 
> Ok, I finally managed to get this tested, and it does not seem to
> solve the problem, it keeps dnating twice after the packet is enqueued
> by nfqueue

dnatting twice is required to deal with the conntrack confirmation race.

packet 1 enters prerouting, dnat is done using IP A as destination
packet 2 enters prerouting, dnat is done using IP B as destination
packet 1 is enqueued to userspace from postrouting, with unconfirmed conntrack
packet 2 is enqueued to userspace from postrouting, with unconfirmed conntrack
packet 1 is reinjected back to kernelspace from postrouting, conntrack
is confirmed, it uses IP A as destination.
*packet 2* is reinjected back to kernelspace from postrouting, ct lookup
tells us packet lost race, unconfirmed conntrack is dropped, update
mangling to use IP A for consistency (because packet 2 is using IP).

So far we have been assuming races with conntrack confirmation are
unlikely, thus, this is scenario is handled as a corner case which
requires this double mangling.

You still see packets being dropped, right? That should not happen,
I might be then missing something else because my patch triggers also
a re-routing which is required because packet 2 was finally mangled
to use IP A while route still points to IP B.
