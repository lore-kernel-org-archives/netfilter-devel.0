From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ipv6 conntrack status?
Date: Fri, 03 Mar 2006 02:41:08 +0900 (JST)
Message-ID: <200603021741.k22Hf8RP011900@toshiba.co.jp>
References: <20060225111316.GA13280@mx.ytti.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: saku@ytti.fi
In-Reply-To: <20060225111316.GA13280@mx.ytti.net>
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


From: Saku Ytti <saku@ytti.fi>
Date: Sat, 25 Feb 2006 13:13:16 +0200

> Hey,
> 
> I'm running 2.6.16-rc4, I've rolled and installed:
> conntrack_1.00beta1_amd64.deb
> libconntrack-extensions_1.00beta1_amd64.deb
> libnetfilter-conntrack1_0.0.30_amd64.deb
> libnetfilter-conntrack-dev_0.0.30_amd64.deb
> libnfnetlink0_0.0.14_amd64.deb
> libnfnetlink-dev_0.0.14_amd64.deb
> 
> I checked SVN for iptables 1.4 branch, but couldn't see ip6 conntrack.
> 
> [root@ip.fi ~]# conntrack -L -f ipv6
> Operation failed: Unknown error 18446744073709551519
> 
> ipv4 works perfectly. What am I missing? I couldn't really find any
> documentation how the new architecture should be configured, if there
> is such, please point me to it.
> 
> I've previously used ipv6 conntrack from usagi patched without problems.

You can use nf_conntrack_ipv6 in mainline kernel, not ip6_conntrack.
To build it, please disable IP_NF_CONNTRACK, enable NF_CONNTRACK and
NF_CONNTRACK_IPV6. NF_CONNTRACK is in the menu "Core Netfilter Configuration",
and NF_CONNTRACK_IPV6 in the menu "IPv6: Netfilter Configuration
(EXPERIMENTAL)".

Regards,

-- Yasuyuki Kozakai
