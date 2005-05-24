From: Michal Rokos <michal@rokos.info>
Subject: [nf_conntrack] fix gcc-4.0 compilation
Date: Tue, 24 May 2005 13:25:59 +0200
Message-ID: <200505241326.00593.michal@rokos.info>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,

nf_ct_put() shouldn't be marked as inline since it's not inline.

Signed-off-by: Michal Rokos <michal@rokos.info>

Index: include/linux/netfilter/nf_conntrack.h
===================================================================
--- 7e29b6c221553e370f4969432cd4034a0161f37c/include/linux/netfilter/nf_conntrack.h  (mode:100644)
+++ da99e40e104ed32e8cb4126726c524b53651b807/include/linux/netfilter/nf_conntrack.h  (mode:100644)
@@ -218,7 +218,7 @@
 }
 
 /* decrement reference count on a conntrack */
-extern inline void nf_ct_put(struct nf_conn *ct);
+extern void nf_ct_put(struct nf_conn *ct);
 
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_nf_conntrack(void);
