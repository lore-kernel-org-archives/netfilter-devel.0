From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: iptables and external processes
Date: Wed, 18 Feb 2004 01:20:36 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077085236.2010.31.camel@ca.gts.nexusmgmt.com>
References: <Pine.LNX.4.44.0402180552310.10256-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Allen Francom <aef@prismnet.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402180552310.10256-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-02-17 at 23:57, Henrik Nordstrom wrote:
> On Tue, 17 Feb 2004, John A. Sullivan III wrote:
> 
> > That's where the packet processing comes in.  We know what we have to do
> > to have iptables confirm that the packet is not spoofed and to track the
> > NAT.  We just needed to find a way to pass that decision back to
> > iptables to know whether to pass the packet on to the chains that were
> > built in the pre-authentication or to drop the packet as a spoof. 
> > Assuming that I have the client part and logic straight, does this seem
> > feasible? I take from the little I read about QUEUE that this is quite
> > possible.  Thanks again - John
> 
> Nothing of what you have said indicates QUEUE can not be used from what I 
> can tell.
> 
> The main complication is that once you have processed the QUEUE:ed packet
> in userspace, the verdict set by the userspace is final for this hook. But
> this is rarely a problem. In most cases you can duplicate the little extra
> rules needed if any in the userspace, or have the QUEUE called from
> another hook running before your firewall hook (i.e. mangle).
> 
> Also, if you need to modify NAT rules while processing the packet in
> userspace then you must call QUEUE from mangle PREROUTING as this is the
> only hook which is executed before NAT.
> 
> Regards
> Henrik

Hmmm . . . that could get a little complicated.  Where the packets are
processed in the flow is critically important.  Ideally, it should
intercept them from FORWARD or INPUT in the filter table and then jump
them to a user defined chain in the filter table if they are not
dropped.  In fact, it really should not drop them at all; it should
either jump them to the dynamically created user defined chains or
return them to the FORWARD or INPUT chain where they will encounter a
DROP policy.

I can't merely create those dynamic chains in userspace because those
chains will jump to other, pre-existing, user-defined chains.

It sounds like this would be a problem using QUEUE.  Have I understood
you correctly? Thanks - John
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
