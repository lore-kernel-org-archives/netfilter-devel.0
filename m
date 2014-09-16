From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 0/2] nfacct: add filter in to the list operation
Date: Tue, 16 Sep 2014 19:33:23 +0200
Message-ID: <20140916173323.GA21961@salvia>
References: <1410519418-8671-1-git-send-email-a.perevalov@samsung.com>
 <20140915164502.GA4705@salvia>
 <5417E1FC.4070007@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57650 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbaIPRc1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:32:27 -0400
Content-Disposition: inline
In-Reply-To: <5417E1FC.4070007@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 16, 2014 at 11:08:44AM +0400, Alexey Perevalov wrote:
> On 09/15/2014 08:45 PM, Pablo Neira Ayuso wrote:
> >On Fri, Sep 12, 2014 at 02:56:56PM +0400, Alexey Perevalov wrote:
> >>Hello Pablo,
> >>
> >>It's fourth version of patch for filtering, but also with fix for argument
> >>singleness.
> >Applied, thanks Alexey.
> >
> >I have made also some mostly comestic changes on it:
> >
> >- Avoid line break at 80 chars in strncmp(). We can replace strncmp by
> >   a new function that takes only two parameters, then avoid the line
> >   break.
> >
> >- Removed NFACCT_F_QUOTAS, it's only used once. We can introduce this
> >   later if we have more spots where we can use it.
> >
> >- Rename quota-bytes to bytes-quota and quota-packets to pkts-quota.
> >   The reason for this is that nfacct allows shortened syntax, eg.
> >
> >   nfacct l r
> >
> >which is actually 'list reset'. By swapping the words, we can now use:
> >
> >   nfacct l r p
> >
> >which only resets packet-based quotas.
> Thank you for collaboration,
> btw, I know about command line shortened syntax, but it also allows
> following:
> nfacct li res
> instead of nfacct list reset,
> and I was wonder bug it or not )

Just like iproute2:

# ip ad ls
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
...
