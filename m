From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter -stable fixes
Date: Mon, 15 Jan 2007 10:28:25 +0100 (MET)
Message-ID: <20070115092825.23343.67537.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
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

The following two patches for ctnetlink fix a crash when the CTA_STATUS attribute
is not present and a memory leak when changing the conntrack protocol data fails.

Please apply, thanks.


 net/ipv4/netfilter/ip_conntrack_netlink.c |   10 ++++++----
 net/netfilter/nf_conntrack_netlink.c      |   10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

Pablo Neira Ayuso:
      [NETFILTER]: ctnetlink: check for status attribute existence on conntrack creation

Patrick McHardy:
      [NETFILTER]: ctnetlink: fix leak in ctnetlink_create_conntrack error path
