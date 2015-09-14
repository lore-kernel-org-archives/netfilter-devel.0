From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: bridge: fix routing of bridge frames with
 call-iptables=1
Date: Mon, 14 Sep 2015 23:38:05 +0200
Message-ID: <20150914213805.GA3618@salvia>
References: <1442220035-2225-1-git-send-email-fw@strlen.de>
 <20150914125104.GB6864@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60586 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbbINVba (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2015 17:31:30 -0400
Content-Disposition: inline
In-Reply-To: <20150914125104.GB6864@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 14, 2015 at 02:51:04PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 14, 2015 at 10:40:35AM +0200, Florian Westphal wrote:
> > We need to (re-)init physoutdev to NULL, as its storage area is used
> > to stash the ip destination to detect L3 nat.
> > 
> > For frames that are bridged this is no problem because the bridge
> > forward hook initializes physoutdev to the real bridge port.
> > 
> > But in case the skb is delivered locally and then routed we can crash
> > in the physdev match since nf_bridge->physoutdev is garbage
> > (ipv4/ipv6 address)
> 
> Also applied, thanks

For the record, I have kept this back as your requested.
