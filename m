From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/3] missing refcount handling for expectation
Date: Wed, 07 Sep 2005 11:07:47 +0900 (JST)
Message-ID: <200509070207.j8727mG6018814@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Sep__7_11_07_47_2005_777)--"
Content-Transfer-Encoding: 7bit
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

----Next_Part(Wed_Sep__7_11_07_47_2005_777)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch is for nf_conntrack and increments refcount of expectation when
adding it to list. This prevents refcount from being 0 while expectation is
linked, in the case of putting it before unlinking it. This handling is
missing in only nf_conntrack, so no need to apply this to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Wed_Sep__7_11_07_47_2005_777)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-exp-refcount-for-list.patch"

[NETFILTER] missing refcount handling for expectation list

This patch is for nf_conntrack and increments refcount of expectation when
adding it to list. This prevents refcount from being 0 while expectation is
linked, in the case of putting it before unlinking it. This handling is
missing in only nf_conntrack, so no need to apply this to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit bb499fcb241df2c6dc2f0b6244ba664ed6b1bf87
tree 26cf107663a6a496ccbe9ae3131dea41656b6f36
parent 4ebe8f4845d2376e10b3984ab5bcbad5dc54e27f
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 07 Sep 2005 09:05:16 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 07 Sep 2005 09:05:16 +0900

 net/netfilter/nf_conntrack_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -393,6 +393,7 @@ static void unlink_expect(struct nf_conn
 	list_del(&exp->list);
 	NF_CT_STAT_INC(expect_delete);
 	exp->master->expecting--;
+	nf_conntrack_expect_put(exp);
 }
 
 static void expectation_timed_out(unsigned long ul_expect)
@@ -1093,6 +1094,7 @@ static void nf_conntrack_expect_insert(s
 	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
+	atomic_inc(&exp->use);
 	NF_CT_STAT_INC(expect_create);
 }
 

----Next_Part(Wed_Sep__7_11_07_47_2005_777)----
