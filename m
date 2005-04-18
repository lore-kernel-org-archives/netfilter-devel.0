From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: Fix truncated sequence numbers in FTP helper
Date: Mon, 18 Apr 2005 04:27:52 +0200
Message-ID: <42631B28.8030707@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080608010107040308070008"
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
--------------080608010107040308070008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

these two fixes fix one rather serious and one annoying problem and
should go in 2.6.12.

This first patch fixes truncated sequence numbers in ip_conntrack_ftp,
the types were changed to u16 by some unfortunate patch.


--------------080608010107040308070008
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/09 22:51:34+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Fix truncated sequence numbers in FTP helper
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozkaai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_ftp.c
#   2005/03/09 22:51:26+01:00 yasuyuki.kozakai@toshiba.co.jp +2 -2
#   [NETFILTER]: Fix truncated sequence numbers in FTP helper
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozkaai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-04-18 03:59:47 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-04-18 03:59:47 +02:00
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
 

--------------080608010107040308070008--
