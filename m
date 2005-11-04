From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] libnetfilter_queue nfattr[] abstraction
Date: Fri, 04 Nov 2005 01:22:58 +0100
Message-ID: <1131063778.11853.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-SmK2Jpc04kkM54FNOk6L"
Cc: Laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--=-SmK2Jpc04kkM54FNOk6L
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This patch is a proposal to suppress the use of struct nfattr* nfa[]
like params in user level function.

This just hide the low-level structure behind a dummy structure. But
from a user point of view, this structure should remain inchanged even
if the kernel internal are changing.

I've checked the provided test util and NuFW against the modified
library.

BR,
-- 
Eric Leblond <eric@inl.fr>

--=-SmK2Jpc04kkM54FNOk6L
Content-Disposition: attachment; filename=netfilter_queue_datas.patch
Content-Type: text/x-patch; name=netfilter_queue_datas.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

==== Patch <netfilter_queue_datas> level 1
Source: [No source]
Target: f6f8485a-58f1-0310-9e83-9cad51fe5e11:/netfilter/libnetfilter_queue:1217
Log:
introduce nfqnl_q_datas struct to hide struct nfattr * nfa[]
=== include/libnetfilter_queue/libnetfilter_queue.h
==================================================================
--- include/libnetfilter_queue/libnetfilter_queue.h	(revision 1217)
+++ include/libnetfilter_queue/libnetfilter_queue.h	(patch netfilter_queue_datas level 1)
@@ -18,6 +18,10 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 
+struct nfqnl_q_datas {
+	struct nfattr ** data;
+};
+
 struct nfqnl_handle;
 struct nfqnl_q_handle;
 
@@ -27,7 +31,7 @@
 extern int nfqnl_fd(struct nfqnl_handle *h);
 
 typedef int  nfqnl_callback(struct nfqnl_q_handle *gh, struct nfgenmsg *nfmsg,
-		       struct nfattr *nfa[], void *data);
+		       struct nfqnl_q_datas* nfa, void *data);
 
 
 extern struct nfqnl_handle *nfqnl_open(void);
@@ -63,23 +67,23 @@
 /* message parsing function */
 
 extern struct nfqnl_msg_packet_hdr *
-				nfqnl_get_msg_packet_hdr(struct nfattr *nfa[]);
+				nfqnl_get_msg_packet_hdr(struct nfqnl_q_datas* nfa);
 
-extern u_int32_t nfqnl_get_nfmark(struct nfattr *nfa[]);
+extern u_int32_t nfqnl_get_nfmark(struct nfqnl_q_datas* nfa);
 
 extern struct nfqnl_msg_packet_timestamp *
-				nfqnl_get_timestamp(struct nfattr *nfa[]);
+				nfqnl_get_timestamp(struct nfqnl_q_datas* nfa);
 
 /* return 0 if not set */
-extern u_int32_t nfqnl_get_indev(struct nfattr *nfa[]);
-extern u_int32_t nfqnl_get_physindev(struct nfattr *nfa[]);
-extern u_int32_t nfqnl_get_outdev(struct nfattr *nfa[]);
-extern u_int32_t nfqnl_get_physoutdev(struct nfattr *nfa[]);
+extern u_int32_t nfqnl_get_indev(struct nfqnl_q_datas* nfa);
+extern u_int32_t nfqnl_get_physindev(struct nfqnl_q_datas* nfa);
+extern u_int32_t nfqnl_get_outdev(struct nfqnl_q_datas* nfa);
+extern u_int32_t nfqnl_get_physoutdev(struct nfqnl_q_datas* nfa);
 
-extern struct nfqnl_msg_packet_hw *nfqnl_get_packet_hw(struct nfattr *nfa[]);
+extern struct nfqnl_msg_packet_hw *nfqnl_get_packet_hw(struct nfqnl_q_datas* nfa);
 
 /* return 0 if problem */
