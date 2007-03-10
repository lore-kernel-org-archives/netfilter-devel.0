From: Greg KH <gregkh@suse.de>
Subject: [patch 02/20] nf_conntrack/nf_nat: fix incorrect config ifdefs
Date: Fri, 9 Mar 2007 22:16:46 -0800
Message-ID: <20070310061646.GC31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	netfilter-devel@lists.netfilter.org, Justin Forbes <jmforbes@linuxtx.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
	Randy Dunlap <rdunlap@xenotime.net>, Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	Patrick McHardy <kaber@trash.net>, alan@lxorguk.ukuu.org.uk
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
	filename="nf_conntrack-nf_nat-fix-incorrect-config-ifdefs.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
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

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: nf_conntrack/nf_nat: fix incorrect config ifdefs

The nf_conntrack_netlink config option is named CONFIG_NF_CT_NETLINK,
but multiple files use CONFIG_IP_NF_CONNTRACK_NETLINK or
CONFIG_NF_CONNTRACK_NETLINK for ifdefs.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/nf_nat_core.c       |    3 +--
 net/ipv4/netfilter/nf_nat_proto_gre.c  |    3 +--
 net/ipv4/netfilter/nf_nat_proto_icmp.c |    3 +--
 net/ipv4/netfilter/nf_nat_proto_tcp.c  |    3 +--
 net/ipv4/netfilter/nf_nat_proto_udp.c  |    3 +--
 net/netfilter/nf_conntrack_proto_gre.c |    3 +--
 6 files changed, 6 insertions(+), 12 deletions(-)

--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -540,8 +540,7 @@ void nf_nat_protocol_unregister(struct n
 }
 EXPORT_SYMBOL(nf_nat_protocol_unregister);
 
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 int
 nf_nat_port_range_to_nfattr(struct sk_buff *skb,
 			    const struct nf_nat_range *range)
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -152,8 +152,7 @@ static struct nf_nat_protocol gre __read
 	.manip_pkt		= gre_manip_pkt,
 	.in_range		= gre_in_range,
 	.unique_tuple		= gre_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -78,8 +78,7 @@ struct nf_nat_protocol nf_nat_protocol_i
 	.manip_pkt		= icmp_manip_pkt,
 	.in_range		= icmp_in_range,
 	.unique_tuple		= icmp_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -140,8 +140,7 @@ struct nf_nat_protocol nf_nat_protocol_t
 	.manip_pkt		= tcp_manip_pkt,
 	.in_range		= tcp_in_range,
 	.unique_tuple		= tcp_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -130,8 +130,7 @@ struct nf_nat_protocol nf_nat_protocol_u
 	.manip_pkt		= udp_manip_pkt,
 	.in_range		= udp_in_range,
 	.unique_tuple		= udp_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -281,8 +281,7 @@ static struct nf_conntrack_l4proto nf_co
 	.new		 = gre_new,
 	.destroy	 = gre_destroy,
 	.me 		 = THIS_MODULE,
-#if defined(CONFIG_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr = nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple = nf_ct_port_nfattr_to_tuple,
 #endif

-- 
