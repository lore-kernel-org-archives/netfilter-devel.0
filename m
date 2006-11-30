From: "Ben Grimm" <bengrimm@gmail.com>
Subject: re: RFC1812 and CLUSTERIP
Date: Thu, 30 Nov 2006 09:36:17 -0600
Message-ID: <f48de3840611300736t73263531ib72b139e316324dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi Oskar,

I found myself in this situation -- and if it weren't for your message
I wouldn't have
figured it out.  Using tcpdump, I can see the router (not sure of the
brand) sending
arp requests, and one of the nodes in the cluster responding, but the
router apparently
ignores that response.  Other hosts in the same segment as the
clustered ip address
use the multicast mac address, but the router just keeps asking who
has the ip.

I would agree that this should definitely be noted in the netfilter
documentation.

There is another method: http://www.ultramonkey.org/papers/active_active/
It doesn't go against the RFC since it uses regular mac addresses.
But it fools the
switch by preventing it from tying the mac address to a particular port.

Ben



> Hi Patrick,
>
> It seems to me that the CLUSTERIP target relies on multicast mac to
> receive packets to several hosts at the same time. Without it, only a
> single machine would actually get the data? According to RFC 1812, as
> you could see in the snippet, this seems to be a prohibited behavior,
> more or less.
>
> According to the RFC 1812 snippet below, it is prohibited for a router
> to handle or believe in ARP replies from another (in this case) host
> that basically says, send data for this host ip address to this
> multicast mac address.
>
> If a router is perfectly RFC 1812 compliant, it should to my
> understanding simply not send the packets to the host in this case. It
> does however not state what to do with the packets from what i've seen.
>
> I guess this isn't a big deal yet (maybe never, who knows), but I'd
> wander and make a guess that it would be a bugger to try and find out
> what the hell is going on if you actually did find yourself in the
> situation?
>
> How about either document that the (possible) problem exists,
> alternatively to write some kind of check for iptables to only allow
> multicast ip addresses together with the CLUSTERIP target? Since the
> second suggestion probably will break some users implementations, i'd at
> least suggest documenting it and/or give off a warning if people do it?
>
> On Thu, 2006-10-26 at 00:26 +0200, Patrick McHardy wrote:
> > Oskar Andreasson wrote:
> > > Hi all again,
> > >
> > > I've snowed in on the CLUSTERIP target to some extent, and I am still
> > > figuring it out to some extent.
> > >
> > > One question that came to mind is its use of multicast MAC addresses. Is
> > > it really allowed to make use of them in the way that it is right now?
> > >
> > > From RFC 1812 section 3.3.2:
> > >
> > > ------
> > >    A router MUST not believe any ARP reply that claims that the Link
> > >    Layer address of another host or router is a broadcast or multicast
> > >    address.
> > > ------
> > >
> > > As I understand it, this is exactly what the CLUSTERIP target does?
> > > Behaves as if a single host has a multicast address?
> >
> > I'm not too familiar with the CLUSTERIP target, what behaviour
> > exactly are you refering to?
>
