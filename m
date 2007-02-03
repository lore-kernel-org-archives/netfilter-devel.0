From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Sat,  3 Feb 2007 02:46:22 +0100 (MET)
Message-ID: <20070203014620.892.62689.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

following are two more netfilter fixes for 2.6.20, fixing H.323 compilation with
IPV6=m and NF_CONNTRACK_H323=y (Adrian's patch) and another compile failure with
NF_CONNTRACK_MARK=n (same for IP_NF_CONNTRACK_MARK=n).

Please apply, thanks.


 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 ++
 net/netfilter/Kconfig                     |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

Adrian Bunk:
      [NETFILTER]: nf_conntrack_h323: fix compile error with CONFIG_IPV6=m, CONFIG_NF_CONNTRACK_H323=y

Max Kellermann:
      [NETFILTER]: ctnetlink: fix compile failure with NF_CONNTRACK_MARK=n
