From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Tue, 27 May 2008 15:11:42 +0200
Message-ID: <483C088E.4020405@trash.net>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>	<483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020007020505020800070200"
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: "Gabor Z. Papp" <gzp@papp.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53376 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYE0NLq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 09:11:46 -0400
In-Reply-To: <x6y75w3q2j@gzp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020007020505020800070200
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Gabor Z. Papp wrote:
> * Patrick McHardy <kaber@trash.net>:
> 
> | Thanks for the report. Does this patch fix it?
> 
> Not really.
> 
>   CC       libxt_connlimit.oo
> In file included from /usr/include/linux/netfilter_ipv4.h:9,
>                  from ../include/linux/netfilter_ipv4/ip_tables.h:19,
>                  from ../include/libiptc/libiptc.h:7,
>                  from ../include/iptables.h:5,
>                  from libxt_connlimit.c:8:
> ../include/linux/netfilter.h:42: error: expected specifier-qualifier-list before '__be32'
> make[2]: *** [libxt_connlimit.oo] Error 1
> make[2]: Leaving directory `/home/gzp/src/iptables-1.4.1-rc2/extensions'
> make[1]: *** [all-recursive] Error 1

Your types.h doesn't seem to include the endian annotated
types at all. Does this patch work?


--------------020007020505020800070200
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 4196a51..b64a513 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -38,8 +38,8 @@ enum nf_inet_hooks {
 
 union nf_inet_addr {
 	__u32		all[4];
-	__be32		ip;
-	__be32		ip6[4];
+	__u32		ip;
+	__u32		ip6[4];
 	struct in_addr	in;
 	struct in6_addr	in6;
 };

--------------020007020505020800070200--
