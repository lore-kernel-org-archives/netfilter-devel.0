From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables and external processes
Date: Tue, 17 Feb 2004 23:05:30 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402172303080.3844-100000@filer.marasystems.com>
References: <1077054112.2020.12.camel@ca.gts.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1077054112.2020.12.camel@ca.gts.nexusmgmt.com>
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

> It would solve a very difficult problem for us if we could jump a packet
> to a chain based upon the decision of a process external to iptables. 
> In other words, a packet enters the FORWARD or INPUT chains, encounters
> a rule that queries a running process.  The process extracts some
> information from the IP header and returns true or false.  iptables then
> either matches the packet if true and passes the packet to the next rule
> if false.  This sounds like the exact sort of thing a POM extension
> would do.

The QUEUE function is pretty similar to this. Only difference is that the 
verdict from QUEUE is final for the hook.

Implementing a function where iptables is suspended in the middle waiting 
for results from userspace is non-trivial and I am not sure it is at all 
a feasible thing to do.

Is there any reason to why QUEUE not sufficient for your application?

Regards
Henrik
