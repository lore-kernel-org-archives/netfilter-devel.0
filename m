From: Tarun Khanna <tkhanna@akamai.com>
Subject: Re: per flow stats collection using libnetfilter_conntrack
Date: Thu, 9 Mar 2017 10:52:29 -0500
Message-ID: <fa81dae5-06cb-8a5e-ae55-9d7619d1dc9e@akamai.com>
References: <3bbe482c-863f-2b29-e3fd-522b0079ddbb@akamai.com>
 <20170227221258.GA30877@breakpoint.cc>
 <f64a7498-a68c-cc10-7adc-0df35fc60d96@akamai.com>
 <20170309094038.GB17668@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([23.79.238.175]:61190 "EHLO
        prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753918AbdCIQAD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 11:00:03 -0500
In-Reply-To: <20170309094038.GB17668@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Tarun Khanna <tkhanna@akamai.com> wrote:
>> On 02/27/2017 05:12 PM, Florian Westphal wrote:
>>> Tarun Khanna <tkhanna@akamai.com> wrote:
>>>> Is it possible to register for callbacks so that a user application is
>>>> updated on a regular basis when the packet or bytes counts change for flows?
>>> No, update to packet/byte count doesn't trigger an event (it would
>>> trigger too often).
>> I was hoping if there was an option to set a timeout, so that an update
>> would trigger every 5 seconds for flows where the counters have changed.
> No, there is no such feature at the moment.
>
>> I have an application that needs to keep track of per flow stats for all tcp
>> flows destined to port 80. The best way I have found so far is to call
>> nfct_query regularly and to go through each flow returned to retrieve the
>> counters. Would that be the best way to do it?
> Its your only option right now.  If you need a periodic update feature
> we'll need to think about how to best make this.
>
> We now have a periodic gc worker in conntrack so we could probably do
> this without re-adding a per-conntrack timer.

Thank you. The current way of polling works for me. I was thinking about 
it and it doesn't really make a difference if the library sends me 
updates periodically or if I check for them because in both cases I'll 
need to setup some event on epoll (either a timer or the netfilter fd). 
So, functionally both would be the same. Thanks again for your help.
