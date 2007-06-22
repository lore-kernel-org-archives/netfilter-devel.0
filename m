From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Fri, 22 Jun 2007 13:47:30 +0200 (MEST)
Message-ID: <20070622114656.14839.1945.sendpatchset@localhost.localdomain>
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

following are two netfilter fixes for 2.6.22, adding a few new SIP message
types that are necessary to get Jerome's setup working, and a patch to
forbid changing helpers of an existing connection to avoid races while
changing the helper private area.

Please apply, thanks.


 net/netfilter/nf_conntrack_netlink.c |    3 +--
 net/netfilter/nf_conntrack_sip.c     |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

Jerome Borsboom (1):
      [NETFILTER]: nf_conntrack_sip: add missing message types containing RTP info

Yasuyuki Kozakai (1):
      [NETFILTER]: nfctnetlink: Don't allow to change helper
