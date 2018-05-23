From: David Miller <davem@davemloft.net>
Subject: Re: [Cake] [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to
 packet classifier
Date: Wed, 23 May 2018 16:04:03 -0400 (EDT)
Message-ID: <20180523.160403.20551254565100734.davem@davemloft.net>
References: <152699745846.21931.4558451708304709296.stgit@alrua-kau>
        <20180523.144442.864194409238516747.davem@davemloft.net>
        <91739F64-20B7-4C56-A7A3-AB8C71B9437C@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: toke@toke.dk, cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: chromatix99@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <91739F64-20B7-4C56-A7A3-AB8C71B9437C@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jonathan Morton <chromatix99@gmail.com>
Date: Wed, 23 May 2018 22:31:53 +0300

> Remember that it takes two different qdiscs to implement ingress and
> egress on the same physical interface, and there's no obvious
> logical link between them - especially since the ingress one has to
> be attached to an ifb, not to the actual interface, because there's
> no native support for ingress qdiscs.

Who said anything about using an ingress qdisc to record/remember
this information?
