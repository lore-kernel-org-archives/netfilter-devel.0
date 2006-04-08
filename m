From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 2/3] [libnetfilter_conntrack] fixed duration connection
Date: Sat, 08 Apr 2006 22:23:27 +0200
Message-ID: <44381BBF.4060605@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E0B6.9040602@inl.fr> <44381602.5090105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000609040208030307030608"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44381602.5090105@trash.net>
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

This is a multi-part message in MIME format.
--------------000609040208030307030608
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Eric Leblond wrote:
> 
>>Hi,
>>
>>This patch add support for the IPS_FIXED_TIMEOUT state.

> I didn't see the patch adding support for this in the kernel. Since
> there is no seperate fixed timeout anymore, this also looks obsolete.
> The way I understood the kernel patch, you would just do two netlink
> operations:
> 
> - set flag FIXED_TIMEOUT
> - change timeout using CTA_TIMEOUT
> 
> Am I missing something?

Clearly not. I was a little bit too tired yesterday and I've done a "svn
diff" in the bad directory. Please ignore previous patch and consider
this far smaller one.

Best regards,
--
Eric Leblond


--------------000609040208030307030608
Content-Type: text/x-patch;
	name="libnetfilter_conntrack_fixed_timeout-flag.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
	filename="libnetfilter_conntrack_fixed_timeout-flag.patch"

Index: include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/libnetfilter_conntrack.h	(révision 6578)
+++ include/libnetfilter_conntrack/libnetfilter_conntrack.h	(copie de travail)
@@ -191,6 +191,11 @@
 	/* Connection is dying (removed from lists), can not be unset. */
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
+
+    /* Connection has fixed timeout. */
+	IPS_FIXED_TIMEOUT_BIT = 10,
+	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
 };
 
 enum {

--------------000609040208030307030608--
