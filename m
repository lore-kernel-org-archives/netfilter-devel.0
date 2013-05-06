From: Patrick McHardy <kaber@trash.net>
Subject: Re: Allow DNPT target from raw table?
Date: Mon, 6 May 2013 22:21:01 +0200
Message-ID: <20130506202101.GB6025@macbook.localnet>
References: <2531686.RPhsabGAWo@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45821 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3EFUVF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 16:21:05 -0400
Content-Disposition: inline
In-Reply-To: <2531686.RPhsabGAWo@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 06, 2013 at 04:38:19AM +0200, Oliver wrote:
> Hi all,
> 
> Currently, the DNPT target is restricted to the mangle table; this means that 
> it is effectively impossible to utilise NPT in tandem with conntrack since it's 
> impossible to rewrite the destination prefix prior to conntrack taking a look 
> at the skb.
> 
> Please consider allowing the use of DNPT from the raw table so that it's 
> possible to do prefix translation without having to forego the benefits of 
> conntrack.

The raw table doesn't have a POSTROUTING chain, which is where SNPT is
performed on order to catch both local and forwarded traffic.

If you're using conntrack anyways, why use NPT? The main benefit is that
you don't have to use conntrack.
