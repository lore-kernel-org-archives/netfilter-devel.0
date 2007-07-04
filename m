From: Robie Basak <robie@8networks.co.uk>
Subject: Re: [PATCH] Building nth and random matches
Date: Wed, 4 Jul 2007 10:52:45 +0100
Message-ID: <20070704095244.GA21487@alpha.winnipeg.8networks.co.uk>
References: <468A244B.20806@8networks.co.uk>
	<Pine.LNX.4.64.0707031233030.1536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707031233030.1536@fbirervta.pbzchgretzou.qr>
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

On Tue, Jul 03, 2007 at 12:33:17PM +0200, Jan Engelhardt wrote:
> 
> On Jul 3 2007 11:26, Robie Basak wrote:
> >Subject: Building nth and random matches
> 
> Because they are named statistic now...

Aha - thanks!

Though in that case, have a patch to add some documentation :)

diff -urN iptables.orig/extensions/libipt_statistic.man iptables/extensions/libipt_statistic.man
--- iptables.orig/extensions/libipt_statistic.man	1970-01-01 01:00:00.000000000 +0100
+++ iptables/extensions/libipt_statistic.man	2007-07-04 10:46:32.000000000 +0100
@@ -0,0 +1,33 @@
+This module matches some statistical subset of packets.
+.TP
+.BI "--mode " "nth|random"
+Specify which statistical mode to use as follows:
+.RS
+.TP
+.BR "nth" :
+This option matches every `n'th packet
+.RS
+.TP
+.BI "--every " n
+Match every `n'th packet
+.TP
+.BI "--packet " p
+.I (optional)
+Initial counter value (0 <=
+.I p
+<=
+.I n
+- 1, default 0)
+.RE
+.RE
+.RS
+.TP
+.BR "random" :
+This option randomly matches a certain fraction of all packets.
+.RS
+.TP
+.BI "--probability " p
+.I p
+must be between 0 and 1
+.RE
+.RE
