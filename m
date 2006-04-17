From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] compat_uint64_t type
Date: Mon, 17 Apr 2006 18:03:39 +0200
Message-ID: <4443BC5B.9000407@trash.net>
References: <444132C1.1020604@trash.net>
	<44425DAE.3040007@trash.net>	<20060416.222435.02924300.davem@davemloft.net>	<200604171459.13312.dim@openvz.org>
	<4443B882.70203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030603040806050000000409"
Cc: schwab@suse.de, netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, dev@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <4443B882.70203@trash.net>
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
--------------030603040806050000000409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Dmitry Mishin wrote:
> 
>>This patch introduces compat_uint64_t type, which is required for proper 
>>handling different alignment of structures, containing u64 objects, on 
>>compatible with ia32 64bit platforms and others.

This is my proposed alternative. It assumes all architectures besides
x86 use native alignment for basic types.


--------------030603040806050000000409
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix compat_xt_counters alignment for non-x86

Some (?) non-x86 architectures require 8byte alignment for u_int64_t
even when compiled for 32bit, using u_int32_t in compat_xt_counters
breaks on these architectures, use u_int64_t for everything but x86.

Reported by Andreas Schwab <schwab@suse.de>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2666afe70fb68b9b884f6d3fa7e4236183818028
tree 65eac95933d59a455853245f7442cbb38dc9f19c
parent 2ceefa038e908d5da21aefedae02da4eab1b2787
author Patrick McHardy <kaber@trash.net> Mon, 17 Apr 2006 18:04:37 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 17 Apr 2006 18:04:37 +0200

 include/linux/netfilter/x_tables.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index f6bdef8..3870145 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -361,7 +361,11 @@ struct compat_xt_entry_target
 
 struct compat_xt_counters
 {
+#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
 	u_int32_t cnt[4];
+#else
+	u_int64_t cnt[2];
+#endif
 };
 
 struct compat_xt_counters_info

--------------030603040806050000000409--
