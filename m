From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: nf_conntrack_ftp: don't call NAT helper for unNATed
 connections
Date: Sun, 05 Nov 2006 00:04:47 +0100
Message-ID: <454D1C8F.5060302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040100020009010400050303"
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
--------------040100020009010400050303
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Small fix to the FTP conntrack helper not to call the NAT
helper for IPv6 (or other unNATed) packets. On top of
the previous patches.



--------------040100020009010400050303
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_conntrack_ftp: don't call NAT helper for unNATed connections

Since both IPv4 and IPv6 are handled by the connection tracking helper but
only IPv4 supports NAT we must make sure not to call the NAT helper for
unNATed connections.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 49993257192a278f6dc7f288e6ef62059ba88762
tree 8bb4d24ab3b5a0325198c5fa0959d44b0841f9c7
parent aa3104784034fe4a9971de642e962c18b51f5a00
author Patrick McHardy <kaber@trash.net> Sat, 04 Nov 2006 21:29:22 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 04 Nov 2006 21:29:22 +0100

 net/netfilter/nf_conntrack_ftp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 10836fc..84b3f2a 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -520,7 +520,7 @@ static int help(struct sk_buff **pskb,
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
-	if (nf_nat_ftp_hook)
+	if (nf_nat_ftp_hook && ct->status & IPS_NAT_MASK)
 		ret = nf_nat_ftp_hook(pskb, ctinfo, search[dir][i].ftptype,
 				      matchoff, matchlen, exp, &seq);
 	else {

--------------040100020009010400050303--
