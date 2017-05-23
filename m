From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf] netfilter: conntrack: fix false CRC32c mismatch
 using paged skb
Date: Tue, 23 May 2017 15:51:05 +0200
Message-ID: <1495547465.3148.10.camel@redhat.com>
References: <f156034b4975584477c319a0946eb7adfc8d1e36.1495119678.git.dcaratti@redhat.com>
         <20170519084103.GA2512@salvia> <1495193970.2897.48.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752668AbdEWNvK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 09:51:10 -0400
In-Reply-To: <1495193970.2897.48.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello Pablo,
On Fri, 2017-05-19 at 13:39 +0200, Davide Caratti wrote:
> On Fri, 2017-05-19 at 10:41 +0200, Pablo Neira Ayuso wrote:
> > I mean, I can see other spots in the kernel tree that may be affected by this?
> > Or is it that you're only observing this from a path that is specific
> > of conntrack?
> 
> I did the check before posting, and the kernel code seemed to already
> ensure skb is writable until SCTP header + sizeof(SCTP header) offset,
> before calling sctp_compute_cksum(). Just to be sure, I re-did that check
> today: besides nf_conntrack sctp_error(), I'm only doubtful about IPVS
> sctp_csum_check() (but I don't have a test scenario yet).

looking at IPVS code: it seems to me that the only call to sctp_csum_check()
is inside sctp_snat_handler(), after skb_make_writable() has returned
successfully.  So, apparently misuse of sctp_compute_cksum() affects only
nf_conntrack module in sctp_error() callback.

Maybe this patch needs 'Fixes: cf6e007eef83 ("netfilter: conntrack: validate
SCTP crc32c in PREROUTING")' tag ?

thanks!
--
davide

