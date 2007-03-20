From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFLOG and ulogd-2: not talking to each other
Date: Tue, 20 Mar 2007 17:02:59 +0100
Message-ID: <460005B3.9070703@trash.net>
References: <4600047D.6030106@nitrosecurity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Dan Purcell <dpurcell@nitrosecurity.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4600047D.6030106@nitrosecurity.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Dan Purcell wrote:
> Has anyone here had any experience with NFLOG and ulogd-2?  Anyone been
> successful in putting this together?  I have tried posting to the
> gnumonks.org's ulogd mailing list, but it seams to be lifeless.
> 
> I successfully built the xt_NFLOG target from the 2.6.20 kernel, and am
> using iptables 1.3.7 (which includes the NFLOG target).  I replaced the
> libipt_NFLOG.c and libip6t_NFLOG.c files with those that are in
> netfilter's SVN, as I understand there is a problem (bug) with the
> userspace side regarding nflog-groups.
> 
> I set up my ulogd configuration file, added a stack that included the
> NFLOG input plugin.  in the parameter section, I set the NFLOG group to
> 16 (I verified that ulogd says it is attaching to group number 16 by
> viewing /var/log/ulogd.log).  I add the following iptables rule:
> ip6tables -A FORWARD -j NFLOG --nflog-group 16.  My system is set up
> with a bridge, and I can tcpdump the ipv6 traffic going by.
> 
> The counters on the ip6tables -nvL FORWARD increases, but I don't think
> I am not getting anything to ulogd.  My /var/log/messages fills up with
> logs like the following:
> 
>  Mar 19 22:55:04 localhost kernel: [3003211.629163] nf_log_packet: can't
>  log since no backend logging module loaded in! Please either load one,
>  or disable logging explicitly
> 
> I have also ran ulogd in gdb, and have put a break point in
> ulogd_inppkt_NFLOG.c's interp_packet(..) function, but the break point
> is never reached.

I'm using it with this configuration:

iptables -A LOG_ACCEPT -j NFLOG --nflog-range 80 --nflog-prefix "accept"
--nflog-group 0
ip6tables -A LOG_ACCEPT -j NFLOG --nflog-prefix "accept" --nflog-range
80 --nflog-group 1

ulogd.conf:

# this is a stack for packet-based logging via LOGEMU
stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,print1:PRINTPKT,emu1:LOGEMU
stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,print1:PRINTPKT,emu1:LOGEMU

# this is a stack for flow-based logging via LOGEMU
#stack=ct1:NFCT,print1:PRINTFLOW,emu1:LOGEMU

# this is a stack for flow-based logging via OPRINT
#stack=ct1:NFCT,op1:OPRINT

[log1]
# netlink multicast group (the same as the iptables --ulog-nlgroup param)
group=0

[log2]
group=1
addressfamily=10

[emu1]
file="/var/log/ulogd_syslogemu.log"
sync=1
