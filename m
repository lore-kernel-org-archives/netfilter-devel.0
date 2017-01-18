From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: make more information
 available in DESTROY events
Date: Wed, 18 Jan 2017 17:18:49 +0100
Message-ID: <20170118161849.GH12001@breakpoint.cc>
References: <1484751272-5489-1-git-send-email-fw@strlen.de>
 <20170118150118.GA23289@salvia>
 <20170118150745.GG12001@breakpoint.cc>
 <20170118160335.GB29902@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Jarno Rajahalme <jarno@ovn.org>,
        Victor Julien <lists@inliniac.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33274 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751157AbdARQUH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 11:20:07 -0500
Content-Disposition: inline
In-Reply-To: <20170118160335.GB29902@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> IIRC, the destroy message is rather small. Moreover, think of
> thousands of messages in that queue, that makes a difference. And I
> cannot think of anything useful people can do with window scale and
> flags at that stage, right?

I could not think of a reason why any of the l4 tracker attributes are
useful in destroy so I can't answer your question :)
