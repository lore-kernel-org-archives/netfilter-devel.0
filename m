From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: netfilter vs iptables naming confusion
Date: Mon, 8 Dec 2003 13:09:47 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312081257120.10693-100000@filer.marasystems.com>
References: <3FD45DDC.9030901@epmhs.gr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Haris Koutsouris <harisk@epmhs.gr>
In-Reply-To: <3FD45DDC.9030901@epmhs.gr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 8 Dec 2003, Haris Koutsouris wrote:

> <my understanding>
> Netfilter is a set of hooks in the networking code of the linux kernel
>   that allows another piece of code (kernel module) to register for 
> access  to the packets that pass through these points.

Yes.

> Several iptables kernel modules (e.g ip_tables,
> iptable_mangle,ipt_conntrack, ipt_LOG)  implement the firewalling
> functionality and in addition the user space utility iptables is used as
> a user interface to the iptables functionality.

Many also consider the connection tracking as part of the netfilter
framework, and maybe even the NAT core in some respect, but it is a thin
boundary especially considering that it is mainly iptables which use 
these.

But it is certainly correct to say that netfilter is the hook
infrastrucure allowing the firewall access to the packet flow, and
iptables is the firewalling code of iptables.

> A final question are the kernel modules named iptables modules or 
> netfilter modules?????

There are both. The design is layered with modules at both layers.

modules which registers netfilter hooks are netfilter modules. This
includes iptables itself and the connection tracking, but there is also
several other netfilter modules such as Linux Virtual Server or the HiPac
firewall.

modules which registers iptables targets/matches for use in the iptables
firewall are iptables modules.

Regards
Henrik
