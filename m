From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Netfilter as an application
Date: Fri, 16 Jan 2004 23:40:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401162327430.32690-100000@filer.marasystems.com>
References: <20040116214721.82710.qmail@web40301.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allen Francom <aef@tempest.prismnet.com>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kernel_learner <kernel_learner@yahoo.com>
In-Reply-To: <20040116214721.82710.qmail@web40301.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 16 Jan 2004, kernel_learner wrote:

> What exactly does the netfilter use from the Linux kernel?

Not much. It is essentially a separate entity called by the hooks in the 
Linux TCP/IP stack.

There is some dependencies on routing etc, but this is only relevant if
you are planning on doing stuff related to routing such as mangle or NAT.

> Where exactly does it interact with the kernel? 

The kernel sends packets to the Netfilter modules via the netfilter 
hooks.

If netfilter selects to delay a packet then the packet is later 
reintroduced to the kernel via the nf_reinject() function.

The userspace communicates with iptables via getsockopt() calls to install 
iptables rulesets etc.

Netfilter is fully contained in the netfilter directories and headers,
plus some support functions in net/core/netfilter.c taking care of the
gory details of registering new hook handlers, getsockopt operations etc.


The Netfilter hacking howto guide has some good information on how a 
Netfilter module such as iptables interacts with the kernel.



Personally I find using the user-mode-linux approach very suitable if one
want to use netfilter as an application. You then have a 100% complete
application running iptables (or whatever) with all of the support given
by the kernel without requiring any root privileges. Root is only required
if you want to set up network connectivity to the host, not for
communication between user-mode-linux nodes.

Regards
Henrik