-extern int nfqnl_get_payload(struct nfattr *nfa[],
+extern int nfqnl_get_payload(struct nfqnl_q_datas* nfa,
 			     char ** data, unsigned int* datalen);
 
 
=== src/libnetfilter_queue.c
==================================================================
--- src/libnetfilter_queue.c	(revision 1217)
+++ src/libnetfilter_queue.c	(patch netfilter_queue_datas level 1)
@@ -112,6 +112,7 @@
 	struct nfqnl_handle *h = data;
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
 	struct nfqnl_q_handle *qh = find_qh(h, queue_num);
+	struct nfqnl_q_datas nfqa;
 
 	if (!qh)
 		return -ENODEV;
@@ -119,7 +120,9 @@
 	if (!qh->cb)
 		return -ENODEV;
 
-	return qh->cb(qh, nfmsg, nfa, qh->data);
+	nfqa.data=nfa;
+
+	return qh->cb(qh, nfmsg, &nfqa, qh->data);
 }
 
 static struct nfnl_callback pkt_cb = {
@@ -318,57 +321,57 @@
  * Message parsing functions 
  *************************************************************/
 
-struct nfqnl_msg_packet_hdr *nfqnl_get_msg_packet_hdr(struct nfattr *nfa[])
+struct nfqnl_msg_packet_hdr *nfqnl_get_msg_packet_hdr(struct nfqnl_q_datas* nfad)
 {
-	return nfnl_get_pointer_to_data(nfa, NFQA_PACKET_HDR,
+	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
 					struct nfqnl_msg_packet_hdr);
 }
 
-uint32_t nfqnl_get_nfmark(struct nfattr *nfa[])
+uint32_t nfqnl_get_nfmark(struct nfqnl_q_datas* nfad)
 {
-	return ntohl(nfnl_get_data(nfa, NFQA_MARK, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, u_int32_t));
 }
 
-struct nfqnl_msg_packet_timestamp *nfqnl_get_timestamp(struct nfattr *nfa[])
+struct nfqnl_msg_packet_timestamp *nfqnl_get_timestamp(struct nfqnl_q_datas* nfad)
 {
-	return nfnl_get_pointer_to_data(nfa, NFQA_TIMESTAMP,
+	return nfnl_get_pointer_to_data(nfad->data, NFQA_TIMESTAMP,
 					struct nfqnl_msg_packet_timestamp);
 }
 
 /* all nfqnl_get_*dev() functions return 0 if not set, since linux only allows
  * ifindex >= 1, see net/core/dev.c:2600  (in 2.6.13.1) */
-u_int32_t nfqnl_get_indev(struct nfattr *nfa[])
+u_int32_t nfqnl_get_indev(struct nfqnl_q_datas* nfad)
 {
-	return ntohl(nfnl_get_data(nfa, NFQA_IFINDEX_INDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, u_int32_t));
 }
 
-u_int32_t nfqnl_get_physindev(struct nfattr *nfa[])
+u_int32_t nfqnl_get_physindev(struct nfqnl_q_datas* nfad)
 {
-	return ntohl(nfnl_get_data(nfa, NFQA_IFINDEX_PHYSINDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, u_int32_t));
 }
 
-u_int32_t nfqnl_get_outdev(struct nfattr *nfa[])
+u_int32_t nfqnl_get_outdev(struct nfqnl_q_datas* nfad)
 {
-	return ntohl(nfnl_get_data(nfa, NFQA_IFINDEX_OUTDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, u_int32_t));
 }
 
-u_int32_t nfqnl_get_physoutdev(struct nfattr *nfa[])
+u_int32_t nfqnl_get_physoutdev(struct nfqnl_q_datas* nfad)
 {
-	return ntohl(nfnl_get_data(nfa, NFQA_IFINDEX_PHYSOUTDEV, u_int32_t));
+	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, u_int32_t));
 }
 
-struct nfqnl_msg_packet_hw *nfqnl_get_packet_hw(struct nfattr *nfa[])
+struct nfqnl_msg_packet_hw *nfqnl_get_packet_hw(struct nfqnl_q_datas* nfad)
 {
-	return nfnl_get_pointer_to_data(nfa, NFQA_HWADDR,
+	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
 					struct nfqnl_msg_packet_hw);
 }
 
