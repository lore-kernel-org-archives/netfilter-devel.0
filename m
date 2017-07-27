From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC v2 3/4] Implement --echo option
Date: Thu, 27 Jul 2017 18:54:35 +0200
Message-ID: <20170727165435.GS2235@orbyte.nwl.cc>
References: <20170727162144.28703-1-phil@nwl.cc>
 <20170727162144.28703-4-phil@nwl.cc>
 <20170727164300.GA10637@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:48545 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751801AbdG0Qyg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 12:54:36 -0400
Content-Disposition: inline
In-Reply-To: <20170727164300.GA10637@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 27, 2017 at 06:43:00PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 27, 2017 at 06:21:43PM +0200, Phil Sutter wrote:
> > diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> > index 40096de04e963..70404f724808a 100644
> > --- a/include/linux/netfilter/nf_tables.h
> > +++ b/include/linux/netfilter/nf_tables.h
> > @@ -114,6 +114,7 @@ enum nf_tables_msg_types {
> >  	NFT_MSG_GETOBJ,
> >  	NFT_MSG_DELOBJ,
> >  	NFT_MSG_GETOBJ_RESET,
> > +	NFT_MSG_META_ECHO,
> 
> Why this?

See netlink_echo_callback(): I want to reuse monitor code as much as
possible, and therefore introduced that function as common callback
dispatching to monitor callbacks. In order to make them print data like
I want them to, I need to have an indicator. The simplest way was to
introduce this fake type which in callbacks acts as third option to
NFT_MSG_NEW* or NFT_MSG_DEL*.

Cheers, Phil
