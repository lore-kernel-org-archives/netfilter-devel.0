From: Bryan Ford <baford@mit.edu>
Subject: Re: New draft document on nat / traversal / hole punching (with Dan
	Kegel)
Date: Wed, 17 Nov 2004 11:33:27 -0500
Message-ID: <200411171133.27737.baford@mit.edu>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<200411161538.48528.baford@mit.edu>
	<1100663932.5176.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, srisures@yahoo.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>, dank@kegel.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1100663932.5176.48.camel@localhost.localdomain>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 16 November 2004 22:58, Rusty Russell wrote:
> Consider two machines A and B being NATed through N to servers Sa, Sb
> and Sc respectively (rule says NAT source to N):
>
> 	A:45000 -> Sa:80  <=>  N:45000 -> Sa:80 (rule 3)
> 	B:45000 -> Sb:80  <=>  N:45000 -> Sb:80 (rule 3)
> 	A:45000 -> Sc:80  <=>  N:45000 -> Sc:80 (rule 2)
> 	B:45000 -> Sc:80  <=>  N:45001 -> Sc:80 (rule 2 clash, rule 4)

Ah!  Now I understand what you're getting at.  The problem is that this NAT 
design does not implement a true cone NAT at all, and therefore from a P2P 
perspective has more basic problems that essentially make the hairpin 
translation issue moot.  The fundamental problem is that after the NAT has 
opened the first two sessions above, allowing two different source endpoints 
to share the same translated NAT port, the NAT has already "painted itself 
into a corner" and made it impossible to preserve either source endpoint's 
identity when either endpoint attempts to communicate with other hosts - as 
your example eloquently illustrates.

Suppose for example that A:45000 and B:45000 are both P2P apps that have 
established connections to two different P2P "rendezvous servers" Sa and Sb, 
respectively, causing the first two connections to be opened just as above:

 	A:45000 -> Sa:80  <=>  N:45000 -> Sa:80 (rule 3)
 	B:45000 -> Sb:80  <=>  N:45000 -> Sb:80 (rule 3)

Now suppose A and B both want to open connections with a third host C, which 
may be NATted, and therefore hole punching is required.  Say A gets lucky and 
gets there first; the NAT establishes a third session, which according to 
your rules above will happen to preserve the source port's identity:

 	A:45000 -> C:80  <=>  N:45000 -> C:45000 (rule 2)

C will similarly try to send a ping back to A at N:45000, and as soon as each 
client's ping has reached the respective NAT, a pair of corresponding holes 
is open and regular communication can proceed.

But now B also wants to talk to C, and because the NAT has already painted 
itself into a corner by making A's and B's rendezvous connections share the 
same NAT port, the NAT has no possibility of preserving the identity of B's 
source port.  Instead the NAT establishes the following session, which breaks 
the cone NAT rule:

 	B:45000 -> C:80  <=>  N:45001 -> C:45000 (rule 2)

Now when B and C try to hole punch a communication session open to each other, 
C assumes that it can reach B at N:45000 because that is B's public port as 
far as B and Sb can determine.  But the NAT will only forward traffic from C 
if it comes to port N:45001, and there's no way B or Sb could determine this 
fact without direct knowledge or cooperation with the NAT.

In practice, this design may be even more "P2P-unfriendly" than a typical 
symmetric NAT that just always bumps the port number by 1 when a new session 
is opened.  In the always-bump-by-1 case, at least the change is relatively 
predictable, and more sophisticated hole punching algorithms are already able 
to detect this behavior and establish P2P connections across such NATs with 
moderate reliability.  The NAT behavior you describe, however, makes things 
even more unpredictable: your NAT will look to the application like a cone 
NAT sometimes, but can at times mysteriously and inexplicably switch to a 
symmetric NAT as a result of the independent actions of other nodes elsewhere 
on the private network.

> The reason I implemented NAT this way (back in 1998/99) was that not
> disturbing port numbers avoided breaking a number of protocols.  It also
> turns out that overloading the ports also allows more connections than
> 65535 * number of IP addresses.

Yes, I'm aware of these considerations.  As far as the first one goes, it's 
certainly a good thing to be able to make NAT-unaware legacy protocols keep 
working "most of the time" whenever possible, but as your example above 
demonstrates it's often simply not possible to preserve the source port 
number in real-world situations, so the "preserve source port" rule at best 
works some of the time and does not represent a viable long-term strategy for 
making NATs and apps get along together reliably.  One appropriate solution I 
can think of would be to migrate the NAT to a P2P-friendly, true cone NAT 
model, but retain the above, P2P-unfriendly but "source port preserving when 
possible" strategy only for the specific legacy protocols that we care about 
and are known to work better under that strategy.  The NAT could determine 
the connection strategy simply by looking up the destination port number in a 
table of well-known port numbers for these legacy protocols, for example.  
Ideally this would be configurable, of course, but any unknown port should 
default to providing true cone NAT behavior, because otherwise there will 
never be a fully reliable way new NAT-aware apps can make P2P connections 
across NATs.

As for the second consideration, first note that true cone NATs can still 
potentially support more than (65535 * # IP addrs) connections - the actual 
limitation is that they can only support (65535 * # IP addrs) separate 
_internal endpoints_ at once.  For example, if N is a true cone NAT, then 
A:45000 can use the port N:45000 to talk to as many external endpoints as it 
wants, and all those connections will re-use the same public port, and thus 
only consume one port in the NAT's port space.  Since this is the typical 
behavior of P2P applications, you could say that not only are cone NATs 
P2P-friendly, but P2P apps are also "cone-NAT-friendly" because they make 
reasonably sparing use of the NAT's public port space by re-using the same 
source port.

Traditional client/server apps are another matter, of course: since the common 
behavior is for the client to allocate a new port number for every new 
connection, in practice a cone NAT is indeed limited to (65535 * # IP addrs) 
separate client/server connections at once, and I agree that that could be a 
problem in some cases.  One solution is, once again, to make the NAT's 
behavior depend on the protocol in a configurable fashion: for example, it 
might use the symmetric NAT behavior for popular, well-known client/server 
protocols such as HTTP that are known not to need the cone NAT property, but 
provide the cone NAT property by default for other, unknown protocols.  A 
cone NAT's limitation on number of simultaneously active internal ports is 
only ever likely to be a problem anyway for highly popular, well-known 
protocols using standard port numbers.

On a related note - in the first public version of our P2P-over-middleboxes 
draft, we proposed a new IP header option that would allow apps to indicate 
explicitly to NATs in the path whether they required cone NAT behavior or 
whather symmetric NAT behavior would be acceptable.  Part of the motivation 
for proposing this IP option was specifically the resource management concern 
you described.  We dropped it from future drafts because we encountered 
immediate resistance to "inventing anything new protocols" related to NATs, 
and it was seen as outside the scope of the draft.  But the idea could be 
resurrected in the future if there turns out to be a need for it.    You can 
find the original proposal in Section 4 at the following link:

http://www.brynosaurus.com/pub/net/draft-ford-midcom-p2p-00.txt

For now, though, I would propose that we first just try to make it possible 
for P2P apps to work reliably over NATs, and then deal later with any port 
space limitation issues if and when they actually arise.

> I hope that explains?  We're going to have to think hard about changing
> to a port reservation architecture if we really want the hairpin
> feature.

Yes, I agree - and I hope it's clear now that it's not just about the hairpin 
feature, but about reliably supporting hole-punching in general, even in the 
standard single-level NAT case.

Thanks,
Bryan
