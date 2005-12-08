From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] ip_nat_tftp: Fix expectation NAT.
Date: Thu, 08 Dec 2005 11:49:14 +0100
Message-ID: <43980FAA.6060608@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030506020106000109050608"
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------030506020106000109050608
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

this patch fixes the case where the port in an initial TFTP packet
is SNATed. Previously the port was never DNATed back for the expected
connection.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/

--------------030506020106000109050608
Content-Type: text/x-patch;
 name="tftp-nat-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tftp-nat-fix.diff"

[NETFILTER] ip_nat_tftp: Fix expectation NAT.

When a TFTP client is SNATed so that the port is also changed, the
port is never changed back for the expected connection.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>

--- linux.current/net/ipv4/netfilter/ip_nat_tftp.c	2005/12/05 18:58:22	1.1
+++ linux.current/net/ipv4/netfilter/ip_nat_tftp.c	2005/12/05 19:01:05
@@ -42,7 +42,10 @@ static unsigned int help(struct sk_buff 
 			 enum ip_conntrack_info ctinfo,
 			 struct ip_conntrack_expect *exp)
 {
-	exp->saved_proto.udp.port = exp->tuple.dst.u.tcp.port;
+	struct ip_conntrack *ct = exp->master;
+
+	exp->saved_proto.udp.port
+		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = ip_nat_follow_master;
 	if (ip_conntrack_expect_related(exp) != 0)

--------------030506020106000109050608--
