From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Report transactions'
 process info to user space
Date: Tue, 6 Jun 2017 13:39:20 +0200
Message-ID: <20170606113920.GA2465@salvia>
References: <20170515145149.26114-1-phil@nwl.cc>
 <20170515155331.GA32385@salvia>
 <20170515164432.GL20805@orbyte.nwl.cc>
 <20170515175444.GA6179@salvia>
 <20170519104128.GG17767@orbyte.nwl.cc>
 <20170530121211.GA3032@salvia>
 <20170530162149.ydp5lfdalfcww7nh@base.sg13b.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46328 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdFFLjo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 07:39:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57C2E2EFEB6
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:39:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4986F102187
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:39:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 908B4102195
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 13:39:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170530162149.ydp5lfdalfcww7nh@base.sg13b.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 30, 2017 at 06:21:49PM +0200, Phil Sutter wrote:
> On Tue, May 30, 2017 at 02:12:11PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, May 19, 2017 at 12:41:28PM +0200, Phil Sutter wrote:
> > What I mean is that that we should use the heading netlink message as
> > netlink context (portid, flags) for the NEWGEN message. This is
> > currently broken. I'll send a patch to fix this, so you can send a
> > follow up of this on top of this.
> 
> OK, thanks!

Actually the existing code for NEWGEN looks good. We pass the original
skbuff to ->commit(), so we can fetch from the _BEGIN netlink message
coming in first place in the batch the context we need.

> > > | @@ -4538,7 +4539,9 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
> > > |         nfmsg->version          = NFNETLINK_V0;
> > > |         nfmsg->res_id           = htons(net->nft.base_seq & 0xffff);
> > > |  
> > > | -       if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)))
> > > | +       if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
> > > | +           nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
> > > | +           nla_put_string(skb, NFTA_GEN_PROC_NAME, get_task_comm(buf, current)))
> > > |                 goto nla_put_failure;

So you only need to add these missing to the NEWGEN message.

Thanks!
