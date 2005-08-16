From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/2] cleanup of unregistering ftp helper in
 init()
Date: Tue, 16 Aug 2005 19:11:37 +0900 (JST)
Message-ID: <200508161011.j7GABcK2028434@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Aug_16_19_11_37_2005_137)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

----Next_Part(Tue_Aug_16_19_11_37_2005_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi, Harald,

This patch is small cleanup to unregister ftp helper when error on
initialization.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>



----Next_Part(Tue_Aug_16_19_11_37_2005_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ftp-unregister.patch"

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -627,6 +627,9 @@ static void __exit fini(void)
 	int i, j;
 	for (i = 0; i < ports_c; i++) {
 		for (j = 0; j < 2; j++) {
+			if (ftp[i][j].me == NULL)
+				continue;
+
 			DEBUGP("nf_ct_ftp: unregistering helper for pf: %d "
 			       "port: %d\n",
 				ftp[i][j].tuple.src.l3num, ports[i]);
@@ -680,20 +683,13 @@ static int __init init(void)
 				printk("nf_ct_ftp: failed to register helper "
 				       " for pf: %d port: %d\n",
 					ftp[i][j].tuple.src.l3num, ports[i]);
-				goto done;
+				fini();
+				return ret;
 			}
 		}
 	}
 
-done:
-	if (i < ports_c) {
-		for (;i >= 0; i--) {
-			for (; j >= 0; j--)
-				nf_conntrack_helper_unregister(&ftp[i][j]);
-			j = 1;
-		}
-	}
-	return ret;
+	return 0;
 }
 
 module_init(init);

----Next_Part(Tue_Aug_16_19_11_37_2005_137)----
