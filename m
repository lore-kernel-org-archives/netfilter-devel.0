From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Mon, 27 Jun 2005 20:02:22 +0200
Message-ID: <42C03F2E.30706@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi Harald,

This patchset introduces tons of updates for the nfnetlink, ctnetlink 
and the conntrack event API. I haven't attached the file since it's that 
big, about 100K.

You can get an incremental diff against SVN from:
http://people.netfilter.org/~pablo/ctnetlink-2.6.12/SVN-patches/ctnetlink-ctevent-nfnetlink-update-2.6.12.patch

Please apply.


I've split this big patch above into four pieces to make it easier to 
understand the changes:
http://people.netfilter.org/~pablo/ctnetlink-2.6.12/2.6.11-vs-2.6.12/

So these four patches shouldn't be applied, just they are meant to make 
your life easier to track the changes.

Summary of changes
------------------

o conntrack event API
- Don't kill NFC_IP_* stuff, keep it there to ensure for old iptables 
versions compilation.
- new file ip_conntrack_events.h that contains all event related 
functions to reduce pollution in ip_conntrack.h
- IPCT_DELIVERED bit. Loopback reports event are reported twice, this 
bit is set once event are delivered. I just came up with a better idea, 
reset nfcache once the events have been delivered, but I'll apply this 
change in the next patchset.

o nfnetlink
- kill unused list.
- kill nfnl_exlock(), not needed anymore.
- kill duplicated check: NFNL_SUBSYS_ID(type) > NFNL_SUBSYS_COUNT.
- kill unneeded initialization of subsys_table to NULL, since it's in 
BSS section (already set to zero).
- kill dead define CONFIG_NF_NETLINK.

o ctnetlink
- merge ctnetlink_get_mcgroups and ctnetlink_get_exp_mcgroups
- implemented NAT handlings
- kill unused ctnetlink_kill
- use __u64 id's for conntracks
- stop using NLMSG_DONE to report the end of a dump, use explicite ACK 
instead (NLM_F_ACK).
- fixed broken expectation timeout dumping.
- kill unused ctnetlink_exp_dump_proto
- kill ctnetlink_exp_dump: fairly small and just used once
- kill NFNL_SUBSYS_CTNETLINK_EXP, use NFNL_SUBSYS_CTNETLINK instead
- Fix expectation table dumping
- Fix expectation creation
- implemented flushing of the expect table

TODO
----

- Implement ip_conntrack_stats dumping and reset (accounting)
- Implement get conntrack and destroy (accounting)
- Kill event/dump mask based (?). Although it's unique, I think that it 
could be useful for weak conntrack event notification (think of just 
new, established and destroy event notification to reduce performance 
impact).

Once ip_conntrack_netlink gets fully featured and people don't report 
bugs for quite some time. I'll create a nf_conntrack_netlink tree.

--
Pablo
