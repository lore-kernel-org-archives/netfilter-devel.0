From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables and external processes
Date: Wed, 18 Feb 2004 05:57:41 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402180552310.10256-100000@filer.marasystems.com>
References: <1077060658.2011.19.camel@ca.gts.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allen Francom <aef@prismnet.com>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1077060658.2011.19.camel@ca.gts.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, John A. Sullivan III wrote:

> That's where the packet processing comes in.  We know what we have to do
> to have iptables confirm that the packet is not spoofed and to track the
> NAT.  We just needed to find a way to pass that decision back to
> iptables to know whether to pass the packet on to the chains that were
> built in the pre-authentication or to drop the packet as a spoof. 
> Assuming that I have the client part and logic straight, does this seem
> feasible? I take from the little I read about QUEUE that this is quite
> possible.  Thanks again - John

Nothing of what you have said indicates QUEUE can not be used from what I 
can tell.

The main complication is that once you have processed the QUEUE:ed packet
in userspace, the verdict set by the userspace is final for this hook. But
this is rarely a problem. In most cases you can duplicate the little extra
rules needed if any in the userspace, or have the QUEUE called from
another hook running before your firewall hook (i.e. mangle).

Also, if you need to modify NAT rules while processing the packet in
userspace then you must call QUEUE from mangle PREROUTING as this is the
only hook which is executed before NAT.

Regards
Henrik
