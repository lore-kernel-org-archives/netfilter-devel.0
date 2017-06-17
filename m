From: Florian Westphal <fw@strlen.de>
Subject: Re: [NFQUEUE] lack of UID/GID fields in fragmented packets
Date: Sat, 17 Jun 2017 22:23:20 +0200
Message-ID: <20170617202320.GA28291@breakpoint.cc>
References: <oi3n2u$cs6$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Piotr Sawicki <piotr.sawicki@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41848 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752093AbdFQUYG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jun 2017 16:24:06 -0400
Content-Disposition: inline
In-Reply-To: <oi3n2u$cs6$1@blaine.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Piotr Sawicki <piotr.sawicki@gmail.com> wrote:
> Everything works fine until I try to send huge packets. When the size of
> these packets is larger than MTU then the fragmentation occurs. I've
> observed that the first fragment has valid UID and GID fields, but the rest
> of the fragments do not include them.
> 
> I've found that the remedy for this concern is to set NFQA_CFG_F_GSO flag.

All users should set this flag.

We can't make it default because it breaks old applications
that can't deal with large (offload) packets.

> I've found that when the fragmentation procedure splits the packet into
> fragments, it keeps a valid sk only in the first fragment. Therefore, it is
> impossible to fetch valid UID and GID fields from the rest of the fragments.
> 
> Is it intended behavior, or is it a bug?

Neither.  UID code was added later, so this wasn't a problem.
I would suggest to just set F_GSO flag; it has no disadvantages.

