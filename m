From: Tom Eastep <teastep@shorewall.net>
Subject: Re: [PATCH 0/4] Updated IPSEC NAT patches for 2.6.11
Date: Thu, 03 Mar 2005 13:10:28 -0800
Message-ID: <42277D44.4080207@shorewall.net>
References: <1108667319.21912.14.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060308050903030909060403"
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1108667319.21912.14.camel@leto.cs.pocnet.net>
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
--------------060308050903030909060403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Christophe Saout wrote:
> Hi,
> 
> I've forward-ported Patrick McHardy's patches that make the kernel IPSEC
> work with NAT.
> 
> Since there probably won't be any more big changes between 2.6.11-rc4
> and the final 2.6.11 I'm posting them now.
> 
> The biggest change is in the last patch (ipsec-04-policy-checks.diff). I
> needed to rewrite nf_nat_decode_session4 due to the big NAT changes. I
> hope I got everything right. I couldn't find a situation where it
> failed.
> I also added a missing return in nat_route_key_compare that made the
> kernel fail with certain compiler flags.
> 

Here's another little patch that allows iptables to compile cleanly
against a kernel tree that has the IPSEC NAT patches applied.

-Tom
-- 
Tom Eastep    \ Off-list replies are cheerfully ignored
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--------------060308050903030909060403
Content-Type: text/x-patch;
 name="ipsec-05-iptablescompile.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipsec-05-iptablescompile.diff"

diff -Naur linux-2.6.11.orig/include/linux/netfilter_ipv4.h linux-2.6.11/include/linux/netfilter_ipv4.h
--- linux-2.6.11.orig/include/linux/netfilter_ipv4.h	2005-03-03 10:55:24.895484995 -0800
+++ linux-2.6.11/include/linux/netfilter_ipv4.h	2005-03-03 10:55:13.496133352 -0800
@@ -7,8 +7,10 @@
 
 #include <linux/config.h>
 #include <linux/netfilter.h>
+#ifdef __KERNEL__
 #include <linux/netdevice.h>
 #include <net/protocol.h>
+#endif
 
 /* IP Cache bits. */
 /* Src IP address. */
diff -Naur linux-2.6.11.orig/include/net/ip.h linux-2.6.11/include/net/ip.h
--- linux-2.6.11.orig/include/net/ip.h	2005-03-03 10:54:34.418212127 -0800
+++ linux-2.6.11/include/net/ip.h	2005-03-03 10:54:25.250342049 -0800
@@ -30,8 +30,10 @@
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/in_route.h>
+#ifdef __KERNEL__
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
+#endif
 #include <net/route.h>
 #include <net/arp.h>
 #include <net/snmp.h>

--------------060308050903030909060403--
