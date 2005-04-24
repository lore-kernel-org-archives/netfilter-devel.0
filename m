From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Ignore PSH on SYN/ACK in TCP connection tracking
Date: Sun, 24 Apr 2005 23:41:15 +0200
Message-ID: <426C127B.9030108@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000003020807000702070309"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------000003020807000702070309
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes a problem with TCP connection tracking and
some devices that respond with SYN/ACK/PSH to a SYN packet.
TCP connection tracking considers these packets to be invalid
and the connection never reaches an estabished state. Ignore
PSH on SYN/ACKs.


--------------000003020807000702070309
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Ignore PSH on SYN/ACK in TCP connection tracking

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 72fbbd2b143c27c9c3793698c04302d066d9e4bc
tree 790636ed7460d6ca2b20cfd98df33a381fe2f0db
parent df6c6804ce1d383c878ab071bce8125125d96abc
author NIIBE Yutaka <gniibe@fsij.org> 1114303196 +0200
committer Patrick McHardy <kaber@trash.net> 1114303196 +0200

Index: net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- 43765d4b40a4a3c64f2a32b684f4041e2f01644d/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644 sha1:e800b16fc9209dd5a26e65d2be4eb83d77a7d7af)
+++ 790636ed7460d6ca2b20cfd98df33a381fe2f0db/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644 sha1:2b87c1974be605d5bdb1ee769188d7e03fb2ddc8)
@@ -770,6 +770,7 @@
 {
 	[TH_SYN]			= 1,
 	[TH_SYN|TH_ACK]			= 1,
+	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,
 	[TH_RST|TH_ACK|TH_PUSH]		= 1,

--------------000003020807000702070309--
