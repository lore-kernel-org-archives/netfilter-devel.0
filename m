From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim] tcpsession: send ACK after second FIN/ACK
Date: Thu, 22 Sep 2005 10:22:16 +0200
Message-ID: <20050922082216.GB21617@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PmA2V3Z32TCmWXqI"
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


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

the "tcpsession CLOSE" command misses the final "ACK" packet, this
patch implements it.  Without it, netfilter will not clean up its
conntrack tables correctly after the TCP connection is closed.

Max


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfsim-send_ack_after_fin_ack.patch"

Thu Sep 15 00:03:36 CEST 2005  max@duempel.org
  * send ACK after second FIN/ACK
diff -rN -u old-nfsim-0/tools/tcpsession.c new-nfsim-0/tools/tcpsession.c
--- old-nfsim-0/tools/tcpsession.c	2005-09-22 10:23:52.000000000 +0200
+++ new-nfsim-0/tools/tcpsession.c	2005-09-22 10:23:52.000000000 +0200
@@ -239,6 +239,10 @@
 	out->ack++;
 	if (!tcp_send(out, in, 0, "FIN/ACK", NULL, 0, NULL))
 		return false;
+	out->seq++;
+	in->ack++;
+	if (!tcp_send(in, out, 0, "ACK", NULL, 0, NULL))
+		return false;
 	talloc_free(curr);
 	curr = NULL;
 	return true;


--PmA2V3Z32TCmWXqI--
