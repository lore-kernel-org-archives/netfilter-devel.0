From: Patrick Schaaf <bof@bof.de>
Subject: Re: Asym. router has problems with full ip_conntrack table in 2.4.20
Date: Mon, 27 Jan 2003 13:24:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030127122459.GB18340@oknodo.bof.de>
References: <20030127112653.GB9209@westend.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Hammers <ch@westend.com>
Content-Disposition: inline
In-Reply-To: <20030127112653.GB9209@westend.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I use kernel 2.4.20 and iptables filter (no NAT or stateful filtering!) on
> a router that is part of a large network and has many asymetric routes
> i.e. inbound packages of some connections go over this host but replies
> are send via another router. Therefore stateful packet filtering would
> have no chance to get some kind of ESTABLISHED state or similar and is
> completely disabled.

ESTABLISHED is reached unidirectional, as soon as a packet successfully
passes through your box. If the return direction is completely different,
then those conntrack entries won't be ASSURED, and will be preferentially
reaped when the tracking table is full.

> Now sadly the /proc/net/ip_conntrack still exists and slowly fills up,

Can you characterize what kinds of connections fill up the table?
The normal timeouts should still apply, and I _think_ that the
TCP state engine should work, too (i.e. properly terminated
TCP connections should be flushed in short time, once the FINs
are seen).

Somebody please correct me loudly, if that is not true.

However, you appear to not want conntracking at all. You write:

> lsmod shows only the following (relevant), ipt_conntrack.o is
> at least compiled and installed in /lib/modules/* although not loaded.
> 	ipt_MARK                 800   0  (autoclean)
> 	iptable_mangle          2208   0  (autoclean)
> 	ipt_LOG                 3200   2  (autoclean)
> 	iptable_filter          1760   1  (autoclean)
> 	ip_tables              13184   4  [ipt_MARK iptable_mangle ipt_LOG iptable_filter]
> 
> I currently have:
> 	lx01:/home/ch# wc -l /proc/net/ip_conntrack 
> 	  25963 /proc/net/ip_conntrack
> (all normal traffic, 99% in state [UNREPLIED] due to asymetric routing)

You CANNOT have /proc/net/ip_conntrack if ip_conntrack.o is a module,
and not loaded. Thus, it is almost certain that the kernel you run,
has ip_conntrack compiled in. Please check the boot messages; there
should be a mention of "ip_conntrack", which also tells you the
boottime ip_conntrack_max selection.

best regards
  Patrick
