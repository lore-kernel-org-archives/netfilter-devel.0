From: Dan Aloni <da-x@gmx.net>
Subject: '-m owner' problem (bug?)
Date: Wed, 18 Sep 2002 20:04:08 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918170408.GA12455@callisto.yi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

(not subscribed to the list, please CC)

This command used to work in the past:

   iptables -A OUTPUT -o eth1 -m owner --uid-owner 0 -d 192.168.1.6/32 -j ACCEPT

Now it doesn't I get:

   iptables: Invalid argument

This *does* work (only removed '-m owner --uid-owner 0'. Weird, huh?):
  
   iptables -A OUTPUT -o eth1 -d 192.168.1.6/32 -j ACCEPT

The owner module is loaded:

   ipt_MASQUERADE          1208   1  (autoclean)
   iptable_nat            13784   1  (autoclean) [ipt_MASQUERADE]
   ipt_owner               1368   0  (autoclean)
   ipt_state                568   2  (autoclean)
   ip_conntrack           16224   2  (autoclean) [ipt_MASQUERADE iptable_nat ipt_state] 
   ipt_REJECT              2840   7  (autoclean)
   ipt_multiport            632   6  (autoclean)
   iptable_filter          1668   1  (autoclean)
   ip_tables              10456   9  [ipt_MASQUERADE iptable_nat ipt_owner ipt_state ipt_REJECT
   ipt_multiport iptable_filter]

The kernel is 2.4.20-pre7 vanilla. 
Usermode iptables is iptables v1.2.7a vanilla.

I started debugging iptables and I found that the kernel returns this 
error from a setsockopt() in iptc_commit().

Comments? Suggestions?

-- 
Dan Aloni
da-x@gmx.net
