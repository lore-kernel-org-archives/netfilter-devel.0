From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/4] kill manually comparing protocol name with "ipv6-icmp"
Date: Fri, 07 Apr 2006 20:31:33 +0900 (JST)
Message-ID: <200604071131.k37BVY3F025271@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="02-proto-icmpv6.patch"
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

[IP6TABLES] kill manually comparing protocol name with "ipv6-icmp"

This adds "ipv6-icmp" to chain_protos[] and kill manually comparing
the argument of '-p' with it.

chain_protos[] has the "icmpv6" with the same protocol number, but it's
OK because proto_to_name() returns the firstly matched entry "icmpv6"
as ever.

---
commit 62607c174a8c1cc7a4f18e7537be75a1d5a87944
tree f1c65a0db8d249e19a4c35b46d95e7d8f1eaf628
parent f7eed26853dda6a51d70221f5c9ef0fac60f73a7
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 22:34:56 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 22:34:56 +0900

 ip6tables.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index dcf7d36..1279888 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -222,6 +222,7 @@ static const struct pprot chain_protos[]
 	{ "tcp", IPPROTO_TCP },
 	{ "udp", IPPROTO_UDP },
 	{ "icmpv6", IPPROTO_ICMPV6 },
+	{ "ipv6-icmp", IPPROTO_ICMPV6 },
 	{ "esp", IPPROTO_ESP },
 	{ "ah", IPPROTO_AH },
 };
@@ -1748,7 +1749,6 @@ int do_command6(int argc, char *argv[], 
 	char *protocol = NULL;
 	const char *modprobe = NULL;
 	int proto_used = 0;
-	char icmp6p[] = "icmpv6";
 
 	memset(&fw, 0, sizeof(fw));
 
@@ -1917,8 +1917,6 @@ int do_command6(int argc, char *argv[], 
 				*protocol = tolower(*protocol);
 
 			protocol = argv[optind-1];
-			if ( strcmp(protocol,"ipv6-icmp") == 0)
-				protocol = icmp6p;
 			fw.ipv6.proto = parse_protocol(protocol);
 			fw.ipv6.flags |= IP6T_F_PROTO;
 
