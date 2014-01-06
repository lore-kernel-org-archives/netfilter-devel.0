From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 17:15:23 +0000
Message-ID: <20140106171523.GC23002@macbook.localnet>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
 <20140106170523.GA9894@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kristian Evensen <kristian.evensen@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55481 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAFRP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:15:27 -0500
Content-Disposition: inline
In-Reply-To: <20140106170523.GA9894@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 06:05:23PM +0100, Florian Westphal wrote:
> Kristian Evensen <kristian.evensen@gmail.com> wrote:
> > From: Kristian Evensen <kristian.evensen@gmail.com>
> > 
> > This patch enables connmark to be set/retrieved using meta
> > expressions/statements.
> > 
> > Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h |  2 ++
> >  net/netfilter/nft_meta.c                 | 34 ++++++++++++++++++++++++++++++++
> >  2 files changed, 36 insertions(+)
> > 
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index aa86a152..05eaeb9 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -531,6 +531,7 @@ enum nft_exthdr_attributes {
> >   * @NFT_META_NFTRACE: packet nftrace bit
> >   * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
> >   * @NFT_META_SECMARK: packet secmark (skb->secmark)
> > + * @NFT_META_CONNMARK: used to get/set the connection mark
> >   */
> >  enum nft_meta_keys {
> >  	NFT_META_LEN,
> > @@ -548,6 +549,7 @@ enum nft_meta_keys {
> >  	NFT_META_NFTRACE,
> >  	NFT_META_RTCLASSID,
> >  	NFT_META_SECMARK,
> > +	NFT_META_CONNMARK,
> >  };
> 
> This looks wrong, meta is for packet properties.
> You should probably use NFT_CT_MARK from nft_ct_keys enum.

Well, actually the ct expression already supports connmark, as does userspace.

#ifdef CONFIG_NF_CONNTRACK_MARK
        case NFT_CT_MARK:
                dest->data[0] = ct->mark;
                return;
#endif
