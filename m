From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RESEND v3] netfilter: xtables: add quota support to nfacct
Date: Sun, 16 Feb 2014 11:01:43 +0100
Message-ID: <20140216100143.GA4698@localhost>
References: <1391292671-26466-1-git-send-email-mathieu.poirier@linaro.org>
 <20140201225726.GF776@breakpoint.cc>
 <CANLsYkzCb=UqUoG5p4pVr-8YNfJcb25uesUZTMrwT7KuEh2LYg@mail.gmail.com>
 <20140202204012.GJ776@breakpoint.cc>
 <CANLsYkw=vVbc_cCAHHusxHmFi2EXg3jM6baG8jV355SDeHa1Pg@mail.gmail.com>
 <20140212103325.GA15713@localhost>
 <CANLsYky+Zo5GG0uDiwcXBb72nZDMDnKC2Q3hSUNaj9mu=cCp6Q@mail.gmail.com>
 <20140212221631.GA22457@localhost>
 <CANLsYkx+H0HhymqTeZsLkosh_Cpfr1o0D-Y5M4A9zvKE=we2tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	kadlec <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43578 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaBPKBz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 05:01:55 -0500
Content-Disposition: inline
In-Reply-To: <CANLsYkx+H0HhymqTeZsLkosh_Cpfr1o0D-Y5M4A9zvKE=we2tA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 15, 2014 at 07:38:08PM -0700, Mathieu Poirier wrote:
> On 12 February 2014 15:16, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Feb 12, 2014 at 09:58:28AM -0700, Mathieu Poirier wrote:
> > [...]
> >> > I can see that packet and byte counters are not in sync, but I don't
> >> > see why that should be a problem for your quota extension. Your
> >> > accounting is based on packet *OR* byte counters.
> >>
> >> If we have a filter reporting the amount of packets and bytes that
> >> have gone through a chain the least we can do is make them coherent.
> >> Otherwise the numbers simply can't be trusted.  Fixing that problem is
> >> what I've done in the 4th version of my patchset sent on Monday.
> >>
> >> > Moreover, if you inspect the result of the counter update via
> >> > atomic_inc_return / atomic_add_return, you can ensure that packets
> >> > running out of the quota limit will always match.
> >>
> >> Thanks for Florian Westphal's hint on 'cmpxchg' I came up with a match
> >> algorithm that requires no spinlock and doesn't mandate that packet
> >> count be synchronised with bytes.  Before sending it out I'd like us
> >> to reach a consensus on the above - I think the current accounting
> >> method is broken and ought to be fixed.
> >
> > I really think we should skip that spinlock with atomic64. That
> > doesn't make sense to me.
> >
> >> If the current situation is fine with you I'll simply send another
> >> version that works without counts being synchronised - but I really
> >> think we can do better.
> >
> > Given the interferences that you described, I think you can use this
> > approach to ensure that only one event is delivered:
> >
> >         if (old < info->quota && new >= info->quota &&
> >             test_and_set_bit(0, info->quota_reached))
> >                 deliver_event(...);
> >
> > On top of that, there's another problem that needs to be solved now
> > that we have a quota_reached field in the info area. This needs a
> > "database of quota objects" that are identified by a name, otherwise
> > iptables rule updates will trigger a new (unnecessary event) event
> > every time *any* new rule is added.
> >
> > If you want to test what I mean, try this:
> >
> > iptables -I INPUT -m quota --quota 1000 -j LOG --log-prefix "quota: "
> >
> > then keep an eye on /var/log/messages, ping somewhere to generate
> > traffic. You should see log messages for each packet until the quota
> > is reached.  After a couple of ICMP packets, you will see no more logs
> > since the quota has been reached.
> >
> > Now, keep monitoring /var/log/messages and add any rule, eg. iptables
> > -I INPUT. The quota matches again and you'll start seeing more log
> > messages since every rule updates "resets" the internal state of the
> > match. This is a known problem. To solve this, you have to use a
> > specific quota object with a refcnt that is identified by a name. See
> > xt_hashlimit.c for instance. Note that the quota_reached can't be
> > added to the existing nfacct object since it's a valid configuration
> > to have two rules using with different quota values that refer to the
> > same nfacct object (think of a scenario in which you want to throttle
> > to N Kbytes/s after X bytes has been consumed, then throttle to a
> > lower M Kbytes/s after X+Y bytes has been consumed).
> >
> > Thus, the iptables command for this should look like:
> >
> > iptables -I INPUT -p icmp \
> >         -m nfacct --mode packets --quota 100 --quota-name icmp-quota-100
> >
> > In _mt_check you have to look up for "icmp-quota-100" in the list of
> > quota objects to attach it to the rule. If it doesn't exist you create
> > it. In the _destroy path, you have to put the refcnt, if it reaches
> > zero, it will be released. It may sound tricky, but this will work
> > fine in practise.
> >
> > Please, take the time to digest this and let us know if you have any
> > question. Thank you.
> 
> I traced things a little and I understand exactly what is happening -
> I will implement the same mechanism as in hashlimit.  Since accounting
> objects can be delete from nfnetlink_acct I suggest we add a notifier
> to it.  That way objects in the database can be deleted when
> accounting objects are deleted from userspace with nfacct.  What do
> you think?

Just return -EBUSY if you try to delete an object that is in use. Bump
the refcount of nfacct object when the quota object points to it.
