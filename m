From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH 6/6 RFC] netfilter: add audit netns ID
Date: Wed, 24 May 2017 14:04:03 -0400
Message-ID: <20170524180403.GK6203@madcap2.tricolour.ca>
References: <cover.1495124188.git.rgb@redhat.com>
 <c19c5f9a2b5bf8d43ced7a0a10d2da80934f242a.1495124188.git.rgb@redhat.com>
 <20170524173106.GA7439@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754408AbdEXSEQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 14:04:16 -0400
Content-Disposition: inline
In-Reply-To: <20170524173106.GA7439@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-05-24 19:31, Pablo Neira Ayuso wrote:
> Cc'ing Eric Biederman.
> 
> On Thu, May 18, 2017 at 01:21:52PM -0400, Richard Guy Briggs wrote:
> > diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> > index 59b63a8..0f77b2a 100644
> > --- a/net/bridge/netfilter/ebtables.c
> > +++ b/net/bridge/netfilter/ebtables.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/smp.h>
> >  #include <linux/cpumask.h>
> >  #include <linux/audit.h>
> > +#define PROC_DYNAMIC_FIRST 0xF0000000U
> >  #include <net/sock.h>
> >  /* needed for logical [in,out]-dev filtering */
> >  #include "../br_private.h"
> > @@ -1075,7 +1076,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
> >  			ab = audit_log_start(current->audit_context, GFP_KERNEL,
> >  					     AUDIT_NETFILTER_CFG);
> >  			if (ab) {
> > -				audit_log_format(ab, "op=replace family=%u table=%s entries=%u",
> > +				audit_log_format(ab, "op=replace net=%u family=%u table=%s entries=%u",
> > +						 net->ns.inum - PROC_DYNAMIC_FIRST,
> 
> IIRC, there was a discussion on exposing netns i-node number to
> userspace time ago on netdev and Eric Biederman was not happy about
> this?

He was not happy about it being exposed in the /proc filesystem.  We've
been talking since then and while we've not come to a definitive
conclusion there is a communication channel open.

This is more of an RFC patch than the rest of this set and I didn't
seriously expect this one to be accepted, I did want to present the idea
to see if there were concerns or better ideas generated how to
differentiate this record from a seemingly identical one.  The only
other ID would be the network namespace' struct pointer.

At this stage, one thing that is missing is a device number to qualify
this namespace ID.

Once I started printing the namespace proc inode number (minus the
starting offset) in decimal, it was very clear what was happenning and
seemed worth sharing that debugging tool patch.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
