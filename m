From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] nfnetlink: Fix calculation of minimum message length
Date: Sun, 04 Dec 2005 01:52:42 +0900 (JST)
Message-ID: <200512031652.jB3GqhpX021980@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Dec__4_01_52_42_2005_026)--"
Content-Transfer-Encoding: 7bit
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

----Next_Part(Sun_Dec__4_01_52_42_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

At least, valid nfnetlink message should have nlmsghdr and nfgenmsg.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sun_Dec__4_01_52_42_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-nfnetlink.patch"

[NETFILTER] nfnetlink: Fix calculation of minimum message length

At least, valid nfnetlink message should have nlmsghdr and nfgenmsg.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 83535e538f30e66a20c040ff2c20170c0df23b0e
tree 90af221810d8ed68de2fa38d13a34088d35d1fa6
parent b80e4873d096c32b1c941b66cbfdaf1cf9bf8d8d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 27 Nov 2005 02:49:03 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 27 Nov 2005 02:49:03 +0900

 net/netfilter/nfnetlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index a60c59b..9805514 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -162,7 +162,7 @@ nfnetlink_check_attributes(struct nfnetl
 		return -EINVAL;
 	}
 
-	min_len = NLMSG_ALIGN(sizeof(struct nfgenmsg));
+	min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	if (unlikely(nlh->nlmsg_len < min_len))
 		return -EINVAL;
 

----Next_Part(Sun_Dec__4_01_52_42_2005_026)----
