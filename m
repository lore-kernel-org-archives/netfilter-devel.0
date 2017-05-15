From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Report transactions'
 process info to user space
Date: Mon, 15 May 2017 18:44:32 +0200
Message-ID: <20170515164432.GL20805@orbyte.nwl.cc>
References: <20170515145149.26114-1-phil@nwl.cc>
 <20170515155331.GA32385@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55447 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbdEOQoe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:44:34 -0400
Content-Disposition: inline
In-Reply-To: <20170515155331.GA32385@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 15, 2017 at 05:53:31PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 15, 2017 at 04:51:49PM +0200, Phil Sutter wrote:
> > When committing a transaction, report PID and name of user space process
> > which initiated it.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h | 16 +++++++++++
> >  net/netfilter/nf_tables_api.c            | 49 ++++++++++++++++++++++++++++++++
> >  2 files changed, 65 insertions(+)
> > 
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index 683f6f88fcace..7c012690a5f02 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -90,6 +90,7 @@ enum nft_verdicts {
> >   * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
> >   * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
> >   * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
> > + * @NFT_MSG_PROC_INFO: get info about user space process which initiated the transaction
> >   */
> >  enum nf_tables_msg_types {
> >  	NFT_MSG_NEWTABLE,
> > @@ -114,6 +115,7 @@ enum nf_tables_msg_types {
> >  	NFT_MSG_GETOBJ,
> >  	NFT_MSG_DELOBJ,
> >  	NFT_MSG_GETOBJ_RESET,
> > +	NFT_MSG_PROC_INFO,
> 
> No need for a new message. You can place this into existing the NEWGEN
> messages.

But that message is sent last and so at the time nft sees it, the events
will have been printed already, no?

Thanks, Phil
