From: Thomas Woerner <twoerner@redhat.com>
Subject: [PATCH] iptables-restore -c faults if there are no counters
Date: Thu, 26 Feb 2004 15:14:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403DFF37.4000302@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090003080607040801040201"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------090003080607040801040201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Hello,


the function parse_counters does not check the input string and is producing a 
fault if it is NULL.


Thanks,
Thomas

-- 
Thomas Woerner, Software Engineer      Phone: +49-711-96437-0
Red Hat GmbH                           Fax  : +49-711-96437-111
Hauptstaetterstr. 58                   Email: twoerner@redhat.com
D-70178 Stuttgart                      Web  : http://www.redhat.de/

--------------090003080607040801040201
Content-Type: text/x-patch;
 name="iptables-1.2.9-counters.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.2.9-counters.patch"

--- iptables-1.2.9/iptables-restore.c.counters	2004-02-26 14:52:48.110211624 +0100
+++ iptables-1.2.9/iptables-restore.c	2004-02-26 15:10:24.495616632 +0100
@@ -71,7 +71,11 @@
 
 int parse_counters(char *string, struct ipt_counters *ctr)
 {
-	return (sscanf(string, "[%llu:%llu]", &ctr->pcnt, &ctr->bcnt) == 2);
+	if (string != NULL)
+		return (sscanf(string, "[%llu:%llu]", &ctr->pcnt, &ctr->bcnt)
+			== 2);
+	else
+		return (0 == 2);
 }
 
 /* global new argv and argc */

--------------090003080607040801040201--
