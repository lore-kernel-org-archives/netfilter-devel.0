From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to
 new namespaces
Date: Wed, 28 Oct 2015 13:39:36 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1510281329001.595@nerf40.vanv.qr>
References: <1445597006-11264-1-git-send-email-fw@strlen.de> <20151026225522.GA15583@salvia> <20151026230938.GA9420@breakpoint.cc> <20151027163552.GC9420@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:35687 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbJ1Mji (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2015 08:39:38 -0400
In-Reply-To: <20151027163552.GC9420@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2015-10-27 17:35, Florian Westphal wrote:
>> 
>> Good point, I'll look at this tomorrow.  It should not be too hard to
>> add this.
>
>Ahem.  There are strings attached... :-/
>
>So conntrack -L or conntrack -E do not enable connection tracking
>if its not enabled (on current kernels).
>
>So one has to load ipv4/ipv6 etc tracker explicitly.
>
>Problem *after* patches is that this doesn't suffice.
>
>So old behaviour:
>conntrack -E
>
>(nothing happens)
>(modprobe nf_conntrack_ipv4)
>(conntrack -E starts to display events)
>
>new behaviour:
>(modprobe nf_conntrack_ipv4)
>(conntrack -E doesn't display events since conntrack module doesn't
> see packets due to lack of nf hooks).
>
>My first attempt to fix this was to hook into nfnetlink bind,
>but that doesn't really work in a backwards-compatible fashion since
>it only makes 'modprobe nf_conntrack_ipv4; conntrack -E' work, but
>not nf_conntrack_ipv4 module load *after* a event listener is already
>running.
>
>Other alternative is to request all the protocol trackers during
>ctnetlink bind request but that sucks.
>
>Any suggestion?  I don't really see a way out of this.

I am thinking of something like

  echo +PROTO >/proc/net/.../nf_conntrack/bind
  echo -PROTO >/proc/net/.../nf_conntrack/bind

That way, userspace can request enablement per netns. And nf_conntrack can
do
1. call request_module to load it if not already in the system,
2. pin the particular nf_conntrack_PROTO module, with refcounting
   (try_module_get() and module_put(), one ref per netns).

