From: "Eric Leblond" <eric@inl.fr>
Subject: [Patch 2/2] libnetfilter_queue, iface conversion to string
Date: Thu, 25 Jan 2007 13:16:10 +0100 (CET)
Message-ID: <41024.80.214.249.17.1169727370.squirrel@mail.inl.fr>
References: <1167257854.31765.21.camel@localhost>   
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>   
	<1168296086.12298.6.camel@localhost>   
	<20070109115120.GX7655@prithivi.gnumonks.org>   
	<1169162676.8926.14.camel@localhost>   
	<1169163050.8926.16.camel@localhost> <45B0E24A.7040906@trash.net>   
	<45B10222.1040806@netfilter.org>   
	<20070122123618.GM9631@prithivi.gnumonks.org>
	<59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
	<45B80BFB.2060203@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20070125131610_38493"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45B80BFB.2060203@netfilter.org>
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

------=_20070125131610_38493
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

Here's the updated patch for libnetfilter_queue.

BR
--
Eric Leblond <eric@inl.fr>
------=_20070125131610_38493
Content-Type: text/plain; name="libnetfilter_queue-ifacename.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="libnetfilter_queue-ifacename.diff"

=== include/libnetfilter_queue/libnetfilter_queue.h
==================================================================
--- include/libnetfilter_queue/libnetfilter_queue.h	(revision 5515)
+++ include/libnetfilter_queue/libnetfilter_queue.h	(local)
@@ -80,6 +80,11 @@
 extern u_int32_t nfq_get_outdev(struct nfq_data *nfad);
 extern u_int32_t nfq_get_physoutdev(struct nfq_data *nfad);
 
+extern char *nfq_get_indev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad);
+extern char *nfq_get_physindev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad);
+extern char *nfq_get_outdev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad);
+extern char *nfq_get_physoutdev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad);
+
 extern struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad);
 
 /* return -1 if problem, length otherwise */
=== src/libnetfilter_queue.c
==================================================================
--- src/libnetfilter_queue.c	(revision 5515)
+++ src/libnetfilter_queue.c	(local)
@@ -419,6 +419,31 @@
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, u_int32_t));
 }
 
+char *nfq_get_indev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_indev(nfad);
+	return nlif_index2name(nlif_handle, ifindex);
+}
+
+char *nfq_get_physindev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_physindev(nfad);
+	return nlif_index2name(nlif_handle, ifindex);
+}
+
+char *nfq_get_outdev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_outdev(nfad);
+	return nlif_index2name(nlif_handle, ifindex);
+}
+
+char *nfq_get_physoutdev_name(struct nlif_handle *nlif_handle, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_physoutdev(nfad);
+	return nlif_index2name(nlif_handle, ifindex);
+}
+
+
 struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 {
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
------=_20070125131610_38493--
