From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: RE: IPSEC and NAT
Date: Fri, 15 Oct 2004 22:09:48 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1097892588.2748.84.camel@localhost>
References: <200410152203.i9FM3kMc029703@nmibwkms1.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Emiel Mols <emiel@fulgor-hosting.nl>
In-Reply-To: <200410152203.i9FM3kMc029703@nmibwkms1.nexusmgmt.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Well, then I suppose it would depend on exactly what the problem is. 
I'm quite new to the 2.6 IPSec implementation so I might be quite wrong
but I will share my thoughts.

If the problem is just that the ESP packets (I assume that's what you
are using) need to be from the one address, I would think the solution
is quite simple.  The SA and SP will define the end points just as they
are - using your assigned address.  The SP would change the inside
source to your subnet rather than your external IP address.

If the problem is that the SP on the other side will only allow the
decrypted packet to be from the one assigned IP, then, I would think,
you have some limitations.  I would think that you could initiate
traffic into the tunnel from your side.  I would not think that you
could initiate traffic from the other side.

I had briefly looked into this for my work on the ISCS network security
management project (http://iscs.sourceforge.net) because we use the
*swan virtual interfaces to implement the technology that allows us to
use out-of-band forms of user authentication throughout the entire VPN
WAN.  I recall that the initial implementation of the 2.6 IPSec only
passed through the netfilter hooks once.  Thus, by the time it hit the
POSTROUTING chain of the nat table, it was already encrypted and that
would break your scenario.  However, I think that has either been
changed, is in the process of being changed or is changed by a PoM
patch.  I'm sure someone on this list can clarify that.  The idea of the
change is that the packet would be processed completely once unencrypted
and then completely again encrypted.

If that is the case then you should be able to SNAT the packet and then
encrypt it.  The part where I'm a little hazy (I've never tried this) is
how to tell the kernel to encrypt the packet after SNAT.  I would think
one needs an SP which defines both internal addresses, i.e., the
internal addresses of both sides of the connection.  Here is where my
knowledge runs thin so I'll just spew ideas in the hope that someone
more knowledgeable will correct me and we'll all learn.

If your original address is a.a.a.a/n and the other side is z.z.z.z/n
and your assigned address is b.b.b.b, the other side will have a
Security Policy between b.b.b.b and z.z.z.z/n.  If you define an SP on
your side between a.a.a.a/n and z.z.z.z/n, I would think that sets the
stage for netfilter to pass the packet to IPSec for encryption and a
second pass through netfilter.  However, I think the phase II
negotiation will fail because your policy is a.a.a.a/n <-> z.z.z.z/n and
the other side is b.b.b.b <-> z.z.z.z/n.

If you create an SP of b.b.b.b <-> z.z.z.z/n on your side, since the
packet did not start processing as b.b.b.b until after its first pass
through netfilter, I do not know if netfilter would know that it has to
be passed to IPSec for encryption.

I wonder if you could create an SP of 0.0.0.0/0 <-> z.z.z.z/n.  I think
this would tell netfilter to send any packets for z.z.z.z/n to IPSec and
give you the chance to change the source address before it hits IPSec. 
My question would be what happens during phase II negotiation.  Do the
SPs have to match exactly in which case 0.0.0.0/0 <-> z.z.z.z/n does not
match b.b.b.b <-> z.z.z.z/n? Or does it just not need to conflict in
which case b.b.b.b <-> z.z.z.z/n is contained within 0.0.0.0/0
<->z.z.z.z/n, does not conflict and would thus result in a successful
phase II? I'd imagine if anyone in the world knows that answer, they are
on this mailing list :-)

I think you're out of luck for traffic initiated from the other side as
it would have no idea of where to send the decrypted packet.

This must surely be a case of the blind leading the sight impaired! I
hope it has at least sparked some useful thoughts in your mind - John

On Fri, 2004-10-15 at 18:03, Emiel Mols wrote:
> Well, I only control one end of the link :). This one ip address is assigned
> to me and I have to find a way to NAT it :(.
> 
> netfilter-devel@lists.netfilter.org
> -----Original Message-----
> From: John A. Sullivan III [mailto:john.sullivan@nexusmgmt.com] 
> Sent: zaterdag 16 oktober 2004 0:02
> To: Emiel Mols
> Cc: netfilter-devel@lists.netfilter.org
> Subject: Re: IPSEC and NAT
> 
> On Fri, 2004-10-15 at 14:00, Emiel Mols wrote:
> > Hi,
> > 
> >  
> > 
> > I've managed to setup a host-to-net ipsec connection with a remote network
> > on a linux router using (ported) isakmpd and kernel 2.6.8.1. However, I
> want
> > to be able to 'share' this ipsec connection with the rest of the network,
> > but since no ipsecn virtual interface is created in the 2.6 kernels I
> can't
> > use ordinary SNAT/MASQUERADE targets in iptables: ipsec packets get
> > encrypted before entering the POSTROUTING table :(, so the source address
> of
> > the encapsulated packet can't be changed anymore. I've read
> >
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-January/thread.htm
> > l#13879, but the supplied patch doesn't work very well.
> > 
> >  
> > 
> > Does anyone have any suggestions on how to get this working?
> <snip>
> I may be a bit tired at the end of a long week and have thus missed your
> point . . . but why not set it up as a net-to-net connection? - John
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
