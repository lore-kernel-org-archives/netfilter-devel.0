From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: seqadj: Fix possible non-linear data
 access for TCP header
Date: Thu, 13 Apr 2017 23:44:59 +0200
Message-ID: <20170413214459.GA3936@salvia>
References: <1491820563-98023-1-git-send-email-gfree.wind@foxmail.com>
 <20170413213705.GA3430@salvia>
 <20170413214249.GA3612@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44088 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbdDMVpM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 17:45:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9749BA6ED
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:45:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E192BDA80B
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:45:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54DFFDA725
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:45:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170413214249.GA3612@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 13, 2017 at 11:42:49PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 13, 2017 at 11:37:05PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Apr 10, 2017 at 06:36:03PM +0800, gfree.wind@foxmail.com wrote:
> > > From: Gao Feng <fgao@ikuai8.com>
> > > 
> > > The current call path of nf_ct_tcp_seqadj_set is the following.
> > > 
> > > nfqnl_recv_verdict->ctnetlink_glue_hook->ctnetlink_glue_seqadj
> > > ->nf_ct_tcp_seqadj_set.
> > > 
> > > It couldn't make sure the TCP header is in the linear data part.
> > > So use the skb_header_pointer instead of the current codes.
> > > 
> > > BTW, the nf_ct_tcp_seqadj_set is one external function of netfilter
> > > which works in the network layer, it should not assume the transport
> > > header is in the linear data.
> > 
> > Applied.
> > 
> > I wish you fix your mail client setup, it is a mess. I always have to
> > figure out which patch is correct in the large bunch.  You have to be
> > more careful.
> 
> Wait, I'm dropping this.
> 
> Caller already guarantee that this area has been skb_make_writable via
> payload mangle, right?
> 
> Please, have a closer look.

BTW, please stop sending me patches until I review what I have in
patchwork from you.
