From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/2] use kmalloc()ed buffer in nf_conntrack_ftp.
Date: Sun, 14 Aug 2005 02:33:05 +0900 (JST)
Message-ID: <200508131733.j7DHX6bh000484@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Aug_14_02_33_05_2005_897)--"
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

----Next_Part(Sun_Aug_14_02_33_05_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch synchronizes nf_conntrack with ip_conntrack, and allocates buffer
at init() instead of using BSS area.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----

    [NETFILTER] move conntrack helper buffers from BSS to kmalloc()ed memory

    According to DaveM, it is preferrable to have large data structures be
    allocated dynamically from the module init() function rather than
    putting them as static global variables into BSS.

    This patch moves the conntrack helper packet buffers into dynamically
    allocated memory.

    Signed-off-by: Harald Welte <laforge@netfilter.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sun_Aug_14_02_33_05_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ftp_buffer.patch"

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -34,7 +34,7 @@ MODULE_AUTHOR("Rusty Russell <rusty@rust
 MODULE_DESCRIPTION("ftp connection tracking helper");
 
 /* This is slow, but it's simple. --RR */
-static char ftp_buffer[65536];
+static char *ftp_buffer;
 
 static DEFINE_SPINLOCK(nf_ftp_lock);
 
@@ -633,6 +633,8 @@ static void __exit fini(void)
 			nf_conntrack_helper_unregister(&ftp[i][j]);
 		}
 	}
+
+	kfree(ftp_buffer);
 }
 
 static int __init init(void)
@@ -640,6 +642,10 @@ static int __init init(void)
 	int i, j = -1, ret = 0;
 	char *tmpname;
 
+	ftp_buffer = kmalloc(65536, GFP_KERNEL);
+	if (!ftp_buffer)
+		return -ENOMEM;
+
 	if (ports_c == 0)
 		ports[ports_c++] = FTP_PORT;
 

----Next_Part(Sun_Aug_14_02_33_05_2005_897)----
