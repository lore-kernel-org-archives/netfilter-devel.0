From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Report transactions'
 process info to user space
Date: Fri, 19 May 2017 12:41:28 +0200
Message-ID: <20170519104128.GG17767@orbyte.nwl.cc>
References: <20170515145149.26114-1-phil@nwl.cc>
 <20170515155331.GA32385@salvia>
 <20170515164432.GL20805@orbyte.nwl.cc>
 <20170515175444.GA6179@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50561 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752878AbdESKla (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 06:41:30 -0400
Content-Disposition: inline
In-Reply-To: <20170515175444.GA6179@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 15, 2017 at 07:54:44PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 15, 2017 at 06:44:32PM +0200, Phil Sutter wrote:
> > On Mon, May 15, 2017 at 05:53:31PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, May 15, 2017 at 04:51:49PM +0200, Phil Sutter wrote:
> > > > When committing a transaction, report PID and name of user space process
> > > > which initiated it.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  include/uapi/linux/netfilter/nf_tables.h | 16 +++++++++++
> > > >  net/netfilter/nf_tables_api.c            | 49 ++++++++++++++++++++++++++++++++
> > > >  2 files changed, 65 insertions(+)
> > > > 
> > > > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > > > index 683f6f88fcace..7c012690a5f02 100644
> > > > --- a/include/uapi/linux/netfilter/nf_tables.h
> > > > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > > @@ -90,6 +90,7 @@ enum nft_verdicts {
> > > >   * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
> > > >   * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
> > > >   * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
> > > > + * @NFT_MSG_PROC_INFO: get info about user space process which initiated the transaction
> > > >   */
> > > >  enum nf_tables_msg_types {
> > > >  	NFT_MSG_NEWTABLE,
> > > > @@ -114,6 +115,7 @@ enum nf_tables_msg_types {
> > > >  	NFT_MSG_GETOBJ,
> > > >  	NFT_MSG_DELOBJ,
> > > >  	NFT_MSG_GETOBJ_RESET,
> > > > +	NFT_MSG_PROC_INFO,
> > > 
> > > No need for a new message. You can place this into existing the NEWGEN
> > > messages.
> > 
> > But that message is sent last and so at the time nft sees it, the events
> > will have been printed already, no?
> 
> This is an event, so it is asynchronous. From a timely perspective, we
> get nothing if we send it just a bit before.

My concern was that it's not possible to keep the additional information
in the same line as the events it is interesting for. So in order to not
introduce caching in 'nft monitor', the new format would be something
like this:

| add chain ip t c
| new generation 3 by process 2841 (nft)
| add table ip t2
| add chain ip t2 c
| add rule ip t2 c counter packets 0 bytes 0
| new generation 4 by process 2851 (nft)

Is this fine with you, or do you have something different in mind?

> I suspect the problem is the lack of context, ie. access ctx->portid,
> ctx->seq and ctx->report, then we should take this from the original
> initial netlink message header coming in the batch (see
> nfnetlink_rcv_batch() in nfnetlink.c).

That's not necessary? My current PoC looks like this:

| @@ -4538,7 +4539,9 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
|         nfmsg->version          = NFNETLINK_V0;
|         nfmsg->res_id           = htons(net->nft.base_seq & 0xffff);
|  
| -       if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)))
| +       if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
| +           nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
| +           nla_put_string(skb, NFTA_GEN_PROC_NAME, get_task_comm(buf, current)))
|                 goto nla_put_failure;
|  
|         nlmsg_end(skb, nlh);

Or do you think it's not safe to access 'current' at this point?

Thanks, Phil
