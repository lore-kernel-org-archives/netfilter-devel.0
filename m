From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -stable,3.4.y] netfilter: nf_conntrack: fix RCU race in
 nf_conntrack_find_get
Date: Fri, 6 Nov 2015 18:27:43 +0100
Message-ID: <20151106172743.GC1357@salvia>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <1446813886-5632-3-git-send-email-pablo@netfilter.org>
 <20151106170946.GD24185@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	Andrey Vagin <avagin@openvz.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Cyrill Gorcunov <gorcunov@openvz.org>,
	Ani Sinha <ani@arista.com>
To: Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37431 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161376AbbKFRUU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 12:20:20 -0500
Content-Disposition: inline
In-Reply-To: <20151106170946.GD24185@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 06, 2015 at 09:09:46AM -0800, Greg KH wrote:
> On Fri, Nov 06, 2015 at 01:44:45PM +0100, Pablo Neira Ayuso wrote:
> > From: Andrey Vagin <avagin@openvz.org>
> > 
> > [ upstream commit 6aec24dfd7548dba0134f60f28f58580f07c540b ]
> 
> Also not valid :(

This one you're right:

This should be c6825c0976fa7893692e0e43b09740b419b23c09 instead.

Sorry.
