From: Andrew Morton <akpm@osdl.org>
Subject: Fw: Re: network/performance problem
Date: Thu, 11 Mar 2004 15:50:36 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040311155036.7da85ab4.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ron Peterson <rpeterso@mtholyoke.edu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Guys, we do seem to have a netfilter problem.  Could someone please help
out with this thread on linux-kernel?


Begin forwarded message:

Date: Thu, 11 Mar 2004 18:35:25 -0500
From: Ron Peterson <rpeterso@mtholyoke.edu>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: network/performance problem


On Thu, Mar 11, 2004 at 03:15:59PM -0800, Andrew Morton wrote:
> Ron Peterson <rpeterso@mtholyoke.edu> wrote:
> >
> > I didn't reboot sam like I said I would.  I decided I'd let it spiral
> > down.  I'm still collecting profile data every fifteen minutes.  I
> > haven't posted any more graphs.  They look the same as all the others: a
> > monotonically increasing ping latency (w/ a corresponding slow increase
> > in system load averages - which I'm logging, if anyone wants more data).
> > 
> > http://depot.mtholyoke.edu:8080/tmp/sam-profile/
> > 
> > I've been perusing fa.linux.kernel, and saw Brad Laue's thread.  FWIW,
> > it smells similar.  When my machines finally go down, ksoftirqd is
> > always at the top of the process list.
> > 
> > Any ideas at all about what might be happening?
> 
> The profiles tell a story:
> 
> c0217fb0 wait_for_packet                               2   0.0063
> c0256660 arpt_do_table                                 2   0.0019
> c0265ca0 __generic_copy_to_user                        2   0.0278
> c0106bd0 system_call                                   3   0.0536
> c0107e8c handle_IRQ_event                              3   0.0326
> c014bf10 statm_pgd_range                               3   0.0077
> c0120ed4 do_wp_page                                    5   0.0101
> c024c0d4 ip_conntrack_expect_related                  47   0.0368
> c0105250 default_idle                               2817  70.4250
> c024bae0 init_conntrack                             3053   3.7232
> 00000000 total                                      5962   0.0041
> 
> It appears that netfilter has gone berzerk and is taking your machine out.
> 
> Are you really sure that nothing is sitting there injecting new rules all
> the time?

You mean a script calling 'iptables' to dynamically add rules?  Nothing
like that at all.  I dumped the current rules below.

Are you looking at the init_conntrack numbers?  While they seem, in the
long run, to be getting larger, they're not increasing monotonically.
My ping latencies, and the CPU percentage consumed by ksoftirqd_CPU0
just go up and and up (albeit slowly).

The graph below shows what happened when I flushed the rules, and set
the default policy to ACCEPT.  So the ping latencies, at least, seem
to have something to do with iptables.

http://depot.mtholyoke.edu:8080/tmp/tap-sam/2004-03-06_9:30/sam_last_108000.png

1003# iptables -v -L
Chain INPUT (policy DROP 9910K packets, 1296M bytes)
 pkts bytes target     prot opt in     out     source               destination
1899K 2581M ACCEPT     all  --  any    any     anywhere             anywhere            state RELATED,ESTABLISHED
28774 2396K ACCEPT     icmp --  any    any     138.110.0.0/16       anywhere            icmp echo-request
   12   672 ACCEPT     tcp  --  any    any     anywhere             anywhere            tcp dpt:ssh
    0     0 ACCEPT     tcp  --  any    any     anywhere             anywhere            tcp dpt:https
  127  8713 ACCEPT     all  --  lo     any     anywhere             localhost

Chain FORWARD (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy DROP 137 packets, 9042 bytes)
 pkts bytes target     prot opt in     out     source               destination
1433K  287M ACCEPT     all  --  any    any     anywhere             anywhere            state NEW,RELATED,ESTABLISHED

Thu Mar 11 06:26:55 root@sam ~
1004# iptables -v -L -t nat
Chain PREROUTING (policy ACCEPT 21M packets, 2512M bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain POSTROUTING (policy ACCEPT 676K packets, 27M bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 676K packets, 27M bytes)
 pkts bytes target     prot opt in     out     source               destination
