From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes for 2.6.17
Date: Mon, 29 May 2006 01:06:30 +0200 (MEST)
Message-ID: <20060528230630.6318.23196.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
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

following are a two more fixes for 2.6.17 and a patch to mark the
H.323 helper experimental. Please apply.


 net/ipv4/netfilter/Kconfig                     |    4 ++--
 net/ipv4/netfilter/ip_conntrack_core.c         |    1 +
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c  |    4 ++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 +
 4 files changed, 6 insertions(+), 4 deletions(-)

Alexey Dobriyan:
      [NETFILTER]: PPTP helper: fix sstate/cstate typo

Marcel Holtmann:
      [NETFILTER]: Fix small information leak in SO_ORIGINAL_DST (CVE-2006-1343)

Patrick McHardy:
      [NETFILTER]: mark H.323 helper experimental
