From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] superfluous skb->nfct check in br_nf_dev_queue_xmit
Date: Thu, 24 Apr 2014 18:32:43 +0200
Message-ID: <20140424163243.GN31953@breakpoint.cc>
References: <534FB7D2.3020705@parallels.com>
 <53535C35.7070108@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	bridge@lists.linux-foundation.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Saikiran Madugula <hummerbliss@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37992 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758390AbaDXQc6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:32:58 -0400
Content-Disposition: inline
In-Reply-To: <53535C35.7070108@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin <vvs@parallels.com> wrote:
> Please do not apply my patch, probably it breaks processing of VLAN packets.

Why would it break VLAN?
In fact, the same dicussion came up couple of days back and I think the
nfct test is wrong.  There is no guarantee that skb->nfct == NULL means
that packet was not defragmented via nf_defrag (e.g. rror in l4 protocol
tracker, nf_defrag_ipv4 loaded but no nf_conntrack_ipv4)

For ipv6 its even worse since we toss all ipv6 defragmented packets...
