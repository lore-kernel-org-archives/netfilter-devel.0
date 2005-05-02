From: Thomas <toom@docisland.org>
Subject: ctnetlink weird events on ipsec connections
Date: Mon, 02 May 2005 17:34:43 +0200
Message-ID: <1115048084.12112.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,

I recently tried the new ip_conntrack_netlink feature and I got a weird
result with ipsec connections : 
# conntrack -E conntrack
[DESTROY] src=<VPNGW_1> dst=<VPNGW_2>
          src=<VPNGW_2> dst=<VPNGW_1> timeout:180
          orig_packets=8391 orig_bytes=1252012,
          reply_packets=19 reply_bytes=11424 
[DESTROY] src=<INTERNAL_IP1> dst=<INTERNAL_IP2>
          src=<INTERNAL_IP2> dst=<INTERNAL_IP1> timeout:432000
          orig_packets=7763 orig_bytes=572775,
          reply_packets=5219 reply_bytes=1209729 
[DESTROY] src=<VPNGW_1> dst=<VPNGW_2>
          src=<VPNGW_2> dst=<VPNGW_1> timeout:180
          orig_packets=8392 orig_bytes=1252140,
          reply_packets=19 reply_bytes=11424 
[DESTROY] src=<INTERNAL_IP1> dst=<INTERNAL_IP2>
          src=<INTERNAL_IP2> dst=<INTERNAL_IP1> timeout:432000
          orig_packets=7764 orig_bytes=572827,
          reply_packets=5221 reply_bytes=1210553 
and so on ...

both INTERNAL_IP2 and VPNGW_2 ip are in the same host where I run
conntrack tool.

you can note that {orig|reply}_{packets|byte} are normally incremented
as if the connection in the conntrack was not destroyed.
It seems that two destroy events are generated for each ipsec packet.

I've just updated conntrack, libnfnetlink, libctnetlink, nfnetlink and
ctnetlink from svn.netfilter.org (updated today) and the result is the
same.

Thomas
