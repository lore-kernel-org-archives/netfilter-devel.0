From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet
 classifier
Date: Wed, 23 May 2018 14:44:42 -0400 (EDT)
Message-ID: <20180523.144442.864194409238516747.davem@davemloft.net>
References: <152699741881.21931.11656377745581563912.stgit@alrua-kau>
        <152699745846.21931.4558451708304709296.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: toke@toke.dk
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <152699745846.21931.4558451708304709296.stgit@alrua-kau>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>
Date: Tue, 22 May 2018 15:57:38 +0200

> When CAKE is deployed on a gateway that also performs NAT (which is a
> common deployment mode), the host fairness mechanism cannot distinguish
> internal hosts from each other, and so fails to work correctly.
> 
> To fix this, we add an optional NAT awareness mode, which will query the
> kernel conntrack mechanism to obtain the pre-NAT addresses for each packet
> and use that in the flow and host hashing.
> 
> When the shaper is enabled and the host is already performing NAT, the cost
> of this lookup is negligible. However, in unlimited mode with no NAT being
> performed, there is a significant CPU cost at higher bandwidths. For this
> reason, the feature is turned off by default.
> 
> Cc: netfilter-devel@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>

This is really pushing the limits of what a packet scheduler can
require for correct operation.  And this creates an incredibly
ugly dependency.

I'd much rather you do something NAT method agnostic, like save
or compute the necessary information on ingress and then later
use it on egress.

Because what you have here will completely break when someone does NAT
using eBPF, act_nat, or similar.

There is even skb->rxhash, be creative :-)
