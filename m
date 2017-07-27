From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC v2 3/4] Implement --echo option
Date: Thu, 27 Jul 2017 18:56:47 +0200
Message-ID: <20170727165647.GA10869@salvia>
References: <20170727162144.28703-1-phil@nwl.cc>
 <20170727162144.28703-4-phil@nwl.cc>
 <20170727164300.GA10637@salvia>
 <20170727165435.GS2235@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdG0Q5A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 12:57:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A83F57E803
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 18:56:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DF741B3D3A
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 18:56:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54E4F1B3D41
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 18:56:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170727165435.GS2235@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 27, 2017 at 06:54:35PM +0200, Phil Sutter wrote:
> On Thu, Jul 27, 2017 at 06:43:00PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jul 27, 2017 at 06:21:43PM +0200, Phil Sutter wrote:
> > > diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> > > index 40096de04e963..70404f724808a 100644
> > > --- a/include/linux/netfilter/nf_tables.h
> > > +++ b/include/linux/netfilter/nf_tables.h
> > > @@ -114,6 +114,7 @@ enum nf_tables_msg_types {
> > >  	NFT_MSG_GETOBJ,
> > >  	NFT_MSG_DELOBJ,
> > >  	NFT_MSG_GETOBJ_RESET,
> > > +	NFT_MSG_META_ECHO,
> > 
> > Why this?
> 
> See netlink_echo_callback(): I want to reuse monitor code as much as
> possible, and therefore introduced that function as common callback
> dispatching to monitor callbacks. In order to make them print data like
> I want them to, I need to have an indicator. The simplest way was to
> introduce this fake type which in callbacks acts as third option to
> NFT_MSG_NEW* or NFT_MSG_DEL*.

Hm, there must be a way to reuse this code without adding a new
message type. From a netlink perspective, users should just set on the
NLM_ECHO flag to get echo reports. I don't want to have a new message
type for this.
