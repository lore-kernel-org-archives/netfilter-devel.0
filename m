From: Tom Eastep <teastep@shorewall.net>
Subject: iptables-save and match formatting
Date: Wed, 28 Apr 2004 20:48:44 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40907B1C.8060308@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070900000903000904000808"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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
--------------070900000903000904000808
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

My project for the evening is to integrate Shorewall with 
iptables-save/iptables-restore. While debugging this facility, I found 
that iptables-save was generating DNS names when outputing "-m conntrack 
--ctorigdst <address>". The attached patch corrects the problem for me 
but may have undesirable side effects not obvious to the casual hacker 
such as myself :-)

-Tom

PS -- I'm using a Windoze system in the family room while watching a 
hockey game so the patch may need 'dos2unix'.

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net



--------------070900000903000904000808
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

--------------070900000903000904000808--
