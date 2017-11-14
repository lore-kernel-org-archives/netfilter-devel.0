From: Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [PATCH RFC,WIP 0/5] Flow offload infrastructure
Date: Mon, 13 Nov 2017 16:52:44 -0800
Message-ID: <20171113165244.153915ef@cakuba>
References: <20171103152636.9967-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171103152636.9967-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri,  3 Nov 2017 16:26:31 +0100, Pablo Neira Ayuso wrote:
> I'm measuring here that the software flow table forwarding path is 2.5
> faster than the classic forwarding path in my testbed.
> 
> TODO, still many things:
> 
> * Only IPv4 at this time.
> * Only IPv4 SNAT is supported.
> * No netns support yet.
> * Missing netlink interface to operate with the flow table, to force the
>   handover of flow to the software path.
> * Higher configurability, instead of registering the flow table
>   inconditionally, add an interface to specify software flow table
>   properties.
> * No flow counters at this time.
> 
> This should serve a number of usecases where we can rely on this kernel
> bypass. Packets that need fragmentation / PMTU / IP option handling /
> ... and any specific handling, then we should pass them up to the
> forwarding classic path.

I didn't realize it from this patch set, but it was mentioned at the
conference that this patch set is completely stateless.  I.e. things
like TCP window tracking are not included here.  IMHO that's a big
concern, because offloading flows is trivial when compared to state
sync.  IMHO state sync is *the* challenge in implementing connection
tacking offload...
