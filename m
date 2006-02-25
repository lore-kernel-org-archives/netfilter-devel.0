From: Saku Ytti <saku@ytti.fi>
Subject: ipv6 conntrack status?
Date: Sat, 25 Feb 2006 13:13:16 +0200
Message-ID: <20060225111316.GA13280@mx.ytti.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hey,

I'm running 2.6.16-rc4, I've rolled and installed:
conntrack_1.00beta1_amd64.deb
libconntrack-extensions_1.00beta1_amd64.deb
libnetfilter-conntrack1_0.0.30_amd64.deb
libnetfilter-conntrack-dev_0.0.30_amd64.deb
libnfnetlink0_0.0.14_amd64.deb
libnfnetlink-dev_0.0.14_amd64.deb

I checked SVN for iptables 1.4 branch, but couldn't see ip6 conntrack.

[root@ip.fi ~]# conntrack -L -f ipv6
Operation failed: Unknown error 18446744073709551519

ipv4 works perfectly. What am I missing? I couldn't really find any
documentation how the new architecture should be configured, if there
is such, please point me to it.

I've previously used ipv6 conntrack from usagi patched without problems.

Thanks,

-- 
  ++ytti
