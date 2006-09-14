From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.18]: xt_quota: add missing module aliases
Date: Thu, 14 Sep 2006 23:02:15 +0200
Message-ID: <4509C357.6060609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090100070505040901010209"
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
--------------090100070505040901010209
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

following a small fix for the newly introduced quota match.
Please apply to 2.6.18 if still possible, thanks.


--------------090100070505040901010209
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: xt_quota: add missing module aliases

Add missing aliases for ipt_quota and ip6t_quota to make autoload work.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 61123a6eb07ed92036e40517defa1c2d514ce2a1
tree b02a494237442002721fa3aeaba952419cd1cac0
parent c336923b668fdcf0312efbec3b44895d713f4d81
author Patrick McHardy <kaber@trash.net> Wed, 06 Sep 2006 16:06:08 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 06 Sep 2006 16:06:08 +0200

 net/netfilter/xt_quota.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 4cdba74..be8d3c2 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -11,6 +11,8 @@ #include <linux/netfilter/xt_quota.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
+MODULE_ALIAS("ipt_quota");
+MODULE_ALIAS("ip6t_quota");
 
 static DEFINE_SPINLOCK(quota_lock);
 

--------------090100070505040901010209--
