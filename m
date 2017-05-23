From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: fix false CRC32c mismatch using
 paged skb
Date: Tue, 23 May 2017 23:29:09 +0200
Message-ID: <20170523212909.GA9041@salvia>
References: <f156034b4975584477c319a0946eb7adfc8d1e36.1495119678.git.dcaratti@redhat.com>
 <20170519084103.GA2512@salvia>
 <1495193970.2897.48.camel@redhat.com>
 <1495547465.3148.10.camel@redhat.com>
 <20170523193533.GA5009@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034109AbdEWV3X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 17:29:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E678EE1231
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:29:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8E3BFF2F1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:29:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD700FF2F6
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:29:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170523193533.GA5009@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 23, 2017 at 09:35:33PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 23, 2017 at 03:51:05PM +0200, Davide Caratti wrote:
> > hello Pablo,
> > On Fri, 2017-05-19 at 13:39 +0200, Davide Caratti wrote:
> > > On Fri, 2017-05-19 at 10:41 +0200, Pablo Neira Ayuso wrote:
> > > > I mean, I can see other spots in the kernel tree that may be affected by this?
> > > > Or is it that you're only observing this from a path that is specific
> > > > of conntrack?
> > > 
> > > I did the check before posting, and the kernel code seemed to already
> > > ensure skb is writable until SCTP header + sizeof(SCTP header) offset,
> > > before calling sctp_compute_cksum(). Just to be sure, I re-did that check
> > > today: besides nf_conntrack sctp_error(), I'm only doubtful about IPVS
> > > sctp_csum_check() (but I don't have a test scenario yet).
> > 
> > looking at IPVS code: it seems to me that the only call to sctp_csum_check()
> > is inside sctp_snat_handler(), after skb_make_writable() has returned
> > successfully.  So, apparently misuse of sctp_compute_cksum() affects only
> > nf_conntrack module in sctp_error() callback.
> > 
> > Maybe this patch needs 'Fixes: cf6e007eef83 ("netfilter: conntrack: validate
> > SCTP crc32c in PREROUTING")' tag ?
> 
> Thanks for explaining.
> 
> I will append this "Fixes:" tag to this patch once I apply this.

Applied, thanks.
