From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] remove unneeded ip6tables-save source/destination
 address output
Date: Sat, 02 Dec 2006 17:37:48 +0100
Message-ID: <4571ABDC.3000409@trash.net>
References: <4570CDC4.2090205@iastate.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070807010107090900000000"
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel De Graaf <danield@iastate.edu>
In-Reply-To: <4570CDC4.2090205@iastate.edu>
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
--------------070807010107090900000000
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Daniel De Graaf wrote:
> ip6tables-save outputs the source and destination IPs when it is not
> needed. This
> is caused by an incorrectly copied check from iptables-save. Example
> output:
> -A INPUT -s ::/0 -d ::/0 -i lo -j ACCEPT instead of just -A INPUT -i
> lo -j ACCEPT
> 
> This patch will not output the address if the mask length is zero.
> 
> - Daniel De Graaf
> 
> Index: ip6tables-save.c
> ===================================================================
> --- ip6tables-save.c    (revision 6699)
> +++ ip6tables-save.c    (working copy)
> @@ -125,7 +125,7 @@
>         char buf[51];
>         int l = ipv6_prefix_length(mask);
>  
> -       if (!mask && !ip)
> +       if (l == 0)

They both seem wrong since they ignore inversion (-s !0/0). I've
committed this patch instead.

--------------070807010107090900000000
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: iptables-save.c
===================================================================
--- iptables-save.c	(Revision 6698)
+++ iptables-save.c	(Arbeitskopie)
@@ -141,7 +141,7 @@
 /* print a given ip including mask if neccessary */
 static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
 {
-	if (!mask && !ip)
+	if (!mask && !ip && !invert)
 		return;
 
 	printf("%s %s%u.%u.%u.%u",
Index: ip6tables-save.c
===================================================================
--- ip6tables-save.c	(Revision 6698)
+++ ip6tables-save.c	(Arbeitskopie)
@@ -125,7 +125,7 @@
 	char buf[51];
 	int l = ipv6_prefix_length(mask);
 
-	if (!mask && !ip)
+	if (l == 0 && !invert)
 		return;
 
 	printf("%s %s%s",

--------------070807010107090900000000--
