From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/2] kill unnecessary ntohs to compare tuples
Date: Tue, 16 Aug 2005 19:11:58 +0900 (JST)
Message-ID: <200508161011.j7GABxcg028632@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Aug_16_19_11_58_2005_561)--"
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

----Next_Part(Tue_Aug_16_19_11_58_2005_561)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

This patch kills unnecessary ntohs() in nf_ct_tuple_mask_cmp(). If we need to
take care about byte order here, should use ntohl(). This bug was introduced
when I changed size of 'all' from 16bits to 32bits. But in the first place,
it's not necessary to do that because the byte order of all arguments are
same.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Tue_Aug_16_19_11_58_2005_561)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="kill-ntohs.patch"

diff --git a/include/linux/netfilter/nf_conntrack_tuple.h b/include/linux/netfilter/nf_conntrack_tuple.h
--- a/include/linux/netfilter/nf_conntrack_tuple.h
+++ b/include/linux/netfilter/nf_conntrack_tuple.h
@@ -169,16 +169,14 @@ static inline int nf_ct_tuple_mask_cmp(c
 	int count = 0;
 
         for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-                if ((ntohs(t->src.u3.all[count]) ^
-                     ntohs(tuple->src.u3.all[count])) &
-                     ntohs(mask->src.u3.all[count]))
+                if ((t->src.u3.all[count] ^ tuple->src.u3.all[count]) &
+                    mask->src.u3.all[count])
                         return 0;
         }
 
         for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-                if ((ntohs(t->dst.u3.all[count]) ^
-                     ntohs(tuple->dst.u3.all[count])) &
-                     ntohs(mask->dst.u3.all[count]))
+                if ((t->dst.u3.all[count] ^ tuple->dst.u3.all[count]) &
+                    mask->dst.u3.all[count])
                         return 0;
         }
 

----Next_Part(Tue_Aug_16_19_11_58_2005_561)----
