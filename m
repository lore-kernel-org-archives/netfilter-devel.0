From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] SIP conntrack handler and TCP fragmentation
Date: Wed, 12 Oct 2016 13:41:40 +0200
Message-ID: <20161012114140.GB26177@breakpoint.cc>
References: <c92b64f3-9f69-eb7c-402c-3e489f73a527@gmail.com>
 <20161012075212.GA26177@breakpoint.cc>
 <1e3ffb89-2c24-526a-01aa-53794d554202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>
To: Ulrich Weber <uweber.linux@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35352 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752706AbcJLLm2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 07:42:28 -0400
Content-Disposition: inline
In-Reply-To: <1e3ffb89-2c24-526a-01aa-53794d554202@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ulrich Weber <uweber.linux@gmail.com> wrote:
> From reading the code this fixed the problem when Content-Length
> points to one of the next TCP fragments.

Right.

> In our case Content-Length is always 0 with a couple of SUBSCRIBE calls.
> E.g. a TCP packet starting with this will break the SIP connection tracking:
> 
> INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
> Content-Length: 0

Ugh.

I guess it makes sense to detect this and then accept for this case too.

> The previous TCP packet was accepted by SIP connection tracking
> because it had no Content-Length field.

Perhaps we should treat Content-length of 0 like "no Conent-Length
field".
