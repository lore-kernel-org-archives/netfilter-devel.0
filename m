From: Patrick McHardy <kaber@trash.net>
Subject: nf_nat git tree
Date: Mon, 06 Nov 2006 00:19:01 +0100
Message-ID: <454E7165.90404@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060600060400040208060807"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

This is a multi-part message in MIME format.
--------------060600060400040208060807
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I've put the nf_nat stuff in a git tree. The NAT resync-patches
and the FTP hookfn fix are folded into the original patch and
I've ported a few more helpers (only PPtP and netbios_ns are
still missing) and fixed some small bugs in the previous patches
I sent. I've also added module aliases for all helpers so users
can switch transparently.

The git tree contains only my changes, so you need to clone
Linus' tree first and then pull my tree into it:

git-clone
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git-pull http://people.netfilter.org/~kaber/nf-2.6.20-nat.git/

(BTW, 2.6.20 doesn't mean I necessarily want to get it into 2.6.20,
just that its on top of my queued patched for 2.6.20).

Anyone interested in testing should apply the attached workaround
for the nf_conntrack_alter_reply problem on top of the git tree.

Changelog and diffstat below.


--------------060600060400040208060807
Content-Type: text/plain;
 name="summary"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="summary"

 include/linux/netfilter/nf_conntrack_amanda.h            |   10 
 include/linux/netfilter/nf_conntrack_ftp.h               |   20 
 include/linux/netfilter/nf_conntrack_h323.h              |   92 
 include/linux/netfilter/nf_conntrack_helper_h323_asn1.h  |   98 
 include/linux/netfilter/nf_conntrack_helper_h323_types.h |  951 +++++++
 include/linux/netfilter/nf_conntrack_irc.h               |   15 
 include/linux/netfilter/nf_conntrack_sip.h               |   44 
 include/linux/netfilter/nf_conntrack_tftp.h              |   20 
 include/linux/netfilter_ipv4/ip_conntrack_ftp.h          |   40 
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h           |   20 
 include/net/netfilter/nf_conntrack.h                     |   30 
 include/net/netfilter/nf_conntrack_core.h                |    3 
 include/net/netfilter/nf_conntrack_expect.h              |    7 
 include/net/netfilter/nf_conntrack_tuple.h               |   10 
 include/net/netfilter/nf_nat.h                           |   78 
 include/net/netfilter/nf_nat_core.h                      |   26 
 include/net/netfilter/nf_nat_helper.h                    |   33 
 include/net/netfilter/nf_nat_protocol.h                  |   74 
 include/net/netfilter/nf_nat_rule.h                      |   38 
 net/ipv4/netfilter/Kconfig                               |   98 
 net/ipv4/netfilter/Makefile                              |   19 
 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c       |  874 ------
 net/ipv4/netfilter/ip_conntrack_helper_h323_types.c      | 1926 --------------
 net/ipv4/netfilter/ipt_MASQUERADE.c                      |   29 
 net/ipv4/netfilter/ipt_NETMAP.c                          |    4 
 net/ipv4/netfilter/ipt_REDIRECT.c                        |    6 
 net/ipv4/netfilter/ipt_SAME.c                            |   12 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c           |    7 
 net/ipv4/netfilter/nf_nat_amanda.c                       |   79 
 net/ipv4/netfilter/nf_nat_core.c                         |  647 +++++
 net/ipv4/netfilter/nf_nat_ftp.c                          |  183 +
 net/ipv4/netfilter/nf_nat_h323.c                         |  613 ++++
 net/ipv4/netfilter/nf_nat_helper.c                       |  455 +++
 net/ipv4/netfilter/nf_nat_irc.c                          |  101 
 net/ipv4/netfilter/nf_nat_proto_icmp.c                   |   89 
 net/ipv4/netfilter/nf_nat_proto_tcp.c                    |  150 +
 net/ipv4/netfilter/nf_nat_proto_udp.c                    |  141 +
 net/ipv4/netfilter/nf_nat_proto_unknown.c                |   55 
 net/ipv4/netfilter/nf_nat_rule.c                         |  343 ++
 net/ipv4/netfilter/nf_nat_sip.c                          |  251 +
 net/ipv4/netfilter/nf_nat_standalone.c                   |  422 +++
 net/ipv4/netfilter/nf_nat_tftp.c                         |   52 
 net/netfilter/Kconfig                                    |  122 
 net/netfilter/Makefile                                   |    7 
 net/netfilter/nf_conntrack_amanda.c                      |  232 +
 net/netfilter/nf_conntrack_core.c                        |   20 
 net/netfilter/nf_conntrack_expect.c                      |   45 
 net/netfilter/nf_conntrack_ftp.c                         |   21 
 net/netfilter/nf_conntrack_helper_h323.c                 | 1812 ++++++++++++++
 net/netfilter/nf_conntrack_helper_h323_asn1.c            |  874 ++++++
 net/netfilter/nf_conntrack_helper_h323_types.c           | 1927 +++++++++++++++
 net/netfilter/nf_conntrack_irc.c                         |  277 ++
 net/netfilter/nf_conntrack_netlink.c                     |   48 
 net/netfilter/nf_conntrack_proto_tcp.c                   |    2 
 net/netfilter/nf_conntrack_sip.c                         |  489 +++
 net/netfilter/nf_conntrack_standalone.c                  |    5 
 net/netfilter/nf_conntrack_tftp.c                        |  156 +
 net/netfilter/xt_CONNMARK.c                              |    2 
 58 files changed, 11293 insertions(+), 2911 deletions(-)

Patrick McHardy:
      [NETFILTER]: Add NAT support for nf_conntrack
      [NETFILTER]: nf_conntrack: add helper function for expectation initialization
      [NETFILTER]: nf_conntrack/nf_nat: add SIP helper port
      [NETFILTER]: nf_conntrack/nf_nat: add TFTP helper port
      [NETFILTER]: nf_conntrack/nf_nat: add amanda helper port
      [NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port
      [NETFILTER]: nf_conntrack/nf_nat: add IRC helper port

--------------060600060400040208060807
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1f1c257..31a4472 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -855,7 +855,7 @@ void nf_conntrack_alter_reply(struct nf_
 	NF_CT_DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!conntrack->master && help->expecting == 0)
+	if (!conntrack->master && 0 && help->expecting == 0)
 		help->helper = __nf_ct_helper_find(newreply);
 	write_unlock_bh(&nf_conntrack_lock);
 }

--------------060600060400040208060807--
