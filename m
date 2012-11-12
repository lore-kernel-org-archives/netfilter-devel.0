From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 20:07:10 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121805330.23195@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:51177 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab2KLTHM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:07:12 -0500
In-Reply-To: <alpine.DEB.2.02.1211121805330.23195@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Chris,

On Mon, 12 Nov 2012, Chris Wilson wrote:

> On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:
> 
> > > > > But I'm sorry that you won't consider having a flag that changes
> > > > > MASQUERADE's behaviour to automatically change the source address in
> > > > > the conntrack entry.
> > > > 
> > > > I don't think changing the source address were a good solution: if
> > > > MASQUERADE could be changed to handle the cases then the wrong
> > > > conntrack entries should be deleted.
> 
> I'm not quite sure what you mean here. Are you saying that "invalid conntrack
> entries should be detected and deleted" or "changing MASQUERADE is pointless
> because if it would just delete conntrack entries that should not be
> deleted"?

What I meant was that instead of changing the IP address in the conntrack 
entry, it should simply be deleted and re-created.

> > > > But what would trigger the action? (Routing changed? I do not see such
> > > > a kernel event but I might missed it.) And more importantly, what would
> > > > identify the affected entries?
> [...]
> > An in-kernel "route changed" notification were great, because then we could
> > delete all MASQUERAD-ed entries where --update-source-address flag is set.
> 
> If we could register to receive routing changed events for SNAT source 
> addresses, that would be great (more efficient) but if the mechanism 
> does not yet exist, it would be much more difficult to create.

There's definitely no such an interface.
 
> I suppose that if we just deleted them all on any routing change, then that
> would solve the immediate problem for us. It would be ideal if incoming
> packets could still be directed to the correct internal source, but dropping
> them is a smaller problem than continuing to send out invalid packets and
> keeping a broken entry alive forever.
> 
> > > I propose that:
> > > 
> > > * when the packet matches an existing conntrack rule, and
> > > 
> > > * is sent out of an interface that does not list the packet's new
> > > (SNAT-to)
> > > source address as one of its IP addresses (i.e. if this were a new
> > > connection, MASQUERADE would not choose this source address), and
> > 
> > First, it'd mean a heavy checking for every matched packet.
> 
> Is it really so expensive to get the list of IP addresses for an interface
> and check down the list for presence of a given address? 

That'd mean that for *every* packet first the next routing hop should be 
calculated in netfilter too, then an IP address of the interface 
selected and then the old and the calculated addresses compared. For every 
packet, unconditionally, that's simply too much overhead.

> If so, perhaps that's a problem elsewhere in the kernel?

No, it's netfilter specific.
 
> > Second, there's no callback, whatsoever in the netfilter conntrack
> > framework which could execute this instruction set. And if such an
> > internal hook were added, that'd mean an unnecessary "check the hook and
> > call if exists" overhead for *every* other case.
> 
> Another option is to check, after routing, the source address that 
> MASQUERADE would have assigned to the packet. There must be a mechanism 
> for that, because we already do it for the first packet in the 
> connection, and it surely cannot be expensive. If it's different to the 
> current SNAT-to address in the conntrack, and the flag is set on the 
> conntrack, then update the conntrack.

The first packets are special: the (NAT) rules are evaluated for the very 
first packets only. Subsequent ones are looked up in the conntrack table 
and the nat table is completely skipped. As I wrote, there's no 
callback/hook by which such a functionality for MASQUERADE could be 
called. Also, SNAT/MASQUERADE is the very last action in netfilter.
 
> > > * the --update-source-address flag is set on the MASQUERADE target
> > > 
> > > then update the source address on the conntrack rule to the new one.
> > 
> > Why do you insist on updating the source address?
> 
> In these cases, the original source address is no longer valid. If we 
> delete the conntrack, we will just end up creating a new one for the 
> same packet. That results in more overhead and higher churn in the 
> conntrack table, but admittedly since the source address has changed, we 
> should probably treat the conntrack as UNREPLIED anyway, i.e. more like 
> a new fresh conntrack.

My concern is that there can for example be conntrack extensions attached 
to the conntrack entry, which may became broken if the IP address was
simply changed.
 
> Perhaps if we were to leave the old conntrack alone and just create a new
> one, then packets arriving from the peer destined to the old source address
> would still end up being forwarded to the local device, which could help to
> keep any existing connections kind-of alive (that might be seen as a bad
> thing as well).
> 
> > Should the --update-source-address be limited to UDP only?
> 
> I think the problem applies even more to portless protocols such as GRE.
> Devices have no choice to "change the source port" when making a new
> connection. Any packets that they send, will definitely keep a stale entry
> alive.
> 
> Thank you for considering and engaging with this proposal :)

It's an issue, which should be solved in MASQUERADE itself. The conntrack 
tool can be used to solve it, in theory. In practice it's not easy at all: 
a daemon should be run on the machine which catches the routing changes 
and then calls "conntrack".

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
