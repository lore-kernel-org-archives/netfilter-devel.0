From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Compiling 1.3.6
Date: Mon, 09 Oct 2006 00:21:43 +0200
Message-ID: <452979F7.9090205@netfilter.org>
References: <00be01c6e977$1ba6bcd0$0101a8c0@pcjorge>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020206080608030409010800"
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <00be01c6e977$1ba6bcd0$0101a8c0@pcjorge>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020206080608030409010800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Patrick,

Jorge Bastos wrote:
> I was compiling the 1.3.6 version of iptables, agains my 2.6.19-rc1
> kernel version and i get this (it also happens with the final 2.6.18).
> Is there some livrary that needs an upgrade or am i missing something?
> I already tryed the svn last version and the same happens.

min_ip and max_ip type has been changed from u_int32_t to __be32 that is
not defined in userspace, this breaks iptables compilation. Attached a
patch that recovers the use of u_int32_t. I'm not sure if this is the
best fix so let me know what you think.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020206080608030409010800
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[PATCH] Fix iptables compilation with support for iprange

iptables requires ipt_iprange.h that defines max_ip and min_ip as __be32
that is not defined in userspace.

Reported by Jorge Bastos.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/include/linux/netfilter_ipv4/ipt_iprange.h
===================================================================
--- net-2.6.orig/include/linux/netfilter_ipv4/ipt_iprange.h	2006-10-09 00:15:42.000000000 +0200
+++ net-2.6/include/linux/netfilter_ipv4/ipt_iprange.h	2006-10-09 00:15:55.000000000 +0200
@@ -8,7 +8,7 @@
 
 struct ipt_iprange {
 	/* Inclusive: network order. */
-	__be32 min_ip, max_ip;
+	u_int32_t min_ip, max_ip;
 };
 
 struct ipt_iprange_info

--------------020206080608030409010800--
