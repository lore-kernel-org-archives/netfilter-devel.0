From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Report transactions'
 process info to user space
Date: Mon, 15 May 2017 19:54:44 +0200
Message-ID: <20170515175444.GA6179@salvia>
References: <20170515145149.26114-1-phil@nwl.cc>
 <20170515155331.GA32385@salvia>
 <20170515164432.GL20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:55201 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757956AbdEORyt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 13:54:49 -0400
Content-Disposition: inline
In-Reply-To: <20170515164432.GL20805@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 15, 2017 at 06:44:32PM +0200, Phil Sutter wrote:
> On Mon, May 15, 2017 at 05:53:31PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, May 15, 2017 at 04:51:49PM +0200, Phil Sutter wrote:
> > > When committing a transaction, report PID and name of user space process
> > > which initiated it.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  include/uapi/linux/netfilter/nf_tables.h | 16 +++++++++++
> > >  net/netfilter/nf_tables_api.c            | 49 ++++++++++++++++++++++++++++++++
> > >  2 files changed, 65 insertions(+)
> > > 
> > > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > > index 683f6f88fcace..7c012690a5f02 100644
> > > --- a/include/uapi/linux/netfilter/nf_tables.h
> > > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > @@ -90,6 +90,7 @@ enum nft_verdicts {
> > >   * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
> > >   * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
> > >   * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
> > > + * @NFT_MSG_PROC_INFO: get info about user space process which initiated the transaction
> > >   */
> > >  enum nf_tables_msg_types {
> > >  	NFT_MSG_NEWTABLE,
> > > @@ -114,6 +115,7 @@ enum nf_tables_msg_types {
> > >  	NFT_MSG_GETOBJ,
> > >  	NFT_MSG_DELOBJ,
> > >  	NFT_MSG_GETOBJ_RESET,
> > > +	NFT_MSG_PROC_INFO,
> > 
> > No need for a new message. You can place this into existing the NEWGEN
> > messages.
> 
> But that message is sent last and so at the time nft sees it, the events
> will have been printed already, no?

This is an event, so it is asynchronous. From a timely perspective, we
get nothing if we send it just a bit before.

I suspect the problem is the lack of context, ie. access ctx->portid,
ctx->seq and ctx->report, then we should take this from the original
initial netlink message header coming in the batch (see
nfnetlink_rcv_batch() in nfnetlink.c).

Look, we send a batch from userspace that look like this:

        netlink header [ type = NFNL_MSG_BATCH_BEGIN ]
        nfnetlink header
        payload
        netlink header [ type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWRULE) ]
        nfnetlink header
        payload
        ...
        netlink header [ type = NFNL_MSG_BATCH_END ]
        nfnetlink header

There's an initial NFNL_MSG_BATCH_BEGIN and a trailing
NFNL_MSG_BATCH_END. No trailing NFNL_MSG_BATCH_END means abort
transaction, it provides a way to test if a ruleset applies cleanly,
similar to the -C command in iptables (this doesn't exist in nft
userspace though yet, it would be good to add this).

I think you should extract this relevant information you need from the
initial NFNL_MSG_BATCH_BEGIN netlink header, so semantically, this
applies to the result of the batch, ie. you use it from the NEWGEN
message.

We should pass some structure to nf_tables_commit() that provides this
global information, probably in an initial patch in the series.
