From: Ben Hawkes <hawkes@google.com>
Subject: Re: [PATCH nf] netfilter: x_tables: deal with bogus nextoffset values
Date: Thu, 10 Mar 2016 06:41:24 -0800
Message-ID: <CABWXx8Ek1PbyPnw6mcsGeMTseDUpqW3deFipOBMmS-+7EszZeA@mail.gmail.com>
References: <1457571362-25441-1-git-send-email-fw@strlen.de>
	<20160310141231.GA13006@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33196 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbcCJOlZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 09:41:25 -0500
Received: by mail-yk0-f172.google.com with SMTP id z7so35925316yka.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 06:41:25 -0800 (PST)
In-Reply-To: <20160310141231.GA13006@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 6:12 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 10, 2016 at 01:56:02AM +0100, Florian Westphal wrote:
>> Ben Hawkes says:
>>
>>  In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
>>  is possible for a user-supplied ipt_entry structure to have a large
>>  next_offset field. This field is not bounds checked prior to writing a
>>  counter value at the supplied offset.
>>
>> Problem is that xt_entry_foreach() macro stops iterating once e->next_offset
>> is out of bounds, assuming this is the last entry.
>>
>> With malformed data thats not necessarily the case so we can
>> write outside of allocated area later as we might not have walked the
>> entire blob.
>>
>> Fix this by simplifying mark_source_chains -- it already has to check
>> if nextoff is in range to catch invalid jumps, so just do the check
>> when we move to a next entry as well.
>
> Thanks for posting this patch so fast Florian.
>
> It's sad that Ben didn't even take the time to reach the people that
> the MAINTAINERS file shows in first place *sigh*.

What is sad about this precisely? I followed the documented process
for reporting a security issue
(https://www.kernel.org/doc/Documentation/SecurityBugs), and then
followed the instructions I received from this list. If you have a
problem with my actions, then I suggest you raise this with
security@kernel.org.

> I'll place this in nf-next together with remaining pending fixes, it
> seems we'll have 4.5 just after this -rc7 so I don't think we'll get
> there in time for this.
>
> I'll pass this to -stable once this hits master, these patches apply
> cleanly to every kernel starting 3.2.
>
