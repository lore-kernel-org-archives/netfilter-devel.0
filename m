From: marian stagarescu <marian@ti.com>
Subject: Re: how to flush ip conntrack entries ?
Date: 14 Oct 2002 15:24:49 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034623489.9554.43.camel@gt4rvnd11.telogy.design.ti.com>
References: <3DA48D59.7060109@secureinteriors.com>
	<20021009204018.GA15171@oknodo.bof.de>
	<1034200544.30113.140.camel@gt4rvnd11.telogy.design.ti.com>
	<3DAA16D8.8070201@snapgear.com>
	<1034623247.9526.41.camel@gt4rvnd11.telogy.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: marian stagarescu <marian@ti.com>
In-Reply-To: <1034623247.9526.41.camel@gt4rvnd11.telogy.design.ti.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

i see these entries under tcp window tracking patch
i'll give it a try.

On Mon, 2002-10-14 at 15:20, marian stagarescu wrote:
> hi philip,
> thanks for you answer.
> 
> yes ifconfig up/down works but i wanted to make it work without doing
> this.
> 
> i noticed that the ipsysctl tutorial 1.0.0 (posted to the list by askar)
> documentation points to a /proc/sys/net/ipv4/netfilter entry with an 
> ip_ct_generic_timeout 
> and ip_ct_icmp_timeout
> i don't have those into my kernel (2.4.17 patched with newnat13 and
> userland iptables 1.2.6a), maybe someone on the list can tell me which
> patch installs these entries.
> having those i can try to set to zero the above
> ip_ct_icmp_timeout
> 
> marian
> 
> 
> 
> On Sun, 2002-10-13 at 20:59, Philip Craig wrote:
> > marian stagarescu wrote:
> > > looking at the ip_conntrack proc entry it was noticed that:
> > > 
> > > after flushing (step 2) an UNREPLIED entry for icmp is there
> > > (no reply hence unreplied) but its ttl does not decrement.
> > > (ping echos are still hitting the nat box from private side)
> > 
> > Normally icmp conntrack entries are deleted as soon as there
> > is a reply.  Once you remove the MASQ rule though, there is no
> > reply, so the conntrack stays around.  Any subsequent packets
> > from the same ping process will match this conntrack, and thus
> > be NATed exactly the same way.  Adding the MASQ rule back in
> > does not affect the existing conntrack.
> > 
> > > stoping the ping (step 4) allows the ttl timer of the conntrack entry 
> > > to start decrementing (30 sec)
> > 
> > The timer doesn't seem to decrement while the ping is still
> > going because the ping packets are matching the conntrack and
> > refreshing the timer back to 30 seconds.  Stop the ping and the
> > timer is no longer refreshed.
> > 
> > > restaring the pings (i don't have to wait till ttl goes to zero ?!?)
> > > (step 5) but now with nat back on (step 3) I don;t get the icmp entry on
> > > conntrack but all is ok (pings goes thru).
> > 
> > When you start a new ping process, the ping packets have a new
> > id, and so they don't match the old conntrack.  A new conntrack
> > is created, and the new MASQ rule is used to masquerade them
> > correctly.  You get a ping reply now, and so the conntrack is
> > immediately deleted, which is why you don't see it.
> > 
> > > question is: is there a way to achieve this (looks like start
> > > decrementing that ttl or reseting it to zero in conntrack) in the nat
> > > box without having to stop the pings on the host side ?
> > 
> > You can flush conntrack entries for masqueraded connections
> > by doing either a down/up or ip addr add/del on the associated
> > interface.  This probably won't help you in this case though
> > because the problem conntrack is not masqueraded.  I don't
> > know of any other ways of flushing conntracks.
> > 
> > Regards
> > -- 
> > Philip Craig     Software Engineer     http://www.SnapGear.com
> > philipc@snapgear.com  Ph: +61 7 3435 2821  Fx: +61 7 3891 3630
> > SnapGear  -  Custom Embedded Solutions and Security Appliances
> 
