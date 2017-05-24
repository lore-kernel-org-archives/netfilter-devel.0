From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 6/6 RFC] netfilter: add audit netns ID
Date: Wed, 24 May 2017 14:44:06 -0500
Message-ID: <87tw4aavll.fsf@xmission.com>
References: <cover.1495124188.git.rgb@redhat.com>
        <c19c5f9a2b5bf8d43ced7a0a10d2da80934f242a.1495124188.git.rgb@redhat.com>
        <20170524173106.GA7439@salvia>
        <20170524180403.GK6203@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:44221 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966669AbdEXTut (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 15:50:49 -0400
In-Reply-To: <20170524180403.GK6203@madcap2.tricolour.ca> (Richard Guy
        Briggs's message of "Wed, 24 May 2017 14:04:03 -0400")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Richard Guy Briggs <rgb@redhat.com> writes:

> On 2017-05-24 19:31, Pablo Neira Ayuso wrote:
>> Cc'ing Eric Biederman.
>> 
>> On Thu, May 18, 2017 at 01:21:52PM -0400, Richard Guy Briggs wrote:
>> > diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
>> > index 59b63a8..0f77b2a 100644
>> > --- a/net/bridge/netfilter/ebtables.c
>> > +++ b/net/bridge/netfilter/ebtables.c
>> > @@ -27,6 +27,7 @@
>> >  #include <linux/smp.h>
>> >  #include <linux/cpumask.h>
>> >  #include <linux/audit.h>
>> > +#define PROC_DYNAMIC_FIRST 0xF0000000U
>> >  #include <net/sock.h>
>> >  /* needed for logical [in,out]-dev filtering */
>> >  #include "../br_private.h"
>> > @@ -1075,7 +1076,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>> >  			ab = audit_log_start(current->audit_context, GFP_KERNEL,
>> >  					     AUDIT_NETFILTER_CFG);
>> >  			if (ab) {
>> > -				audit_log_format(ab, "op=replace family=%u table=%s entries=%u",
>> > +				audit_log_format(ab, "op=replace net=%u family=%u table=%s entries=%u",
>> > +						 net->ns.inum - PROC_DYNAMIC_FIRST,
>> 
>> IIRC, there was a discussion on exposing netns i-node number to
>> userspace time ago on netdev and Eric Biederman was not happy about
>> this?
>
> He was not happy about it being exposed in the /proc filesystem.  We've
> been talking since then and while we've not come to a definitive
> conclusion there is a communication channel open.
>
> This is more of an RFC patch than the rest of this set and I didn't
> seriously expect this one to be accepted, I did want to present the idea
> to see if there were concerns or better ideas generated how to
> differentiate this record from a seemingly identical one.  The only
> other ID would be the network namespace' struct pointer.
>
> At this stage, one thing that is missing is a device number to qualify
> this namespace ID.
>
> Once I started printing the namespace proc inode number (minus the
> starting offset) in decimal, it was very clear what was happenning and
> seemed worth sharing that debugging tool patch.

If the appropriate device number and full inode number is included I
don't have any deep problems with the idea.  I don't like the bare inode
number as we have had in the past and may in the future have these inode
numbers in multiple filesystems so the inode number by itself is not
unique.

Eric
