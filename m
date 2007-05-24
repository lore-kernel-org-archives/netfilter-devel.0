From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/07]: Netfilter fixes
Date: Fri, 25 May 2007 00:02:06 +0200 (MEST)
Message-ID: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
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

following are a couple of netfilter patches, fixing newline sequence number
tracking problems with the FTP helper and a few problems with the H.323
helper, mostly related to tracking IPv6 connections.

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_ftp.h        |    3 -
 include/linux/netfilter/nf_conntrack_h323_types.h |   23 +-----------
 net/ipv4/netfilter/nf_nat_ftp.c                   |   20 +++-------
 net/ipv4/netfilter/nf_nat_h323.c                  |    6 +--
 net/netfilter/nf_conntrack_ftp.c                  |   13 +++---
 net/netfilter/nf_conntrack_h323_main.c            |   41 +++++-----------------
 net/netfilter/nf_conntrack_h323_types.c           |   31 ++++++----------
 7 files changed, 44 insertions(+), 93 deletions(-)

Jing Min Zhao (5):
      [NETFILTER]: nf_conntrack_h323: fix ASN.1 types
      [NETFILTER]: nf_conntrack_h323: fix get_h225_addr() for IPv6 address access
      [NETFILTER]: nf_conntrack_h323: remove unnecessary process of Information signal
      [NETFILTER]: nf_conntrack_h323: add missing T.120 address in OLCA
      [NETFILTER]: nf_nat_h323: call set_h225_addr instead of set_h225_addr_hook

Patrick McHardy (2):
      [NETFILTER]: nf_conntrack_ftp: fix newline sequence number update
      [NETFILTER]: nf_conntrack_ftp: fix newline sequence number calculation
