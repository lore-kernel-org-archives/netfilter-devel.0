From: vl4d@spine-group.org
Subject: [IPSET] help with netlink connector
Date: Sat, 29 Oct 2005 16:16:55 +0200
Message-ID: <200510291616.55535.vl4d@spine-group.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I'm trying to rewrite the ipset sockopt interface with netlink connector 
introduced in 2.6.14... anyway i need some help and directions.

As far as i have understood ipset adds SO_ IP_SET option to IP and manage the 
whole stuff through {set|get}sockopt. How can i access this option using 
connector? do i have to register a connector callback at kernel level  using 
a module and send messages from ipset ??

i need disperate help :D

Regards
