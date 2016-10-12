From: Ulrich Weber <uweber.linux@gmail.com>
Subject: Re: [RFC] SIP conntrack handler and TCP fragmentation
Date: Wed, 12 Oct 2016 14:27:01 +0200
Message-ID: <383cd1d2-23c2-d753-09f0-ee3a5edf9ffe@gmail.com>
References: <c92b64f3-9f69-eb7c-402c-3e489f73a527@gmail.com>
 <20161012075212.GA26177@breakpoint.cc>
 <1e3ffb89-2c24-526a-01aa-53794d554202@gmail.com>
 <20161012114140.GB26177@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34570 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbcJLM10 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 08:27:26 -0400
Received: by mail-lf0-f43.google.com with SMTP id b81so72473302lfe.1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2016 05:27:04 -0700 (PDT)
In-Reply-To: <20161012114140.GB26177@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.10.2016 13:41, Florian Westphal wrote:
> Ulrich Weber <uweber.linux@gmail.com> wrote:
>> From reading the code this fixed the problem when Content-Length
>> points to one of the next TCP fragments.
> 
> Right.
> 
>> In our case Content-Length is always 0 with a couple of SUBSCRIBE calls.
>> E.g. a TCP packet starting with this will break the SIP connection tracking:
>>
>> INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
>> Content-Length: 0
> 
> Ugh.
> 
> I guess it makes sense to detect this and then accept for this case too.
> 
>> The previous TCP packet was accepted by SIP connection tracking
>> because it had no Content-Length field.
> 
> Perhaps we should treat Content-length of 0 like "no Conent-Length
> field".
> 
Ahh, I found the root of the problem ;)

Since the payload doesnt start with SIP/2.0, its interpreted as
a response. Starting with INVITE its interpreted as an INVITE
request. Since there is no CSeq header found, its dropped then as invalid.

Possible proper solutions would be either
a) add trailing space to sip_handlers commands
b) check for trailing SIP/2.0 in request line

Do you think a or b would break existing setups?
