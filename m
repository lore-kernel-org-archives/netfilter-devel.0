From: Ralf Schlatterbeck <rsc@runtux.com>
Subject: Patch to FAQ: SIP support
Date: Mon, 11 Sep 2006 16:31:03 +0200
Message-ID: <20060911143103.GA27461@runtux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

The FAQ-Entry about SIP support has been out of date for some time now
(it claims there is no sip support, while in fact it is in the current
release candidate for Kernel 2.6.18). This patch fixes the sgml file
which -- I hope -- is the source for the html and text files and should
be used to update the FAQ entry on the home page at
http://www.netfilter.org/documentation/FAQ/netfilter-faq-1.html#ss1.8

Patch is against current SVN trunk version
https://svn.netfilter.org/netfilter/trunk/homepage/output/documentation/FAQ


Index: netfilter-faq.sgml
===================================================================
--- netfilter-faq.sgml	(revision 6668)
+++ netfilter-faq.sgml	(working copy)
@@ -127,14 +127,9 @@
 
 <sect1>Are there any plans to support SIP?
 <p>
-The SIP (Session Initiation Protocol) is quite complex, especially getting it
-acrosss firewalls and NAT devices.  The initial proposal was a proxy
-communicating over FCP (Firewall Control Protocol) with the packet filter.  Now
-an IETF MIDCOM working group has been founded, ... meanwhile, people want to
-use SIP.
-<p>
-The netfilter/iptables team has currently no resources to implement SIP
-conntrack/NAT support, but we're always open for sponsors :)
+An implementation of conntrack and NAT for the SIP (Session Initiation
+Protocol) has been in the patch-o-matic for some time now implemented by
+Christian Hentschel. The implementation will be in Kernel 2.6.18.
 </sect1>
 
 <sect1>Does netfilter/iptables support failover/HA?

Ralf
-- 
Dr. Ralf Schlatterbeck			Tel:   +43/2243/26465-11
Open Source Consulting			Fax:   +43/2243/26465-23
Reichergasse 131			www:   http://www.runtux.com
A-3411 Weidling    			email: office@runtux.com
