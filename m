From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU (Patrick McHardy)
Date: Sun, 16 Feb 2003 13:38:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E4F8660.5020409@trash.net>
References: <20030215232635.25928.78900.Mailman@kashyyyk>	<15950.60635.389199.836425@isis.cs3-inc.com>	<3E4F0881.70302@trash.net> <15951.10496.914173.716313@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
In-Reply-To: <15951.10496.914173.716313@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Don Cohen wrote:

>Patrick McHardy writes:
> > ... since the sender of an icmp fragmentation required includes the
>   max. mtu it can handle without fragmenting it is clear it is not to
>   be treated as only heuristic.
>This doesn't affect my argument of why it must be considered heuristic.
>
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=58084
>
>After reading this it seems to me that this NFS code (or possibly the
>kernel code it ends up using) is really to blame.  I don't even
>understand why it uses UDP, but that reference sounds like NFS is
>really just not prepared for packet loss.  Use of DF for PMTU
>discovery is fine but you have to be prepared for loss, including 
>the loss of the ICMP packets and you also have to be prepared for
>change of network conditions, inc. change of path or MTU.
>(Here we could get into another discussion of the role of ICMP in DoS 
>attacks, what people do about that, what they should do, etc.  Recall
>that ICMP replies are often rate limited, so an attacker can
>effectively block almost all of your ICMP replies.)+
>
rate-limiting icmp fragmentation required is just braindead.
inerestingly, it seems linux defragmentation is vulnerable to dos attack.
the evictor (called before defragmentation) just kills the oldest entry
of each hash slot, starting with 0 until memory is below
sysctl_ipfrag_low_thresh. by sending enough fragments 
(>sysctl_ipfrag_high_thresh)
which hash to the highest bucket you can stop reassembly of valid packets.

> 
>I think all code that tries to optimize packet size really has to
>view it as an ongoing (requiring continual monitoring, since things
>do change) heuristic hill climbing type of problem.
>
it does. nevertheless if a router sends "fragmentation required, max mtu 
xyz"
its is not the hosts duty to guess what the sender actually meant!

>
>As you point out, PMTU is a situation where a value slightly too low 
>is fine, slightly too high is terrible (like the old TV show "The
>price is right").  That already suggests appropriate heuristics.
>  
>
so what should the sender do ? send a few bytes less than announced ? 
maybe also
a few byte more .. why not also treat sequence/ack numbers as heuristic, 
after all
they may also be changed by nat ... ?

Patrick

PS: lets not get into further discussion about this.
