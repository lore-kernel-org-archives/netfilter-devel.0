From: Martijn Lievaart <m@rtij.nl>
Subject: Thinking about REJECT
Date: Thu, 03 Apr 2003 01:19:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8B7012.1060607@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Looking at the icmp type 3 code 13 discussion, the fake source patch 
(does anyone use that?) and my own experiences, I would like to propose 
an alternative to REJECT. As I see it, there are several problems with 
the current REJECT target:

- Not all icmp codes are supported
- Current code does not look at the packet it is rejecting, so it always 
sends a port unreachable. This is not RFC complient. F.i. tcp 
connections should be rejected with a tcp reset, unknown protocols may 
be rejected with a protocol unreachable.
- The kernel-userspace interface does not allow any changes

The major problem in my eyes is the port unreachable. Many OSses don't 
react very well to this for tcp connections. If one wants to reject, 
unknown protocols should be rejected with a protocol unreachable. Other 
situations should be investigated. Yes, I know one should drop instead 
of rejecting, but I feel that a reject target should 'do the right thing'.

I propose to include a new target that solves these problems. I'm 
willing to write that (actually I've already begun). This would mean 
that if this is succesful that REJECT would become deprecated in favor 
of the new target.

As I already indicated, and Harald confirmed, using DENY as a name for a 
new and better REJECT would not be a good idea. DENY in ipchains was 
renamed to DROP in iptables. So adding a DENY target would certainly 
cause confusion. Yet I'm hardpressed to come up with a better name. But 
then, I'm not a native english speaker.

What do people think of this proposal? If opinion is favorable, what 
would be a better name?

Goal:

- To write a better reject that, if used without parameters provides a 
(more) intelligent response to abort the connection request/packet.
- To be able to send back any icmp packet.
- The kernel-userspace interface should be written in such a way that it 
can accommodate future changes, within bounds. In particular, when 
sending icmp responses the interface includes the type, code and 32 bits 
(the 'gap' between type/code/checksum and the copied packet). This would 
facilitate adding new icmp messages when they are defined.

Current problems/questions:

- How about ipv6? I know next to nothing about ipv6 icmp.
- Is this list complete? I think that tcp-reset is the only exception, 
all other rejection messages may be sent by icmp.
- Are 32 bits (the gap between the type/code/checksum and the copy of 
the offending packet) enough to handle all situations?

I know that passing the raw icmp values between userside and kernel side 
is not the best of encapsulation. Yet encapsulation presumes higher 
level knowledge. All higher level knowledge I have now tells me there 
are no protocols that need more knowledge that those bits in the header, 
and encapsulating those higher levels would mean defining a more rigid 
interface. So this feels like a good compromise. But I still don't know 
all ins and outs of IP[2] so please correct me if I'm wrong.

Now for a lighter but still serious side. Iptables is fun. Hacking 
networks is fun. Hacking iptables was an instrument in those 
investigations. This made me think. Iptables is not just for building 
firewalls, it's also an instrument to whack on ip packets. Investigating 
ip networks is one of the things where iptables can help. Obviously, 
anyone going to such extremes can be expected to make custom arangements 
to their kernels. My own fragmentation needed patches (the trick of 
lowering mtu but setting a higher mss didn't work. bug?) are one example 
where I'm perfectly happy to run one box (actually an UML[0]) with 
patches exclusively for my own specific goals. Yet I recently 
encountered pmtud problems that these patches could fix[1], so my 
efforts where not completely accademic[well.... again 1]. Yet I think 
that iptables should be an instrument in this, if it does not interfere 
with the primary goal, firewalling. (That is, assuming firewalling is 
the primary goal.)

So what happens if we send back a source quench in reply to a connection 
attempt? Or a redirect? Not particularly useful, but if this new target 
supports this without taking anything away in usability or 
functionality, I think we should allow it. But obviously this should be 
a side effect, not a goal. The goal 'to send back any icmp packet' is to 
allow real functionality, even unforseen functionality. If it allows 
toying, all the better. If it allows investigating ip networks, that is 
a definate plus in my book. But I stress again, that the primary goal is 
to make a better REJECT, all else is secondary.

Even the fake source patch could be included, optionally adding an 
option to set the destination (source of icmp) address. This feels like 
a hack though, so I'm not sure about it.

BTW, I have written a patch to match on the DF bit, but am hessitant to 
sent it in. There is not much point in that without the ability to send 
back fragmentation needed packets. If this is rejected, I'll write a 
specific fragmentation-needed patch and submit them both.

Cheers,
Martijn Lievaart

[0] UML (user mode linux) is wonderful for kernel development. Using uml 
I was able to implement patches to iptables and test them. Kernel 
panics? Reboots? It's just a VM!
[1] Unfortunately, using a linux box is out of the question in this 
particular instance. The problems where solved using a cisco route-map 
to turn of DF bits. In fact, using a linux box instead of a cisco would 
have solved all the problems as the cisco did not nat the icmp 
fragmentation-needed packets correctly where iptables would have. Ah, 
life sucks and company policy sucks harder. Especially because  the 
particular cisco is used to connect to a couple of linux boxes :-|
[2] Every time I think 'now I know all the basics of tcp/ip' something 
comes along and shakes at those foundations. Points in case, 
weak-ended/strong-ended hosts (twice!), redirects and dot-1-q. Why 
redirects? Because something alters your routing table without a routing 
deamon running. Why dot-1-q? Because of the implementations it has if it 
makes many networks end up at one interface of your firewall.
