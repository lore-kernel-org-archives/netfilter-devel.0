From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: i wanna know exact difference between NETFILTER and IPTABLES
Date: Wed, 4 Feb 2004 23:21:32 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402042317330.19469-100000@filer.marasystems.com>
References: <20040204172529.45427.qmail@web25209.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?q?rohit=20persaie?= <persaie@yahoo.co.in>
In-Reply-To: <20040204172529.45427.qmail@web25209.mail.ukl.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 4 Feb 2004, rohit persaie wrote:

> netfilter(acts at kernel level )
> 
> and iptables ( works at user level)

Netfilter provides the hooks required for the iptables firewall to access
the packets within the Linux kernel. Both run within the kernel. See the
netfilter hacking guide for details.

To control the ruleset of the iptables firewall kernel the userspace
program iptables is used. This program is responsible for compiling your
firewall ruleset into binary form used by the iptables kernel. The
communication is using getsockopt calls, but this is not really of
interest to anyone except for the iptables core as it is all wrapped up
nicely. The exact deatils of the communication between the iptables
userspace and kernel is not specified in detail other than the source. The
official interface for talking to the iptables kernel is the iptables
command.

Regards
Henrik
