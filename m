From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c
 execution
Date: Tue, 6 Mar 2012 18:23:18 +0100
Message-ID: <20120306172318.GA2282@1984>
References: <4F50E30B.6000704@gmail.com>
 <20120303133002.GA18802@1984>
 <jitp0d$4lv$1@dough.gmane.org>
 <20120304110151.GA22404@1984>
 <jj2sjo$i8a$1@dough.gmane.org>
 <20120306111427.GA448@1984>
 <jj5eov$dr3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kerin Millar <kerframil@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58506 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2CFRX1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:23:27 -0500
Content-Disposition: inline
In-Reply-To: <jj5eov$dr3$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 06, 2012 at 04:42:02PM +0000, Kerin Millar wrote:
> Hi Pablo,
> 
> On 06/03/2012 11:14, Pablo Neira Ayuso wrote:
> 
> <snip>
> 
> >>Gladly. I applied the patch to my 3.3-rc5 tree, which is still
> >>carrying the two patches discussed earlier in the thread. I then
> >>went through my test case under normal circumstances i.e. all
> >>firewall rules in place, nf_nat confirmed present before conntrackd
> >>etc. Again, conntrackd -c did not return to prompt. Here are the
> >>results:-
> >>
> >>http://paste.pocoo.org/raw/561354/
> >>
> >>Well, at least there was no oops this time. I should also add that
> >>the patch was present for both of the tests mentioned in this email.
> >
> >Previous patch that I sent you was not OK, sorry. I have committed the
> >following to my git tree:
> >
> >http://1984.lsi.us.es/git/net/commit/?id=691d47b2dc8fdb8fea5a2b59c46e70363fa66897
> 
> Noted.
> 
> >
> >I've been using the following tools that you can find enclosed to this
> >email, they are much more simple than conntrackd but, they do the same
> >in essence:
> >
> >* conntrack_stress.c
> >* conntrack_events.c
> >
> >gcc -lnetfilter_conntrack conntrack_stress.c -o ct_stress
> >gcc -lnetfilter_conntrack conntrack_events.c -o ct_events
> >
> >Then, to listen to events with reliable event delivery enabled:
> >
> ># ./ct_events&
> >
> >And to create loads of flow entries in ASSURED state:
> >
> ># ./ct_stress 65535 # that's my ct table size in my laptop
> >
> >You'll hit ENOMEM errors at some point, that's fine, but no oops or
> >lockups happen here.
> >
> >I have pushed this tools to the qa/ directory under
> >libnetfilter_conntrack:
> >
> >commit 94e75add9867fb6f0e05e73b23f723f139da829e
> >Author: Pablo Neira Ayuso<pablo@netfilter.org>
> >Date:   Tue Mar 6 12:10:55 2012 +0100
> >
> >     qa: add some stress tools to test conntrack via ctnetlink
> >
> >(BTW, ct_stress may disrupt your network connection since the table
> >gets filled. You can use conntrack -F to get the ct table empty again).
> >
> 
> Sorry if this is a silly question but should conntrackd be running
> while I conduct this stress test? If so, is there any danger of the
> master becoming unstable? I must ask because, if the stability of
> the master is compromised, I will be in big trouble ;)

If you run this in the backup, conntrackd will spam the master with
lots of new flows in the external cache. That shouldn't be a problem
(just a bit of extra load invested in the replication).

But if you run this in the master, my test will fill the ct table
with lots of assured flows. Thus, packets that belong new flows will
be likely dropped in that node.

> >Yes, that line was wrong, I have fixed in the documentation, the
> >correct one must be:
> >
> >iptables -I PREROUTING -t raw -j CT --ctevents assured,destroy
> >
> >Thus, destroy events are delivered to user-space.
> >
> >># conntrack -S | head -n1; conntrackd -s | head -n2
> >>entries                 725826
> >>cache internal:
> >>current active connections:          1409472
> >>
> >>Whatever the case, I'm quite happy to go without this rule as these
> >>systems are coping fine with the load incurred by conntrackd.
> >
> >I want to get things fixed, please, don't give up on using that rule
> >yet :-).
> 
> Sure. I've re-instated the rule as requested. With the addition of
> destroy events, cache usage remains under control.
> 
> >
> >Regarding the hardlockups. I'd be happy if you can re-do the tests,
> >both with conntrackd and the tools that I send you.
> >
> >Make sure you have these three patches, note that the last one has
> >changed.
> >
> >http://1984.lsi.us.es/git/net/commit/?id=7d367e06688dc7a2cc98c2ace04e1296e1d987e2
> >http://1984.lsi.us.es/git/net/commit/?id=a8f341e98a46f579061fabfe6ea50be3d0eb2c60
> >http://1984.lsi.us.es/git/net/commit/?id=691d47b2dc8fdb8fea5a2b59c46e70363fa66897
> >
> 
> Duly applied to a fresh 3.3-rc5 tree.
> 
> Cheers,
> 
> --Kerin
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
