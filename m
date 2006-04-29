From: Evan Miller <evanm@frap.net>
Subject: Patch to libipt_DNAT.man
Date: Fri, 28 Apr 2006 20:30:09 -0700
Message-ID: <20060429033009.GA10032@frap.net>
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

I had to dig through source to find the --to-destination :port syntax (no
mangle of address). This patch to the manpage saves others the trouble,
please accept it or a similar change:

--- -   2006-04-28 20:28:04.454798000 -0700
+++ libipt_DNAT.man     2006-04-28 20:24:22.484755056 -0700
@@ -10,7 +10,7 @@
 also be mangled), and rules should cease being examined.  It takes one
 type of option:
 .TP
-.BR "--to-destination " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
+.BR "--to-destination " "[\fIipaddr\fP][-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
 which can specify a single new destination IP address, an inclusive
 range of IP addresses, and optionally, a port range (which is only
 valid if the rule also specifies
@@ -18,7 +18,8 @@
 or
 .BR "-p udp" ).
 If no port range is specified, then the destination port will never be
-modified.
+modified. If no IP address is specified then only the destination port
+will be modified.
 .RS
 .PP
 In Kernels up to 2.6.10 you can add several --to-destination options.  For
