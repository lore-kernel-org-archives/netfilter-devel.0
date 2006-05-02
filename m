From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/06]: Netfilter fixes for 2.6.17
Date: Tue,  2 May 2006 22:48:03 +0200 (MEST)
Message-ID: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
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

following are my netfilter patches for 2.6.17, which fix a couple of bad bugs:

- The SCTP conntrack loop noticed by Ingo
- The unchecked __copy_from/to in the compat code noticed by Linus
- Two H.323 bugs found by the PROTOS c07-h2250v4 testsuite

I'll push the SCTP patch to -stable as well. There is still at least one open
bug in the H.323 helper, but I can't really keep up with the pace new bugs are
discovered at currently.

Please apply.


 include/linux/netfilter_ipv4/ip_conntrack_helper_h323_asn1.h |    2 +-
 net/ipv4/netfilter/ip_conntrack_helper_h323.c                |    2 ++
 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c           |   10 +++++-----
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c                 |   11 +++++++----
 net/ipv4/netfilter/ip_nat_standalone.c                       |    2 ++
 net/ipv4/netfilter/ip_tables.c                               |    6 +++---
 net/netfilter/nf_conntrack_proto_sctp.c                      |   11 +++++++----
 net/netfilter/x_tables.c                                     |    4 ++--
 8 files changed, 29 insertions(+), 19 deletions(-)

Jing Min Zhao:
      [NETFILTER]: H.323 helper: Change author's email address

Patrick McHardy:
      [NETFILTER]: H.323 helper: fix endless loop caused by invalid TPKT len
      [NETFILTER]: H.323 helper: fix use of uninitialized data
      [NETFILTER]: SCTP conntrack: fix infinite loop
      [NETFILTER]: NAT: silence unused variable warnings with CONFIG_XFRM=n
      [NETFILTER]: x_tables: don't use __copy_{from,to}_user on unchecked memory in compat layer
