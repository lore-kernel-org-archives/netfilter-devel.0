From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] new match extension `flow'
Date: Fri, 29 Oct 2004 21:32:44 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41829ADC.2090708@eurodev.net>
References: <20041028020550.GA10097@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20041028020550.GA10097@wsc.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Josh Samuelson wrote:

>Greetings,
>
>The attached diff files add to iptables the ability to match max
>connections allowed for various IP protocols: generic IP, ICMP, TCP
>and UDP.
>
>kernel changes:
>The patch file is for 2.6.9.
>net/ipv4/netfilter/ip_conntrack_standalone.c must be fixed by a
>patch I sent to the list earlier; see line 819 for the problem.
>It modifies some files relevant to ip_conntrack and adds a ipt_flow.c
>match module.  When a new conntrack is created, a flow structure will
>have counters incremented for the type of protocol being used, indexed
>by the original direction source IP address.  All current flows can
>be viewed in the "/proc/net/ip_conntrack_flow" file.  The current
>number of flows can be viewed from the
>"/proc/sys/net/ipv4/netfilter/ip_conntrack_flow_count" file.
>
># cat /proc/net/ip_conntrack_flow 
>192.168.1.7 IP: 1 ICMP: 0 TCP: 1 UDP: 0
>192.168.1.254 IP: 1 ICMP: 0 TCP: 0 UDP: 0
>192.168.1.7 IP: 1 ICMP: 0 TCP: 1 UDP: 0
>192.168.1.55 IP: 1 ICMP: 0 TCP: 1 UDP: 0
>192.168.1.121 IP: 2 ICMP: 0 TCP: 0 UDP: 2
># cat /proc/sys/net/ipv4/netfilter/ip_conntrack_flow_count
>5
>#
>
>iptables changes:
>The patch is for iptables-1.2.11.  It adds the source to allow
>iptables to have the flow match via the shared library API that
>iptables defines.  The module adds the following options:
>--maxip n   (which can only be used when no protocol is specified)
>--maxicmp n (allowed with -p icmp)
>--maxtcp n  (allowed with -p tcp)
>--maxudp n  (allowed with -p udp)
>The flow match module can only be used in the filter table.
>
>An example of the usage:
>
>iptables -A FORWARD -p tcp -s 192.168.1.0/24 -m flow --maxtcp 150 \
>-m state --state NEW -j REJECT --reject-with tcp-reset
>
>This would deny new TCP connections from all hosts routing
>through the machine from the 192.168.1.0/24 network that already
>have 150 connections.
>
>Hope some people find this useful!  Original idea from John Dunning,
>see "Flow count module" from Tue Oct 12 14:54:20 CEST 2004.
>
>Questions, comments?
>  
>

cool, nice work. But can't we do a match which counts new connections? I 
bet that
the problem is that we don't know when a connection is closed, maybe we 
could add a
new ip_conntrack_status (something like IPS_CLOSED_BIT) which would be 
set when
a connection is closed, i.e. in tcp tracking when in time 
TIME_WAIT/FIN_WAIT). I don't
like so much the idea of adding more stuff to the core of the conntrack 
to keep things simpler.

Pablo
