From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 3/4] Use correct type for "ports" module
 parameter
Date: Sat, 24 Sep 2005 19:03:06 +0900 (JST)
Message-ID: <200509241003.j8OA37Ta003284@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Sep_24_19_03_06_2005_446)--"
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

----Next_Part(Sat_Sep_24_19_03_06_2005_446)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This follows ip_conntrack change which fixes helper_names buffer overflow
with large port numbers.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Sep_24_19_03_06_2005_446)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-correct-port.patch"

[NETFILTER] Use correct type for "ports" module parameter in nf_conntrack

This follows ip_conntrack change which fixes helper_names buffer overflow
with large port numbers.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit f9774b4519481307aa98b6e199b92ee087017730
tree ea80a50111eee9316005112da1f32b8e712f4f7d
parent 246533cb01143057d27a24e5972c43a40767c87e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 20 Sep 2005 16:23:45 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 20 Sep 2005 16:23:45 +0900

 net/netfilter/nf_conntrack_ftp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -39,9 +39,9 @@ static char *ftp_buffer;
 static DEFINE_SPINLOCK(nf_ftp_lock);
 
 #define MAX_PORTS 8
-static int ports[MAX_PORTS];
-static short ports_c;
-module_param_array(ports, short, &ports_c, 0400);
+static u_int16_t ports[MAX_PORTS];
+static unsigned int ports_c;
+module_param_array(ports, ushort, &ports_c, 0400);
 
 static int loose;
 module_param(loose, int, 0600);
@@ -621,7 +621,7 @@ out_update_nl:
 }
 
 static struct nf_conntrack_helper ftp[MAX_PORTS][2];
-static char ftp_names[MAX_PORTS][2][10];
+static char ftp_names[MAX_PORTS][2][sizeof("ftp-65535")];
 
 /* don't make this __exit, since it's called from __init ! */
 static void fini(void)

----Next_Part(Sat_Sep_24_19_03_06_2005_446)----
