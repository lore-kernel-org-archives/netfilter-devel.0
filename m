From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/6]: Fill hole in netfilter skb fields on 64bit
Date: Sun, 26 Sep 2004 23:52:04 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41573A04.3080203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050404020000000200070505"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050404020000000200070505
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch moves nfctinfo next to nfcache to avoid two holes
in the netfilter skb fields. There already was a hole on 64-bit
architectures before removing struct nf_ct_info, the nfctinfo
field is now moved into this hole, so it doesn't cost anything on
64-bit architectures. I also attached a map of the skb layout
on 32/64 bit architectures in case someone finds it useful.



--------------050404020000000200070505
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/26 23:13:21+02:00 kaber@coreworks.de 
#   [NETFILTER]: Fill hole in netfilter skb fields on 64bit
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/skbuff.h
#   2004/09/26 23:12:57+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fill hole in netfilter skb fields on 64bit
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/skbuff.h b/include/linux/skbuff.h
--- a/include/linux/skbuff.h	2004-09-26 23:22:10 +02:00
+++ b/include/linux/skbuff.h	2004-09-26 23:22:10 +02:00
@@ -250,8 +250,8 @@
 #ifdef CONFIG_NETFILTER
         unsigned long		nfmark;
 	__u32			nfcache;
-	struct nf_conntrack	*nfct;
 	__u32			nfctinfo;
+	struct nf_conntrack	*nfct;
 #ifdef CONFIG_NETFILTER_DEBUG
         unsigned int		nf_debug;
 #endif

--------------050404020000000200070505
Content-Type: text/plain;
 name="skb-layout"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="skb-layout"

				 <--------32bit--------> <--------64bit-------->
				| size	| begin	| end	| size	| begin	| end	|
--------------------------------+-------+-------+-------+-------+-------+-------+
struct sk_buff *next		| 4	| 0	| 4	| 8	| 0	| 8	|
struct sk_buff *prev		| 4	| 4	| 8	| 8	| 8	| 16	|
				|	|	|	|	|	|	|
struct sk_buff_head *list	| 4	| 8	| 12	| 8	| 16	| 24	|
struct sock *sk			| 4	| 12	| 16	| 8	| 24	| 32	|
struct timeval stamp		| 8	| 16	| 24	| 16	| 32	| 48	|
struct net_device *dev		| 4	| 24	| 28	| 8	| 48	| 56	|
struct net_device *input_dev	| 4	| 28	| 32	| 8	| 56	| 64	|
struct net_device *real_dev	| 4	| 32	| 36	| 8	| 64	| 72	|
				|	|	|	|	|	|	|
union h				| 4	| 36	| 40	| 8	| 72	| 80	|
union nh			| 4	| 40	| 44	| 8	| 80	| 88	|
union mac			| 4	| 44	| 48	| 8	| 88	| 96	|
				|	|	|	|	|	|	|
struct dst_entry *dst		| 4	| 48	| 52	| 8	| 96	| 104	|
struct sec_path *sp		| 4	| 52	| 56	| 8	| 104	| 112	|
				|	|	|	|	|	|	|
char cb[40]			| 40	| 56	| 96	| 40	| 112	| 152	|
				|	|	|	|	|	|	|
unsigned int len		| 4	| 96	| 100	| 4	| 152	| 156	|
unsigned int data_len		| 4	| 100	| 104	| 4	| 156	| 160	|
unsigned int mac_len		| 4	| 104	| 108	| 4	| 160	| 164	|
unsigned int csum		| 4	| 108	| 112	| 4	| 164	| 168	|
unsigned char local_df		| 1	| 112	| 113	| 1	| 168	| 169	|
unsigned char cloned		| 1	| 113	| 114	| 1	| 169	| 170	|
unsigned char pkt_type		| 1	| 114	| 115	| 1	| 170	| 171	|
unsigned char ip_summed		| 1	| 115	| 116	| 1	| 171	| 172	|
__u32 priority			| 4	| 116	| 120	| 4	| 172	| 176	|
unsigned short protocol		| 2	| 120	| 122	| 2	| 176	| 178	|
unsigned short security		| 2	| 122	| 124	| 2	| 178	| 180	|
				|	|	|	|	|	|	|
void *destructor		| 4	| 124	| 128	| 8	| 184	| 192	| <- 4b hole on 64bit
				|	|	|	|	|	|	|
#ifdef CONFIG_NETFILTER		|	|	|	|	|	|	|
unsigned long nfmark		| 4	| 128	| 132	| 8	| 192	| 200	|
__u32 nfcache			| 4	| 132	| 136	| 4	| 200	| 204	|
__u32 nfctinfo			| 4	| 136	| 140	| 4	| 204	| 208	|
struct nf_conntrack *nfct	| 4	| 140	| 144	| 8	| 208	| 216	|
#ifdef CONFIG_BRIDGE_NETFILTER	|	|	|	|	|	|	|
struct nf_bridge_info *nf_bridge| 4	| 144	| 148	| 8	| 216	| 224	|
#endif CONFIG_BRIDGE_NETFILTER	|	|	|	|	|	|	|
#endif CONFIG_NETFILTER		|	|	|	|	|	|	|
				|	|	|	|	|	|	|
#ifdef CONFIG_HIPPI		|	|	|	|	|	|	|
union { __u32 iffield } private	| 4	| 148	| 152	| 4	| 224	| 228	|
#endif CONFIG_HIPPI		|	|	|	|	|	|	|
				|	|	|	|	|	|	|
#ifdef CONFIG_NET_SCHED		|	|	|	|	|	|	|
__u32 tc_index			| 4	| 152	| 156	| 4	| 228	| 232	|
#ifdef CONFIG_NET_CLS_ACT	|	|	|	|	|	|	|
__u32 tc_verd			| 4	| 156	| 160	| 4	| 232	| 236	|
__u32 tc_classid		| 4	| 160	| 164	| 4	| 236	| 240	|
#endif CONFIG_NET_CLS_ACT	|	|	|	|	|	|	|
#endif CONFIG_NET_SCHED		|	|	|	|	|	|	|
				|	|	|	|	|	|	|
unsigned int truesize		| 4	| 164	| 168	| 4	| 240	| 244	|
atomic_t users			| 4	| 168	| 172	| 4	| 244	| 248	|
unsigned char *head		| 4	| 172	| 176	| 8	| 248	| 256	|
unsigned char *data		| 4	| 176	| 180	| 8	| 256	| 264	|
unsigned char *tail		| 4	| 180	| 184	| 8	| 264	| 272	|
unsigned char *end		| 4	| 184	| 188	| 8	| 272	| 280	|
--------------------------------+-------+-------+-------+-------+-------+-------+

--------------050404020000000200070505--
