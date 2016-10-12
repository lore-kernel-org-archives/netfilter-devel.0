From: Ulrich Weber <uweber.linux@gmail.com>
Subject: Re: [RFC] SIP conntrack handler and TCP fragmentation
Date: Wed, 12 Oct 2016 10:52:34 +0200
Message-ID: <1e3ffb89-2c24-526a-01aa-53794d554202@gmail.com>
References: <c92b64f3-9f69-eb7c-402c-3e489f73a527@gmail.com>
 <20161012075212.GA26177@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36569 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932088AbcJLIwh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 04:52:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id b80so1315053wme.3
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2016 01:52:37 -0700 (PDT)
In-Reply-To: <20161012075212.GA26177@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On 12.10.2016 09:52, Florian Westphal wrote:
> Ulrich Weber <ulrich.weber@gmail.com> wrote:
>> I know the proper solution would be TCP defragmentation
>> in the nf_conntrack_sip kernel module. However I'm not
>> sure if this is worth the effort.
> 
> I think an even better solution would be a SIP proxy that can
> inject expectations to keep datapath in kernel and only deals with
> the signalling traffic.
Yes your right, is there already one capable of doing this?
But then again, I dont want to put a proxy on an embedded box ;)

> 
>> What about just accepting unparsable TCP SIP packets?
> 
> I wonder why this patch did not fix your problem:
> 
> 3a7b21eaf4fb3c971bdb47a98f570550ddfe4471
> Author: Patrick McHardy <kaber@trash.net>
> netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet
> 
> It specifically deals with this problem (l7 size larger than packet
> size).
>From reading the code this fixed the problem when Content-Length
points to one of the next TCP fragments.

In our case Content-Length is always 0 with a couple of SUBSCRIBE calls.
E.g. a TCP packet starting with this will break the SIP connection tracking:

INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
Content-Length: 0

The previous TCP packet was accepted by SIP connection tracking
because it had no Content-Length field.

Cheers
 Ulrich
