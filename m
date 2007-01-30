From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Tue, 30 Jan 2007 19:16:27 +0100 (MET)
Message-ID: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
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

following are a few more netfilter fixes for 2.6.20, fixing a division
by zero in the connbytes match (I will pass this one on to -stable as
well) and two problems with the SIP conntrack helper.

Please apply, thanks.


 net/ipv4/netfilter/ip_conntrack_sip.c |   10 ++++++++--
 net/netfilter/nf_conntrack_sip.c      |   10 ++++++++--
 net/netfilter/xt_connbytes.c          |   29 ++++++++++++-----------------
 3 files changed, 28 insertions(+), 21 deletions(-)

Lars Immisch:
      [NETFILTER]: SIP conntrack: fix skipping over user info in SIP headers

Patrick McHardy:
      [NETFILTER]: xt_connbytes: fix division by zero
      [NETFILTER]: SIP conntrack: fix out of bounds memory access
