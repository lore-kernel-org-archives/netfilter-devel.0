From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] x_tables, take 2
Date: Sat, 22 Oct 2005 03:52:41 +0900 (JST)
Message-ID: <200510211852.j9LIqgGq022755@toshiba.co.jp>
References: <20051015193249.GA5545@rama.0sec>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Oct_22_03_52_41_2005_377)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051015193249.GA5545@rama.0sec>
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

----Next_Part(Sat_Oct_22_03_52_41_2005_377)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Sat, 15 Oct 2005 21:32:49 +0200

> I've actually managed to get some more unfication done. 
> 
> There is now no more need to export the xt_mutex[] and xt_tables[] array
> symbols, one of the main problems that were present with the old 'take 1'.
> 
> Unification has now also been implemented for layer4 matches such as
> tcp/udp/dccp/sctp.

Great.

> This is in no way meant to be applied at this stage.  I just want to get
> some feedback (and testing).

Please apply attached patch to fix holding mutex when registering table.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

And xt_CLASSIFY.c seems to be missing in your tree. I imagine that you wrote it
but didn't add it.

Regards,

-- Yasuyuki Kozakai

----Next_Part(Sat_Oct_22_03_52_41_2005_377)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="xtables-lock.patch"

[NETFILTER] fix helding lock at registration of xtable.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit eb0ac789814dde986d88506dfce150186dc0c965
tree 85bfba36322c59647b680248330e6182c7ce8ea4
parent 27a542d5a0803a787d695acdb6c0a8b8101db071
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 21 Oct 2005 01:53:36 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 21 Oct 2005 01:53:36 +0900

 net/netfilter/x_tables.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -317,7 +317,6 @@ int xt_register_table(struct xt_table *t
 	rwlock_init(&table->lock);
 	list_prepend(&xt_tables[table->af], table);
 
-	return 0;
  unlock:
 	up(&xt_mutex[table->af]);
 	return ret;

----Next_Part(Sat_Oct_22_03_52_41_2005_377)----
