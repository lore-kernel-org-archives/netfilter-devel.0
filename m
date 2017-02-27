From: Tarun Khanna <tkhanna@akamai.com>
Subject: Re: per flow stats collection using libnetfilter_conntrack
Date: Mon, 27 Feb 2017 17:36:33 -0500
Message-ID: <f64a7498-a68c-cc10-7adc-0df35fc60d96@akamai.com>
References: <3bbe482c-863f-2b29-e3fd-522b0079ddbb@akamai.com>
 <20170227221258.GA30877@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:44879 "EHLO
        prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751944AbdB0Wgl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 17:36:41 -0500
In-Reply-To: <20170227221258.GA30877@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/27/2017 05:12 PM, Florian Westphal wrote:
> Tarun Khanna <tkhanna@akamai.com> wrote:
>> Is it possible to register for callbacks so that a user application is
>> updated on a regular basis when the packet or bytes counts change for flows?
> No, update to packet/byte count doesn't trigger an event (it would
> trigger too often).

I was hoping if there was an option to set a timeout, so that an update 
would trigger every 5 seconds for flows where the counters have changed.

>
>> I can poll the stats using something similar to "conntrack -L". However, I
>> was wondering if it's possible to be notified regularly on updates.
> No.  What semantics would you be interested in?
>
> Dumping is quite fast, whats the problem you need to solve?
I have an application that needs to keep track of per flow stats for all 
tcp flows destined to port 80. The best way I have found so far is to 
call nfct_query regularly and to go through each flow returned to 
retrieve the counters. Would that be the best way to do it?

Thank you for your assistance.
