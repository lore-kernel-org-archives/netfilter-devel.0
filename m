From: Patrick McHardy <kaber@trash.net>
Subject: [JHASH 15/22]: Use const in jhash2
Date: Wed, 14 Mar 2007 09:50:38 +0100 (MET)
Message-ID: <20070314085023.15282.19181.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[JHASH]: Use const in jhash2

Use const to avoid forcing users to cast const data.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2fdc283757d6f33fda2d4d86a51abce3d155bb22
tree b032ab64f7219db843f68b291ff28993e9dc441b
parent f7ec69deeb727422f3e7b2aec0e89a411c165d81
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:26:09 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:31:39 +0100

 include/linux/jhash.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/jhash.h b/include/linux/jhash.h
index 82c7ae4..2a2f99f 100644
--- a/include/linux/jhash.h
+++ b/include/linux/jhash.h
@@ -84,7 +84,7 @@ static inline u32 jhash(const void *key,
 /* A special optimized version that handles 1 or more of u32s.
  * The length parameter here is the number of u32s in the key.
  */
-static inline u32 jhash2(u32 *k, u32 length, u32 initval)
+static inline u32 jhash2(const u32 *k, u32 length, u32 initval)
 {
 	u32 a, b, c, len;
 
