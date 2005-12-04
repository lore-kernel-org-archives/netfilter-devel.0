From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 0/9]: Netfilter fixes
Date: Sun, 04 Dec 2005 22:01:16 +0100
Message-ID: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
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

Hi Dave,

following are a unfortunately quite large number of netfilter fixes for
2.6.15. They're all pretty simple, I hope its still possible to get them
in ..


[NETFILTER]: nf_conntrack: Fix missing check for ICMPv6 type
[NETFILTER]: nfnetlink: Fix calculation of minimum message length
[NETFILTER]: Fix incorrect argument to ip_nat_initialized() in ctnetlink
[NETFILTER]: Fix ip_conntrack_flush abuse in ctnetlink
[NETFILTER]: Fix CTA_PROTO_NUM attribute size in ctnetlink
[NETFILTER]: Mark ctnetlink as EXPERIMENTAL
[NETFILTER]: Wait for untracked references in nf_conntrack module unload
[NETFILTER]: Fix unbalanced read_unlock_bh in ctnetlink
[NETFILTER]: Don't use conntrack entry after dropping the reference
