From: Damon Gray <dgray@speakeasy.org>
Subject: [PoM PATCH 0/3] Connlimit rewrite
Date: Thu, 10 Nov 2005 23:44:36 -0800 (PST)
Message-ID: <Pine.LNX.4.58.0511102303061.13906@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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


This new version of connlimit adds a new 2.6.14 specific directory.
Connlimit can be used exactly as it always has however this new version
has several new features:

 o You can now set the size of the internal hash table. The hash table
   size will automatically be 1 if connlimit-mask is 0.

 o connlimit now allows for two forms of timing out of idle sessions it
   is tracking. It will only time out a connection if it goes over the
   allowed number of sessions. The default timeout mode actually deletes
   the conntrack entry for the session. The other form allows you to set
   a CONNMARK on the conntrack entry if it has been idle over the
   timeout. (calculating timeout is why tcp_timeouts[] in
   ip_conntrack_proto_tcp.c needed to be changed and exported).

 o connlimit now has a shared session tracking system. The problem with
   the way connlimit works is that when the iptables rule is deleted or
   changed (which happens when any rule in the chain changes) then you
   lose all the connections that it was tracking which is bad for long
   lived connections. The new idea is to use a shared ID that you can
   use so that multiple iptables rules can share the same set of
   connections. This also means you can update the rule without losing
   connections.

 o connlimit no longer stores a copy of the tuple and uses that to
   lookup the conntrack entry. It now keeps a pointer to the conntrack
   entry (upping the use count of course). To facilitate this it uses
   a "garbage collector" that runs every N seconds (settable via a
   module param) which cleans out entries that the conntrack has gone
   away, as to not waste memory. This change to using pointers increased
   performance significantly when many connections are being tracked.
