From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/07]: nf_conntrack_ftp: fix newline sequence number
	calculation
Date: Fri, 25 May 2007 00:02:09 +0200 (MEST)
Message-ID: <20070524215836.14308.55840.sendpatchset@localhost.localdomain>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_ftp: fix newline sequence number calculation

When the packet size is changed by the FTP NAT helper, the connection
tracking helper adjusts the sequence number of the newline character
by the size difference. This is wrong because NAT sequence number
adjustment happens after helpers are called, so the unadjusted number
is compared to the already adjusted one.

Based on report by YU, Haitao <yuhaitao@tsinghua.org.cn>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5dcf6ca671036446403108df0dbc025887e81fb4
tree 8a9e36277001fc9f4f6c2bf1d409f1c8a7c6964d
parent 5e09b4a295e2aed7cb6fe60f86bafba4d8e77836
author Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:49:57 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:49:57 +0200

 include/linux/netfilter/nf_conntrack_ftp.h |    3 +--
 net/ipv4/netfilter/nf_nat_ftp.c            |   20 ++++++--------------
 net/netfilter/nf_conntrack_ftp.c           |    5 ++---
 3 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 81453ea..b7c360f 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -37,8 +37,7 @@ extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
 				       enum nf_ct_ftp_type type,
 				       unsigned int matchoff,
 				       unsigned int matchlen,
-				       struct nf_conntrack_expect *exp,
-				       u32 *seq);
+				       struct nf_conntrack_expect *exp);
 #endif /* __KERNEL__ */
 
 #endif /* _NF_CONNTRACK_FTP_H */
diff --git a/net/ipv4/netfilter/nf_nat_ftp.c b/net/ipv4/netfilter/nf_nat_ftp.c
index 751b598..e6bc8e5 100644
--- a/net/ipv4/netfilter/nf_nat_ftp.c
+++ b/net/ipv4/netfilter/nf_nat_ftp.c
@@ -40,8 +40,7 @@ mangle_rfc959_packet(struct sk_buff **pskb,
 		     unsigned int matchoff,
 		     unsigned int matchlen,
 		     struct nf_conn *ct,
-		     enum ip_conntrack_info ctinfo,
-		     u32 *seq)
+		     enum ip_conntrack_info ctinfo)
 {
 	char buffer[sizeof("nnn,nnn,nnn,nnn,nnn,nnn")];
 
@@ -50,7 +49,6 @@ mangle_rfc959_packet(struct sk_buff **pskb,
 
 	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
 
-	*seq += strlen(buffer) - matchlen;
 	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
 					matchlen, buffer, strlen(buffer));
 }
@@ -63,8 +61,7 @@ mangle_eprt_packet(struct sk_buff **pskb,
 		   unsigned int matchoff,
 		   unsigned int matchlen,
 		   struct nf_conn *ct,
-		   enum ip_conntrack_info ctinfo,
-		   u32 *seq)
+		   enum ip_conntrack_info ctinfo)
 {
 	char buffer[sizeof("|1|255.255.255.255|65535|")];
 
@@ -72,7 +69,6 @@ mangle_eprt_packet(struct sk_buff **pskb,
 
 	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
 
-	*seq += strlen(buffer) - matchlen;
 	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
 					matchlen, buffer, strlen(buffer));
 }
@@ -85,8 +81,7 @@ mangle_epsv_packet(struct sk_buff **pskb,
 		   unsigned int matchoff,
 		   unsigned int matchlen,
 		   struct nf_conn *ct,
-		   enum ip_conntrack_info ctinfo,
-		   u32 *seq)
+		   enum ip_conntrack_info ctinfo)
 {
 	char buffer[sizeof("|||65535|")];
 
@@ -94,14 +89,13 @@ mangle_epsv_packet(struct sk_buff **pskb,
 
 	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
 
-	*seq += strlen(buffer) - matchlen;
 	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
 					matchlen, buffer, strlen(buffer));
 }
 
 static int (*mangle[])(struct sk_buff **, __be32, u_int16_t,
 		       unsigned int, unsigned int, struct nf_conn *,
-		       enum ip_conntrack_info, u32 *seq)
+		       enum ip_conntrack_info)
 = {
 	[NF_CT_FTP_PORT] = mangle_rfc959_packet,
 	[NF_CT_FTP_PASV] = mangle_rfc959_packet,
@@ -116,8 +110,7 @@ static unsigned int nf_nat_ftp(struct sk_buff **pskb,
 			       enum nf_ct_ftp_type type,
 			       unsigned int matchoff,
 			       unsigned int matchlen,
-			       struct nf_conntrack_expect *exp,
-			       u32 *seq)
+			       struct nf_conntrack_expect *exp)
 {
 	__be32 newip;
 	u_int16_t port;
@@ -145,8 +138,7 @@ static unsigned int nf_nat_ftp(struct sk_buff **pskb,
 	if (port == 0)
 		return NF_DROP;
 
-	if (!mangle[type](pskb, newip, port, matchoff, matchlen, ct, ctinfo,
-			  seq)) {
+	if (!mangle[type](pskb, newip, port, matchoff, matchlen, ct, ctinfo)) {
 		nf_conntrack_unexpect_related(exp);
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 3357642..09add2f 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -48,8 +48,7 @@ unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
 				enum nf_ct_ftp_type type,
 				unsigned int matchoff,
 				unsigned int matchlen,
-				struct nf_conntrack_expect *exp,
-				u32 *seq);
+				struct nf_conntrack_expect *exp);
 EXPORT_SYMBOL_GPL(nf_nat_ftp_hook);
 
 #if 0
@@ -521,7 +520,7 @@ static int help(struct sk_buff **pskb,
 	nf_nat_ftp = rcu_dereference(nf_nat_ftp_hook);
 	if (nf_nat_ftp && ct->status & IPS_NAT_MASK)
 		ret = nf_nat_ftp(pskb, ctinfo, search[dir][i].ftptype,
-				 matchoff, matchlen, exp, &seq);
+				 matchoff, matchlen, exp);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
 		if (nf_conntrack_expect_related(exp) != 0)
