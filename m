From: Florian Westphal <fw@strlen.de>
Subject: Re: Question about getting counters for transparent terminated flows
Date: Thu, 9 Mar 2017 10:38:16 +0100
Message-ID: <20170309093816.GA17668@breakpoint.cc>
References: <a2f3e82d-0155-4600-5ec9-f3b2a19265cb@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tarun Khanna <tkhanna@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41034 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750798AbdCIJit (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 04:38:49 -0500
Content-Disposition: inline
In-Reply-To: <a2f3e82d-0155-4600-5ec9-f3b2a19265cb@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tarun Khanna <tkhanna@akamai.com> wrote:
> I have an application that acts as a transparent proxy for tcp flows. I need
> to get packet and byte counters for these tcp flows on both sides of the
> proxy application. I looked at pulling the counters from the kernel using
> libnetfilter_conntrack. However I noticed that the conntrack library only
> shows one entry for flows that are terminated transparently. This is an
> issue, as I am not able to see byte and packet counters for the two sides of
> the flow separately. Is there a way to get the separate counters for flows
> that are transparently terminated?
> 
> If the flow is terminated but not transparently, I do get two separate
> entries from libnetfilter_conntrack, and the counters are as I would expect
> them to be.

In transparent case conntrack cannot tell the two connections apart as
they use the same addresses.

You could try to place one side into another conntrack zone using
'-j CT --zone $x' in the raw table.
