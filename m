From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: bridge: unshare bridge info before change it
Date: Tue, 4 Nov 2014 20:00:55 +0100
Message-ID: <20141104190055.GA27683@salvia>
References: <1411976114-16812-1-git-send-email-gaofeng@cn.fujitsu.com>
 <54582195.20209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37115 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaKDS7O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:59:14 -0500
Content-Disposition: inline
In-Reply-To: <54582195.20209@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 04, 2014 at 08:45:09AM +0800, Gao feng wrote:
> On 09/29/2014 03:35 PM, Gao feng wrote:
> > Many packets may share the same bridge information,
> > we should unshare the bridge info before we change it,
> > otherwise other packets will go to PF_INET(6)/PRE_ROUTING
> > second time or the pkt_type of other packets will be
> > incorrect.
> > 
> > The problem occurs when we do nfqueue after br_nf_pre_routing
> > and before bf_nf_pre_routing_finish, if the packet is gso,
> > the new segs will share the same bridge info. and netfilter
> > may use skb_clone, this will cause many packets share the
> > same bridge info too.
> > 
> > Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> > ---
> 
> any comments?

This doesn't apply cleanly. We modularized br_netfilter by the time
you sent this, see 54dc125. You'll have to rebase this patch.

Moreover, could you develop what you're noticing a bit more? Thanks.
