From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM [2.4.x]
Date: Tue, 21 Jun 2005 17:15:53 +0200
Message-ID: <42B82F29.40307@tac.ch>
References: <42A57FC4.7010508@tac.ch>	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>
	<42B81D75.8090205@trash.net> <42B82177.5010101@tac.ch>
	<42B8288C.9030004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42B8288C.9030004@trash.net>
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

>>This results in an endless loop when calling rmmod ip_conntrack. lsmod shows
>>(deleted) but the process is in D state. No oops of course and no hang.
>>
>>But I cannot remove the ip_conntrack kernel module anymore. It's "stuck".
>  
> This means we're either leaking conntrack entries or packets holding
> a reference are queued somewhere. What do you use NOTRACK for?

There's a lot of situations (broken customer applications, regarding TCP state
transition and timing handling mostly) where we run into major problems using
the connection tracking _with_ tcp window tracking (is a must) on top. The
ip_conntrack_tcp_be_liberal and ip_conntrack_tcp_loose sysctrl's don't help
in those cases. Sometimes we can circumvent window tracking problems using
high ip_conntrack_tcp_max_retrans values. Another reason is that we have no
means to flush selective entries from the connection tracking table except
rmmod'ing the lkm. If we do that we lose all xterm sessions to the packet filter
being reconfigured and also uneccessarily provoke fake failovers in our HA
software. Having the NOTRACK feature allows us to write firewall rules which
seemingly have the same semantics as we had with ipchains in the 2.2.x series.

I could give you a huge list of reasons, all of which have to do in how we use
the packet filtering infrastructure in the given Linux kernel.

>>Do you want me to rerun the test for more precise statements?
> 
> Yes, please make sure no packets are queued in qdiscs (best to use
> pfifo) and no raw/packet sockets are open and ip_queue isn't used.

# tc qdisc show
qdisc pfifo_fast 0: dev eth0 [Unknown qdisc, optlen=20]
qdisc pfifo_fast 0: dev eth1 [Unknown qdisc, optlen=20]

# cat /proc/net/raw
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt
uid  timeout inode

ip_queue is not used. Following modules are loaded when our small ruleset is set:

Module                  Size  Used by
ipt_NOTRACK             1040   0  (autoclean)
ipt_state                864   0  (autoclean)
ipt_LOG                 3824   0  (autoclean)
ipt_limit               1456   0  (autoclean)
iptable_raw             1536   0  (autoclean)
iptable_mangle          2512   0  (autoclean) (unused)
iptable_filter          2000   0  (autoclean)
ip_nat_ftp              2896   0  (unused)
iptable_nat            20368   1  [ip_nat_ftp]
ip_tables              12448  10  [ipt_NOTRACK ipt_state ipt_LOG ipt_limit iptab
le_raw iptable_mangle iptable_filter iptable_nat]
ip_conntrack_ftp        4000   1
ip_conntrack           29632   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat
ip_conntrack_ftp]

> You could also add a printk to the inner body of the
> while(atomic_read(...)) loop and print out the reference count, perhaps
> it will show something interesting.

After seeing it in D state I reckon I wrap it into a well placed rate limit ;).

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
