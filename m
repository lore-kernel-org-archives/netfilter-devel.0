From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf] netfilter: conntrack: fix false CRC32c mismatch
 using paged skb
Date: Fri, 19 May 2017 13:39:30 +0200
Message-ID: <1495193970.2897.48.camel@redhat.com>
References: <f156034b4975584477c319a0946eb7adfc8d1e36.1495119678.git.dcaratti@redhat.com>
         <20170519084103.GA2512@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbdESLjh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 07:39:37 -0400
In-Reply-To: <20170519084103.GA2512@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello Pablo, thank you for looking at this!
On Fri, 2017-05-19 at 10:41 +0200, Pablo Neira Ayuso wrote:
> On Thu, May 18, 2017 at 06:01:43PM +0200, Davide Caratti wrote:
> > sctp_compute_cksum() implementation assumes that at least the SCTP header
> > is in the linear part of skb: modify conntrack error callback to avoid
> > false CRC32c mismatch, if the transport header is partially/entirely paged.
> 
> I guess you considered this, but I would like to know the reason for
> this approach. Why not fix this from sctp_compute_cksum()? 

I think sctp_compute_cksum() is legitimately needing the transport header
i
n the linear data of skb, because it needs to set to zero 4 octects at
CRC32c offset before computing the CRC32c (as per RFC3309 §2.1). Since
these are the last 4 octects of the SCTP header, then we need to
__pskb_pull_tail() on the whole header, if some/all of its members are
paged.

> I mean, I can see other spots in the kernel tree that may be affected by this?
> Or is it that you're only observing this from a path that is specific
> of conntrack?

I did the check before posting, and the kernel code seemed to already
ensure skb is writable until SCTP header + sizeof(SCTP header) offset,
before calling sctp_compute_cksum(). Just to be sure, I re-did that check
today: besides nf_conntrack sctp_error(), I'm only doubtful about IPVS
sctp_csum_check() (but I don't have a test scenario yet).

That's why I propose to fix only sctp_error() in conntrack. Regarding
IPVS, 2 out of 3 calls to sctp_compute_cksum() are preceded by
skb_make_writable(), which is correct. I can do a test for IPVS
sctp_csum_check() and check if it also needs some change, and post it in a
separate patch. Is that acceptable?

thank you in advance,
regards
--
davide
 
