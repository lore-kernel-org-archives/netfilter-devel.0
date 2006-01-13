From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] fix nf_conntrack_netlink expectation dumping/event
 notification
Date: Fri, 13 Jan 2006 18:38:05 +0900 (JST)
Message-ID: <200601130938.k0D9c6s3001479@toshiba.co.jp>
References: <43C76BA7.9080204@trash.net>
	<200601130902.k0D92fVM026246@toshiba.co.jp>
	<43C76D22.8050805@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Jan_13_18_38_05_2006_600)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43C76D22.8050805@trash.net>
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

----Next_Part(Fri_Jan_13_18_38_05_2006_600)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


From: Patrick McHardy <kaber@trash.net>
Date: Fri, 13 Jan 2006 10:04:34 +0100

> > I think that root caurse is missing check at __nf_ct_{l3}proto_find().
> > I'll write patch for it. It will free people from taking care about
> > expectation mask.
> 
> I agree, that seems to be the best solution.

Here you are. How about this ?

-- Yasuyuki Kozakai


----Next_Part(Fri_Jan_13_18_38_05_2006_600)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="check-l3num.patch"

[NETFILTER] nf_conntrack: check address family when finding protocol module

__nf_conntrack_{l3}proto_find() doesn't check the passed protocol family,
then it's possible to touch out of the array which has only AF_MAX items.

spotted by Pablo Neira Ayuso.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 878d327ca0ca7983e3876cbdeb03679e801b637e
tree f559501a7202e5ec10106821f927460e5cc2bc11
parent 2e4e6a17af35be359cc8f1c924f8f198fbd478cc
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 13 Jan 2006 18:27:38 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 13 Jan 2006 18:27:38 +0900

 include/net/netfilter/nf_conntrack_l3proto.h |   15 +++++++++------
 net/netfilter/nf_conntrack_core.c            |    2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 67856eb..417d6bd 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -88,12 +88,6 @@ extern struct nf_conntrack_l3proto *nf_c
 extern int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto);
 extern void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
 
-static inline struct nf_conntrack_l3proto *
-__nf_ct_l3proto_find(u_int16_t l3proto)
-{
-	return nf_ct_l3protos[l3proto];
-}
-
 extern struct nf_conntrack_l3proto *
 nf_ct_l3proto_find_get(u_int16_t l3proto);
 
@@ -103,4 +97,13 @@ extern void nf_ct_l3proto_put(struct nf_
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 extern struct nf_conntrack_l3proto nf_conntrack_generic_l3proto;
+
+static inline struct nf_conntrack_l3proto *
+__nf_ct_l3proto_find(u_int16_t l3proto)
+{
+	if (unlikely(l3proto > AF_MAX))
+		return &nf_conntrack_generic_l3proto;
+	return nf_ct_l3protos[l3proto];
+}
+
 #endif /*_NF_CONNTRACK_L3PROTO_H*/
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 62bb509..9a147dd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -188,7 +188,7 @@ extern struct nf_conntrack_protocol nf_c
 struct nf_conntrack_protocol *
 __nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
 {
-	if (unlikely(nf_ct_protos[l3proto] == NULL))
+	if (unlikely(l3proto > AF_MAX || nf_ct_protos[l3proto] == NULL))
 		return &nf_conntrack_generic_protocol;
 
 	return nf_ct_protos[l3proto][protocol];

----Next_Part(Fri_Jan_13_18_38_05_2006_600)----
