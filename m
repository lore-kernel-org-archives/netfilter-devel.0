From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: Fix oops with pending/23_REJECT-headroom-tcprst.patch
Date: Tue, 11 Mar 2003 04:00:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E6D5151.7050403@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060706060202030102050102"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060706060202030102050102
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
this patch fixes an oops with 23-REJECT-headroom-tcprst.patch (nskb is 
used before copy).

Regards,
Patrick


--------------060706060202030102050102
Content-Type: text/plain;
 name="23_REJECT-headroom-tcprst-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="23_REJECT-headroom-tcprst-fix.diff"

? conntrack-fragments
? linux-2.4.20-clean
? linux-2.4.20-nf
? linux-2.4.20.tar.bz2
? netfilter-nobssinit.diff
Index: patch-o-matic/pending/23_REJECT-headroom-tcprst.patch
===================================================================
RCS file: /cvspublic/netfilter/patch-o-matic/pending/23_REJECT-headroom-tcprst.patch,v
retrieving revision 1.2
diff -u -r1.2 23_REJECT-headroom-tcprst.patch
--- patch-o-matic/pending/23_REJECT-headroom-tcprst.patch	5 Mar 2003 07:51:47 -0000	1.2
+++ patch-o-matic/pending/23_REJECT-headroom-tcprst.patch	11 Mar 2003 02:54:35 -0000
@@ -14,9 +14,9 @@
  		return;
  
 +	/* Routing: if not headed for us, route won't like source */
-+	if (ip_route_output(&rt, nskb->nh.iph->daddr,
-+			    local ? nskb->nh.iph->saddr : 0,
-+			    RT_TOS(nskb->nh.iph->tos) | RTO_CONN,
++	if (ip_route_output(&rt, oldskb->nh.iph->daddr,
++			    local ? oldskb->nh.iph->saddr : 0,
++			    RT_TOS(oldskb->nh.iph->tos) | RTO_CONN,
 +			    0) != 0)
 +		return;
 +

--------------060706060202030102050102--
