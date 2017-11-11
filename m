From: Jay Elliott <jelliott@arista.com>
Subject: Re: [PATCH] netfilter: conntrack: use 64-bit conntracking timestamps
Date: Fri, 10 Nov 2017 16:50:08 -0800
Message-ID: <CA+c2rSiy9rqT=J=W8h1BDFB2oF9o1=Bue6qeFL4aZwAATGqSWQ@mail.gmail.com>
References: <1510356081-35555-1-git-send-email-jelliott@arista.com> <20171111000722.GH5512@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:47464 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754622AbdKKAua (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 19:50:30 -0500
Received: by mail-qk0-f193.google.com with SMTP id 136so3110507qkd.4
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 16:50:29 -0800 (PST)
In-Reply-To: <20171111000722.GH5512@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>Still, I wonder why we need timeouts larger than 2**31.

The need is because at my employer, we sell boxes which include
hardware devices between the ethernet interface and the CPU.  These
hardware devices process certain network protocols on behalf of the
linux machine.  From the kernel's perspective, any packets which are
processed by these hardware devices never arrive, so the userspace
program which is configuring our conntracking has to use massive
timeouts.

>If the problem is that userspace can set them via nfnetlink I would
>propose to just truncate to INT_MAX in that case.

Okay, I'll submit another patch to do that instead.  That ought to fix
the problem I'm seeing.

Thank you,
Jay

On Fri, Nov 10, 2017 at 4:07 PM, Florian Westphal <fw@strlen.de> wrote:
> Jay Elliott <jelliott@arista.com> wrote:
>> As of commit 58e207e4983d ("netfilter: evict stale entries when user reads
>> /proc/net/nf_conntrack"), timeouts are evaluated by casting the difference
>> between a timeout value and the nfct_time_stamp to a signed integer and
>> comparing that to zero.
>>
>> This means that any timeout greater than or equal to (1<<31) will be
>> considered negative, and the conntracking code will think it has
>> immediately expired.  Prior to 58e207e4983d, they would have been treated
>> as very large positive timeouts.
>>
>> Using 64-bit will allow the full range of a 32-bit unsigned integer to be
>> used as a positive value without changing any of the logic used to
>> evaluate timeouts.  The timeout value input from userspace over the
>> netlink is still 32-bit.
>>
>> Fixes: 58e207e4983d ("netfilter: evict stale entries when user reads /proc/net/nf_conntrack")
>> Signed-off-by: Jay Elliott <jelliott@arista.com>
>> ---
>>  include/net/netfilter/nf_conntrack.h | 10 +++++-----
>>  net/netfilter/nf_conntrack_netlink.c |  6 ++++--
>>  2 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
>> index 792c3f6..62bfc33 100644
>> --- a/include/net/netfilter/nf_conntrack.h
>> +++ b/include/net/netfilter/nf_conntrack.h
>> @@ -71,8 +71,8 @@ struct nf_conn {
>>       /* Have we seen traffic both ways yet? (bitset) */
>>       unsigned long status;
>>
>> -     /* jiffies32 when this ct is considered dead */
>> -     u32 timeout;
>> +     /* jiffies64 when this ct is considered dead */
>> +     u64 timeout;
>
> I know his fits in a padding hole and sruct size doesn't increase.
>
> Still, I wonder why we need timeouts larger than 2**31.
> (More than 20 days assuming HZ=1000).
>
> If the problem is that userspace can set them via nfnetlink I would
> propose to just truncate to INT_MAX in that case.
>
