From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] English FAQ update
Date: Thu, 26 Jun 2003 13:25:58 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306261322210.27167@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hi,

this patch adds the 'REJECT in PREROUTING' issue item to the FAQ.
And also it fixes a tiny syntax error with sgml tags.

I will send an update to the polish FAQ soon as soon as i resolve some
translation issues. The polish update besides the REJECT issue will
introduce typo fixes and more proper translations.

Regards,
Maciej


diff -u netfilter.orig/documentation/FAQ/netfilter-faq.sgml netfilter/documentation/FAQ/netfilter-faq.sgml
--- netfilter.orig/documentation/FAQ/netfilter-faq.sgml	2003-04-08 21:49:18.000000000 +0200
+++ netfilter/documentation/FAQ/netfilter-faq.sgml	2003-06-26 12:58:57.000000000 +0200
@@ -274,7 +274,7 @@
 <tscreen><verb>
 ip_conntrack: max number of expected connections N of M reached for aaa.aaa.aaa.aaa -> bbb.bbb.bbb.bbb
 </verb></tscreen>
-</sect1>
+
 <p>
 This is normally nothing to worry about, especially if <tt>N</tt> and
 <tt>M</tt> are <tt>1</tt>, and the message is followed by <tt>, reusing</tt>.
@@ -506,6 +506,15 @@
 as well as header+payload of previous packets within this connection.
 </sect1>

+<sect1>Why can't i use the REJECT target in PREROUTING chains?
+<p>
+The REJECT target is for filtering. The filter table has got the
+INPUT/OUPUT/FORWARD chains, therfore the REJECT target can only be used in
+those chains (and sub-chains, naturally).
+
+Netfilter users do not filter packets in the nat or mangle tables.
+</sect1>
+
 </sect>

 <sect>Questions about netfilter development
