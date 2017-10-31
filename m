From: Yi-Hung Wei <yihung.wei@gmail.com>
Subject: Re: [RFC] connlimit for nftables and limiting ct count by zone
Date: Tue, 31 Oct 2017 16:50:30 -0700
Message-ID: <CAG1aQhJ06iWmXsxD8QsaR-tkJVnGRKhAP1ieBx5ENY1kAzzsBg@mail.gmail.com>
References: <20171016144254.GA3728@breakpoint.cc> <CAG1aQhJR9OMtxKgW3CQePsGDahbrpUpNk0Srx=RdOnr0_tWmKg@mail.gmail.com>
 <20171030104018.GA6593@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org, YiHung Wei <yihungw@vmware.com>,
        Justin Pettit <jpettit@vmware.com>, Joe Stringer <joe@ovn.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:53392 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932873AbdJaXuv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2017 19:50:51 -0400
Received: by mail-yw0-f178.google.com with SMTP id q126so540164ywq.10
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2017 16:50:51 -0700 (PDT)
In-Reply-To: <20171030104018.GA6593@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I think we could possible use maps to fetch values based on a key, e.g.
>
> nft add map filter zonelimits { type typeof(ct zone) : typeof(ct count); flags interval\;}
> nft add element filter zonelimits { 1-100 : 50000 }
> nft add element filter zonelimits { 101 : 60000 }
>
> nft add rule filter prerouting \
>   ct count { ip saddr & 255.255.255.0 } gt { ct zone }
>
> None of this is implemented or planned, just an idea.
>
> Don't think we should bother about this at this time and
> focus on the conntrack counting infrastructure first.
You are right, the first step should be focusing on the conntrack
counting infrastructure, and supporting that using maps looks handy.


>> How would we use nft to get the ct limit and ct count on
>> particular key ? It may be useful for debugging and monitoring
>> purpose?
>
> Really?  So far my impression was that ovs does not wish
> to interact with nft in any way.
I was thinking about how to use nft to get and the ct limit and ct
count not by ovs tho. Say a nft user may want to know how many active
connections are there in a particular zone.


>> It is not clear to me that why we have 'u32 key[5]'. Is it because the
>> key would be the combination of Ip/ipv6 src or dst address with mask
>> (up to 16bytes), src or dst port (2 bytes), and ct zone (2 bytes)?
>
> Yes, xt_connlimit would have
>
> u32 key[5];
>
> key[0] = zone;
> key[1] = iphdr->saddr;
>
> nf_connlimit_count, ... key, 8);
>
> key[2], [3], [4] are only needed for ipv6.
Thanks for explanation, that this part is clear now.


>> I am wondering if there will be APIs to set and get the conntrack
>> limit on particular key,
>
> No, this would not be provided by that backend, as the backend doesn't
> know how the result is used.  It just returns the number of connections
> that match the current key.
>
>> and also query the ct count on particular key
>> in the kernel space?
>
> For what purpose would that be needed?
I think as long as the user space utilities e.g. nft can query ct
limit, ct count, it is not necessarily to support that in the kernel
space.


>> Just as you mentioned in the DESTORY event approach. I am wondering if
>> we can store an extra pointer to the tree node maybe in struct
>> nf_ct_ext, so that we can associate nf_conn with the tree node and
>> increase the count when the connection is confirmed, and we will
>> reduce the count when the connection is destroyed. In this way, with
>> some extra space, the insertion and updating the count in the tree
>> node is O(1) and we can get rid of GC scheme. I am not sure how much
>> effort does it take to modify the conntrack core tho.
>
> There could be dozens of connlimit trees.
>
> For example, a user could configure per-zone limit and a per-host limit
> at the same time.
You are right, in this case we can store a list of pointers to
multiple trees. I do not have a strong opinion on this tho, just want
to check if it can help the design.

Thanks,

-Yi-Hung
