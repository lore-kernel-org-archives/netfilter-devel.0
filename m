From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: fixed the bug of tracking TCP sequence number in ftp module
Date: Thu, 10 Mar 2005 06:46:34 +0900 (JST)
Message-ID: <200503092146.j29LkY7a006055@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Mar_10_06:46:34_2005_359)--"
Content-Transfer-Encoding: 7bit
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

----Next_Part(Thu_Mar_10_06:46:34_2005_359)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

TCP sequence number is 32bits.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozkaai@toshiba.co.jp>

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Mar_10_06:46:34_2005_359)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ct_ftp_seq.patch"

--- linux-2.6.11/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-10 05:48:22.000000000 +0900
+++ linux-2.6.11-fixed/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-10 05:54:30.000000000 +0900
@@ -252,7 +252,7 @@
 }
 
 /* Look up to see if we're just after a \n. */
-static int find_nl_seq(u16 seq, const struct ip_ct_ftp_master *info, int dir)
+static int find_nl_seq(u32 seq, const struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i;
 
@@ -263,7 +263,7 @@
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir)
+static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 

----Next_Part(Thu_Mar_10_06:46:34_2005_359)----
