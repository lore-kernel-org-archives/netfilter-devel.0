From: Tom Eastep <teastep@shorewall.net>
Subject: [PATCH} iptables-save and -m conntrack (Repost)
Date: Tue, 04 May 2004 11:06:12 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4097DB94.1020505@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040505010405010101090201"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
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
--------------040505010405010101090201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Currently, the iptables-save output produced by the connection tracking 
match module contains DNS names rather than IP addresses. This causes a 
subsequent iptables-restore using that output to fail. The attached 
trivial patch corrects the problem.

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net


--------------040505010405010101090201
Content-Type: text/plain;
 name="iptables-1.2.9.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.2.9.diff"

--- extensions/libipt_conntrack.c~	2003-10-07 11:54:30.000000000 -0700
+++ extensions/libipt_conntrack.c	2004-04-28 19:01:08.000000000 -0700
@@ -504,7 +504,7 @@
 /* Saves the matchinfo in parsable form to stdout. */
 static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
-	matchinfo_print(ip, match, 0, "--");
+	matchinfo_print(ip, match, 1, "--");
 }
 
 static

--------------040505010405010101090201--
