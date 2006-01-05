From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/18]: 2.6.15 netfilter update
Date: Thu,  5 Jan 2006 05:06:29 +0100 (MET)
Message-ID: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

following are my queued netfilter patches for 2.6.15. Most notable is
the ctnetlink port to nf_conntrack, besides that there are a number of
cleanup patches and small fixes and three of the uncontroversial
preparation patches from my IPsec patchset. The remaining IPsec patches
will follow in the next days. Please apply, thanks.


Jesper Juhl:
      [NETFILTER]: Decrease number of pointer derefs in nfnetlink_queue.c
      [NETFILTER]: Decrease number of pointer derefs in nf_conntrack_core.c

Pablo Neira Ayuso:
      [NETFILTER]: ctnetlink: remove bogus checks in ICMP protocol at dumping
      [NETFILTER]: ctnetlink: propagate ctnetlink_dump_tuples_proto return value back
      [NETFILTER]: ctnetlink: use u_int32_t instead of unsigned int
      [NETFILTER]: ctnetlink: ctnetlink_event cleanup
      [NETFILTER]: ctnetlink: fix conntrack mark race
      [NETFILTER]: ctnetlink: remove unused variable
      [NETFILTER]: Add ctnetlink port for nf_conntrack
      [NETFILTER]: Filter dumped entries based on the layer 3 protocol number

Patrick McHardy:
      [NETFILTER]: Fix module_param types and permissions
      [NETFILTER]: ctnetlink: Fix dumping of helper name
      [NETFILTER]: Remove okfn usage in ip_vs_core.c
      [NETFILTER]: Call POST_ROUTING hook before fragmentation
      [NETFILTER]: Export ip6_masked_addrcmp, don't pass IPv6 addresses on stack
      [NETFILTER]: nf_conntrack_l3proto_ipv4.c needs net/route.h

Yasuyuki Kozakai:
      [NETFILTER]: ctnetlink: Add sanity checkings for ICMP
      [NETFILTER]: make ipv6_find_hdr() find transport protocol header
