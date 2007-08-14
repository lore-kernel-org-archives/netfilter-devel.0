From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter fixes
Date: Tue, 14 Aug 2007 18:40:12 +0200 (MEST)
Message-ID: <20070814164004.14668.43960.sendpatchset@localhost.localdomain>
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

these patches fix an extraneous ";" in the new u32 match and three minor
bugs in the SIP conntrack helper. Please apply, thanks.


 net/ipv4/netfilter/nf_nat_sip.c  |    2 +-
 net/netfilter/nf_conntrack_sip.c |    8 ++++++--
 net/netfilter/xt_u32.c           |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

Eric Dumazet (1):
      [NETFILTER]: netfilter: xt_u32 bug correction

Patrick McHardy (3):
      [NETFILTER]: nf_conntrack_sip: check sname != NULL before calling strncmp
      [NETFILTER]: nf_conntrack_sip: fix SIP-URI parsing
      [NETFILTER]: nf_nat_sip: don't drop short packets
