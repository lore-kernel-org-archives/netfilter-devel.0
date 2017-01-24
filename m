From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_log: restrict the log prefix length to
 127
Date: Tue, 24 Jan 2017 21:45:47 +0100
Message-ID: <20170124204547.GA12529@salvia>
References: <1485094232-19683-1-git-send-email-zlpnobody@163.com>
 <20170124192629.GA10120@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdAXUqI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 15:46:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F96E209907
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 21:46:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E4986752
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 21:46:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CEE72A6C1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 21:46:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170124192629.GA10120@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 24, 2017 at 08:26:29PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Jan 22, 2017 at 10:10:32PM +0800, Liping Zhang wrote:
> > From: Liping Zhang <zlpnobody@gmail.com>
> > 
> > First, log prefix will be truncated to NF_LOG_PREFIXLEN-1, i.e. 127,
> > at nf_log_packet(), so the extra part is useless.
> > 
> > Second, after adding a log rule with a very very long prefix, we will
> > fail to dump the nft rules after this _special_ one, but acctually,
> > they do exist. For example:
> >   # name_65000=$(printf "%0.sQ" {1..65000})
> >   # nft add rule filter output log prefix "$name_65000"
> >   # nft add rule filter output counter
> >   # nft add rule filter output counter
> >   # nft list chain filter output
> >   table ip filter {
> >       chain output {
> >           type filter hook output priority 0; policy accept;
> >       }
> >   }
> > 
> > So now, restrict the log prefix length to NF_LOG_PREFIXLEN-1.
> > 
> > Fixes: 96518518cc41 ("netfilter: add nftables")
> > Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> > ---
> > I think this is different with http://patchwork.ozlabs.org/patch/717635/.
> > So another separate patch will be better.
> > 
> >  include/uapi/linux/netfilter/nf_log.h | 2 ++
> >  net/netfilter/nf_log.c                | 1 -
> >  net/netfilter/nft_log.c               | 3 ++-
> >  3 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/netfilter/nf_log.h b/include/uapi/linux/netfilter/nf_log.h
> > index 8be21e0..d0b5fa9 100644
> > --- a/include/uapi/linux/netfilter/nf_log.h
> > +++ b/include/uapi/linux/netfilter/nf_log.h
> > @@ -9,4 +9,6 @@
> >  #define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
> >  #define NF_LOG_MASK		0x2f
> >  
> > +#define NF_LOG_PREFIXLEN	128
> 
> Nitpick: xt_LOG allows 30 bytes, so we can probably stick to 32 bytes
> here. Then, wait for usecases for larger strings, enlarging things is
> easier than shrinking stuff later on (we can't actually, given that we
> would break backward).
> 
> Probably we can keep __NF_LOG_PREFIXLEN 128 for what it already exists
> in nf_log.c internally, and expose NF_LOG_PREFIXLEN of 32 bytes?

Hm. We've been exposing 128 bytes already since the beginning given we
lacked any validation.

Then, this patch is fine. Applied, thanks.
