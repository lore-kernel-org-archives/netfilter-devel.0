From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Overlapping IP networks no longer allowed?
Date: Thu, 15 Feb 2018 14:29:49 +0100
Message-ID: <20180215132949.4kiptc4pj2wnstce@salvia>
References: <CAPWNY8W5euS6+LrEppdKp81k-Uz48w2WZP8kzu5=cVyhObnVMg@mail.gmail.com>
 <20180214182249.nnccha2bg5j4htrv@salvia>
 <20180214223218.GG2810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41726 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031273AbeBON3y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 08:29:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 163ED1F4B77
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 14:29:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0B1BDA3B4
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 14:29:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180214223218.GG2810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 11:32:18PM +0100, Florian Westphal wrote:
> For named sets, the no automerge makes sense because it seems like
> we can't make any reasonable default choice when users try to delete
> a no-longer existing (i.e. merged) element.
> 
> But that problem doesn't exist with constant (anon or not) sets.

OK, then this will be our default behaviour in the upcoming 0.8.3 wrt.
auto-merge:

                   simple key     mapping       timeouts
anonymous set      enabled       disabled       disabled
named set          disabled [*]  disabled       disabled

[*] can be enabled on-demand via auto-merge option.

OK?