-int nfqnl_get_payload(struct nfattr *nfa[], char **data,
+int nfqnl_get_payload(struct nfqnl_q_datas* nfad, char **data,
 		      unsigned int *datalen)
 {
-	*data = nfnl_get_pointer_to_data(nfa, NFQA_PAYLOAD, char*);
+	*data = nfnl_get_pointer_to_data(nfad->data, NFQA_PAYLOAD, char*);
 	if (*data) {
-		*datalen = NFA_PAYLOAD(nfa[NFQA_PAYLOAD-1]);
+		*datalen = NFA_PAYLOAD(nfad->data[NFQA_PAYLOAD-1]);
 		return 1;
 	}
 	return 0;

==== BEGIN SVK PATCH BLOCK ====
Version: svk 1.04 (linux)

eJy9lt9rG0cQx++tlZ4L7UvhApdWUqX49n5LJkIG2zQklZ1EdhuKOVa3c9aR0510t+fEzQXkxpS8
tdDQPhf6TxQKoSX07+ru6odlVZYdJ1QP4nb3O5+Zm92Z2+2ks95CebOp5gpS84f7dxuNXUy93k02
UqwcSEDjRDHzEI4gVPQ8jA8VI49wH9gqxckh0GYTMWNnbLwlDKYQgzO6mMZRqtQFzKUJgIJyq2Xn
LS1v6cw0R2wxHkDkJnFMGR5pyGaLLg/JC+MUXG7KtC2TyzUFGWM9CRLwmL9jxc6DyAszAgI3QQi1
uUSt52nizSt17sycODvTMQUPUnD0JRzNmrpdC4NuBNQPQgqJO8wgAxHpZXxtxjemSWAMUAx7BXnJ
1K2eCPEyd/rYnVjFg0F47FJ4SgmEFIsQdC1HCLoIEUBdB1TPxnWfP3WJgQEjzSeKpdtsr9uS9OqD
V+Gnpx3p9HPpd+n7j08/+Ul66fzQGO1Iuz/aoxf3pQc/m0OXYIpT+VmxkNIk86gc+ZjSRK5UZL6y
Xny+PoxCd6Kr8OXFcXm9WGRRQhLJmRtEVNdcjuEydvzcyO/j5HFphr8Kbq0iJ0AzRlTlwJejmMop
ULmytspREBE4utgP464wHvSO03cCxBl9R/dXIEwR5zT99NAdYO8xw/SeyJU56HRyNXMh2YMk7obQ
n0s2C3c+VHwcxphczGwZ861BlMvk7AL4huFbvo59XDeAEKJiy/K9um7b0LXqs2KzzhWbZvB+sKyq
PNFALqsqc2VVWaKqbNNWrbrq65pheJh4xLdMy1M9HzDGOmsuyDHGZfXm4J8Pv3gZSL8MpdFJUfot
//Xea+ngj+9GJ19LJ+GfH41e7Enw143XUudvZ3Riqm9qhWWp4iNWXsUCS3npxrBXLhYKk22obbV3
Nrf25xZrTa+7XMAptzjwNss8n5hIxjalYa/KHLETUpU/Y9LFrSLl4rOZSeRPdzhmO85yTGMhLXFh
rckeV5vTuBeWZpDzlrgqt7fvb7hfbTy4Wz2rgDI7f8+LxYuOMw36kFLcH8yf6tnkxSfwf3+tO9t3
2ptb37j8f/+/73fNhnP9OHa/fPTwLWK5rPNcP5Cdvc5bZeT9RfK+z0RV9nqYfxfFW7JalMUvi9Lg
MAIimqRYCyESrsRAvn0FX9Ok7W48urezsTn2VGGJEuUvOGX+hS5M+Yza3p7pz0BLO6/obzoBB7yu
4eCuzn6eBZ7tIwDT8Ekd++NrmaWySw1NYpJ5sNCsJhtCY7kXEJAX7gr84dsDRUP5QoMeWzebWq5o
2vgG2hGX0kZjLwqOIElxeNPKWQcfYNpj974EjtggywKiaPV8bYZbdn8bt31Ft3L2SXEMx8Q10/FR
TdWRWquDo9fqrJObyAcTEPoXMkHhlg==
==== END SVK PATCH BLOCK ====

--=-SmK2Jpc04kkM54FNOk6L--
