From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: fixed debug message in ftp module
Date: Thu, 10 Mar 2005 06:28:15 +0900 (JST)
Message-ID: <200503092128.j29LSF2O027427@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Mar_10_06:28:15_2005_804)--"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Mar_10_06:28:15_2005_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes debug message which notifies wrong sequence number.
old_seq_aft_nl_set is no longer used.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozkaai@toshiba.co.jp>

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Thu_Mar_10_06:28:15_2005_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ct_ftp_dmsg.patch"

--- linux-2.6.11/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-10 05:46:42.000000000 +0900
+++ linux-2.6.11-fixed/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-10 05:48:22.000000000 +0900
@@ -331,8 +331,10 @@
 	if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
 		/* Now if this ends in \n, update ftp info. */
 		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u) or %s(%u)\n",
-		       ct_ftp_info->seq_aft_nl[0][dir] 
-		       old_seq_aft_nl_set ? "":"(UNSET) ", old_seq_aft_nl);
+		       ct_ftp_info->seq_aft_nl_num[dir] > 0 ? "" : "(UNSET)",
+		       ct_ftp_info->seq_aft_nl[dir][0],
+		       ct_ftp_info->seq_aft_nl_num[dir] > 1 ? "" : "(UNSET)",
+		       ct_ftp_info->seq_aft_nl[dir][1]);
 		ret = NF_ACCEPT;
 		goto out_update_nl;
 	}

----Next_Part(Thu_Mar_10_06:28:15_2005_804)----
