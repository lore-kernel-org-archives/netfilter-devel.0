From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] FTP sequence tracking try #2
Date: Fri, 1 Apr 2005 08:28:53 -0800
Message-ID: <20050401162853.GA3777@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
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


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Another user pointed out a missing " in the previous patch.  I noticed
I forgot the signoff.  Below fixes both.

Phil

The 2.6.11 changes incorrectly pass seq to a couple of functions as a u16.
In addition, a few DEBUGP statements were broken.

Signed-off-by: Phil Oester <kernel@linuxace.com>



--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ftp1

diff -ru linux-orig/net/ipv4/netfilter/ip_conntrack_ftp.c linux-new/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-02 02:38:38.000000000 -0500
+++ linux-new/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-31 12:47:48.501244792 -0500
@@ -252,7 +252,7 @@
 }
 
 /* Look up to see if we're just after a \n. */
-static int find_nl_seq(u16 seq, const struct ip_ct_ftp_master *info, int dir)
+static int find_nl_seq(u32 seq, const struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i;
 
@@ -263,7 +263,7 @@
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir)
+static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 
@@ -330,9 +330,9 @@
 	/* Look up to see if we're just after a \n. */
 	if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
 		/* Now if this ends in \n, update ftp info. */
-		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u) or %s(%u)\n",
-		       ct_ftp_info->seq_aft_nl[0][dir] 
-		       old_seq_aft_nl_set ? "":"(UNSET) ", old_seq_aft_nl);
+		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s%u\n",
+		       ct_ftp_info->seq_aft_nl[0][dir] ? "":"(UNSET)",
+		       ct_ftp_info->seq_aft_nl[0][dir]);
 		ret = NF_ACCEPT;
 		goto out_update_nl;
 	}
@@ -373,7 +373,7 @@
 		goto out_update_nl;
 	}
 
-	DEBUGP("conntrack_ftp: match `%s' (%u bytes at %u)\n",
+	DEBUGP("conntrack_ftp: match `%.26s' (%u bytes at %u)\n",
 	       fb_ptr + matchoff, matchlen, ntohl(th->seq) + matchoff);
 			 
 	/* Allocate expectation which will be inserted */

--mP3DRpeJDSE+ciuQ--
