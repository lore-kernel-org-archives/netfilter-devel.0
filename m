From: Patrick McHardy <kaber@trash.net>
Subject: Re: bugs in ftp conntrack
Date: Thu, 24 May 2007 20:16:05 +0200
Message-ID: <4655D665.1050905@trash.net>
References: <379815077.04066@tsinghua.org.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000109010201000009020600"
Cc: netfilter-devel@lists.netfilter.org
To: "YU, Haitao" <yuhaitao@tsinghua.org.cn>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <379815077.04066@tsinghua.org.cn>
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
--------------000109010201000009020600
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

YU, Haitao wrote:
> If the order of ftp packets are wrong, function find_nl_seq() in
> net/ipv4/netfilter/ip_conntrack_ftp.c will make mistake.
> 
> i.e., consider three ftp packets: "port", "list" and "noop", 
> if the "list" and "noop" packets reach firewall before "port" packet,
> then info->seq_aft_nl will record  the sequence of "noop". Kenerl will
> not parse "port" packet because the seq does not match the recored one .


There's not much we can do about this case, we already keep a history
of sequence numbers. As you note below that code is pretty broken
currently, but I have patches queued to fix it (attached to this mail).

> If kernel can't trace expect connection, then the attack described in
> [phrack-63, 0x13] will happen.


Shouldn't be, we don't assign helpers to expected connections except
when the first helper explicitly want us to.

> Another problem is if the packet length is changed bye NAT, then the
> next packet will not be parsed. So kernel can not parse the 2nd "port"
> packet of two continual "port" packets. Though it's impossible in legal
> ftp connection, and I also don't know how to use this to hack firewall.


Good catch, that is broken since about 2.6.11.

> Third, the value of "oldest" in function udpate_bl_seq() seem unchanged
> after four packets.


Its changes randomly because the saved sequence number is compared to
the index of the oldest entry.


--------------000109010201000009020600
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_conntrack_ftp: fix newline sequence number update

When trying to locate the oldest entry in the history of newline character
sequence numbers, the sequence number of the current entry is incorrectly
compared with the index of the oldest sequence number instead of the number
itself.

Additionally it is not made sure that the current sequence number really
is after the oldest known one.

Based on report by YU, Haitao <yuhaitao@tsinghua.org.cn>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ce7fed0c554b66ea7ea36abb91d69fa74fa3a3e2
tree 156e9de9fc8105096623d98506b0c563f1eefbca
parent ff33b5e57721b1f2a7c8b9fcef32acdb55816131
author Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 20:05:19 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 20:05:19 +0200

 net/netfilter/nf_conntrack_ftp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index a186799..3357642 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -335,15 +335,17 @@ static void update_nl_seq(u32 nl_seq, struct nf_ct_ftp_master *info, int dir,
 		if (info->seq_aft_nl[dir][i] == nl_seq)
 			return;
 
-		if (oldest == info->seq_aft_nl_num[dir]
-		    || before(info->seq_aft_nl[dir][i], oldest))
+		if (oldest == info->seq_aft_nl_num[dir] ||
+		    before(info->seq_aft_nl[dir][i],
+		    	   info->seq_aft_nl[dir][oldest]))
 			oldest = i;
 	}
 
 	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
 		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
-	} else if (oldest != NUM_SEQ_TO_REMEMBER) {
+	} else if (oldest != NUM_SEQ_TO_REMEMBER &&
+		   after(nl_seq, info->seq_aft_nl[dir][oldest])) {
 		info->seq_aft_nl[dir][oldest] = nl_seq;
 		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
 	}

--------------000109010201000009020600
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: nf_conntrack_ftp: fix newline sequence number calculation

When the packet size is changed by the FTP NAT helper, the connection
tracking helper adjusts the sequence number of the newline character
by the size difference. This is wrong because NAT sequence number
adjustment happens after helpers are called, so the unadjusted number
is compared to the already adjusted one.

Based on report by YU, Haitao <yuhaitao@tsinghua.org.cn>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4aa8feb60ca94d73f6ebb186b088e78970e2dcc7
tree 3245b16e02ec807d8535ad3e84c9fa974ba68e85
parent ce7fed0c554b66ea7ea36abb91d69fa74fa3a3e2
author Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 20:05:57 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 20:05:57 +0200

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

--------------000109010201000009020600--
