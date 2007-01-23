From: "Eric Leblond" <eric@inl.fr>
Subject: Resend: [Patch 2/2] libnetfilter_queue and iface conversion to
 string
Date: Tue, 23 Jan 2007 22:17:02 +0100 (CET)
Message-ID: <15205.90.13.189.211.1169587022.squirrel@mail.inl.fr>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163191.8926.20.camel@localhost> <45B0E2EE.1060500@trash.net>
	<1169223478.8926.35.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20070123221702_93533"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1169223478.8926.35.camel@localhost>
To: "Patrick McHardy" <kaber@trash.net>
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

------=_20070123221702_93533
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

Here's the patch which adapts libnetfilter_queue to last sent patch.

BR,
--
Eric
------=_20070123221702_93533
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
 
+extern char *nfq_get_indev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad);
+extern char *nfq_get_physindev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad);
+extern char *nfq_get_outdev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad);
+extern char *nfq_get_physoutdev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad);
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
 
+char *nfq_get_indev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_indev(nfad);
+	return nlif_index_2name(nlif_inst, ifindex);
+}
+
+char *nfq_get_physindev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_physindev(nfad);
+	return nlif_index_2name(nlif_inst, ifindex);
+}
+
+char *nfq_get_outdev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_outdev(nfad);
+	return nlif_index_2name(nlif_inst, ifindex);
+}
+
+char *nfq_get_physoutdev_name(struct nlif_inst *nlif_inst, struct nfq_data *nfad)
+{
+	u_int32_t ifindex = nfq_get_physoutdev(nfad);
+	return nlif_index_2name(nlif_inst, ifindex);
+}
+
+
 struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 {
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
------=_20070123221702_93533--
