From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] superfluous skb->nfct check in br_nf_dev_queue_xmit
Date: Mon, 28 Apr 2014 15:16:46 +0200
Message-ID: <20140428131646.GP31953@breakpoint.cc>
References: <534FB7D2.3020705@parallels.com>
 <53535C35.7070108@parallels.com>
 <20140424163243.GN31953@breakpoint.cc>
 <535E4B74.4050107@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	bridge@lists.linux-foundation.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Saikiran Madugula <hummerbliss@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46082 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395AbaD1NRA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:17:00 -0400
Content-Disposition: inline
In-Reply-To: <535E4B74.4050107@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin <vvs@parallels.com> wrote:
> We got report about problem on RHEL6-based OpenVZ kernel:
> large UDP and ICMP packets was dropped on bridge without incrementing of any failcounters.
> Connection tracking was disabled on this node , nf_conntrack module was unloaded
> Ftrace pointed that it was happen because nfct check.

Right.  If you unload the conntrack module this bug triggers
since nf_defrag_ipv4 will still defragment ipv4 packets (and
thus needs refragmentation).

> Therefore I believe that my patch is still correct, however now I think we also need 
> to remove #if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4) in br_nf_dev_queue_xmit().

I don't think so, DEFRAG_IPV4 is dependency glue, so it shouldn't be
possible to build kernel with CONNTRACK_IPV4=n and DEFRAG_IPV4=(m|y).

Could you please formally submit your patch for inclusion in nf.git?
For some reason I don't see your patch in
http://patchwork.ozlabs.org/project/netfilter-devel/list/

Thanks!
