From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Tue, 28 Oct 2003 11:09:42 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031028190942.92198.qmail@web13908.mail.yahoo.com>
References: <200310280002.12023.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200310280002.12023.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Caught this in the middle, so not sure all the
details...is this concerning the ebtable bridge patch?
If I uses the QUEUE target in PREROUTING to packet
mangle, is there an issue since I think PF_BRIDGE
comes after that?
-Scott

--- Bart De Schuymer <bdschuym@pandora.be> wrote:
> On Monday 27 October 2003 09:04, David S. Miller
> wrote:
> > I thought we were taking care of this stuff via
> other means?
> >
> > This problem feels like an old one to me, and it's
> why we added all
> > the bridge netfilter objects to struct sk_buff,
> right?  Why doesn't
> > that take care of this instance of the problem?
> 
> The thing is, we currently only copy the Ethernet
> header to 
> skb->nf_bridge->data at PF_BRIDGE/POST_ROUTING. So,
> if the queue happens 
> earlier, the Ethernet header is lost.
> Another solution is not trusting the iptables
> modules and doing the copy to 
> skb->nf_bridge->data earlier at
> PF_BRIDGE/PRE_ROUTING and 
> PF_BRIDGE/LOCAL_OUT. After each faked PF_INET hook
> we'd have to copy the 
> skb->nf_bridge->data back to the Ethernet header
> since we don't trust the 
> iptables modules.
> This is doable, but kind of ugly and I'd prefer the
> explicit copy by the 
> iptables module itself. Most iptables modules don't
> copy skb's around anyway. 
> One could argue that this makes the iptables
> ip_queue module a tiny bit slower 
> when dealing with non-bridged traffic, but if the
> user compiled her kernel 
> with bridge_netfilter support one would think she
> needs it.
> But I'll change it if anyone objects to the easy
> fix.
> 
> cheers,
> Bart
> 
> 


__________________________________
Do you Yahoo!?
Exclusive Video Premiere - Britney Spears
http://launch.yahoo.com/promos/britneyspears/
