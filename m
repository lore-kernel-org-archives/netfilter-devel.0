From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [stable-3.7 00/14] netfilter stable fixes for 3.7
Date: Fri, 1 Feb 2013 17:25:57 +0100
Message-ID: <20130201162556.GA4908@localhost>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
 <20130201123436.GA31102@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, davem@davemloft.net,
	netfilter-devel@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:40928 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754598Ab3BAQ0F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:26:05 -0500
Content-Disposition: inline
In-Reply-To: <20130201123436.GA31102@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Greg,

On Fri, Feb 01, 2013 at 01:34:36PM +0100, Greg KH wrote:
> On Mon, Jan 28, 2013 at 08:31:19PM +0100, pablo@netfilter.org wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > This patchset contain netfilter stable fixes for 3.7, original
> > commits (in no particular order) are:
> > 
> > 0c36b48 netfilter: nfnetlink_log: fix mac address for 6in4 tunnels
> > e035edd netfilter: nfnetlink_log: fix possible compilation issue due to missing include
> > 665e205 netfilter: xt_recent: fix namespace destroy path
> > 2727de7 netfilter: xt_recent: avoid high order page allocations
> > 5b76c49 netfilter: x_tables: print correct hook names for ARP
> > 4fe198e netfilter: ipset: Fix range bug in hash:ip,port,net
> 
> This patch didn't apply as a straight 'git cherrypick', so I didn't take
> it.  You also didn't send it, so something is odd here.

My fault, sorry, that slipped through the list but it should be this
instead:

6bbc7f3 netfilter: xt_CT: fix unset return value if conntrack zone are disabled

http://patchwork.ozlabs.org/patch/216343/

I send it to you as patch 11/14.

I can resend it if that makes things easier.

> > c6f4089 netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP reset
> > 32263dd netfilter: xt_hashlimit: fix namespace destroy path
> > 0918184 netfilter: xt_hashlimit: fix race that results in duplicated entries
> > 1310b95 netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect
> > 97cf00e netfilter: nf_ct_reasm: fix conntrack reassembly expire code
> > 10db906 netfilter: xt_CT: recover NOTRACK target support
> > 757ae31 netfilter: fix missing dependencies for the NOTRACK target
> > 1e47ee8 netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns
> > 
> > Please, apply. Thanks!
> 
> In the future, please put the git commit ids in the patches you send, I
> had to match them up by hand and put them into the patch.

Will do that in the future, thanks!
