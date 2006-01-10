From: Stephen Hemminger <shemminger@osdl.org>
Subject: Recent changes break build if IPV6 is modular?
Date: Tue, 10 Jan 2006 15:41:46 -0800
Message-ID: <20060110154146.609408b0@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

In my config ipv6 is a module, but the netfilter code is not.
Therefore the reference to ip6_output in ipv6/netfilter.c 
doesn't work.

net/built-in.o(.text+0x5d81b): In function `ip6_route_me_harder':
net/ipv6/netfilter.c:23: undefined reference to `ip6_route_output'
net/built-in.o(.text+0x5d888):net/ipv6/netfilter.c:33: undefined reference to `ipv6_statistics'


-- 
Stephen Hemminger <shemminger@osdl.org>
OSDL http://developer.osdl.org/~shemminger
