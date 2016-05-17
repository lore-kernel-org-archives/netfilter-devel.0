From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: nf_conntrack: Use net_mutex for helper
 unregistration.
Date: Tue, 17 May 2016 12:16:01 +0200
Message-ID: <20160517101601.GA2244@salvia>
References: <1462488637-46877-1-git-send-email-joe@ovn.org>
 <20160506110325.GA2420@salvia>
 <CAPWQB7Eqoxk6-B5iEhkk9yF-DDduavtm=K8OE-3Of7JF6-Opvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>
To: Joe Stringer <joe@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52192 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbcEQKQI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 06:16:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 36C2F1B5343
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:16:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2607E11CF37
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:16:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1345E11C4F0
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:16:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAPWQB7Eqoxk6-B5iEhkk9yF-DDduavtm=K8OE-3Of7JF6-Opvg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Eric Biederman.

On Mon, May 16, 2016 at 09:38:53PM -0700, Joe Stringer wrote:
> On 6 May 2016 at 04:03, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Joe,
> >
> > On Thu, May 05, 2016 at 03:50:37PM -0700, Joe Stringer wrote:
> >> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> >> index 3b40ec575cd5..6860b19be406 100644
> >> --- a/net/netfilter/nf_conntrack_helper.c
> >> +++ b/net/netfilter/nf_conntrack_helper.c
> >> @@ -449,10 +449,10 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
> >>        */
> >>       synchronize_rcu();
> >>
> >> -     rtnl_lock();
> >> +     mutex_lock(&net_mutex);
> >>       for_each_net(net)
> >>               __nf_conntrack_helper_unregister(me, net);
> >> -     rtnl_unlock();
> >> +     mutex_unlock(&net_mutex);
> >
> > This simple solution works because we have no .exit callbacks in any
> > of our helpers. Otherwise, the helper code may be already gone by when
> > the worker has a chance to run to release the netns.
> >
> > If so, probably I can append this as comment to this function so we
> > don't forget. If we ever have .exit callbacks (I don't expect so), we
> > would need to wait for worker completion.
> 
> Hi Pablo,
> 
> Did you want me to re-spin this patch or look into another approach?

Last time I looked into this, my impression was that we should
register each conntrack helper via register_pernet_subsys(). Then,
from the exit path I was missing something like netns_barrier() [ note
that I didn't seem to find anything similar] to ensure netns workqueue
completion before we leave from the module exit path so that the
->exit() netns callback code doesn't go away.

That would also avoid the rtnl_lock() dependency.
