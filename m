From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: Use const in struct xt_match, xt_target, xt_table
Date: Sat, 12 Jan 2008 14:40:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801121427320.425@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801081325380.3032@fbirervta.pbzchgretzou.qr>
 <4783A4C4.4030809@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46938 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYALNka (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jan 2008 08:40:30 -0500
In-Reply-To: <4783A4C4.4030809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 8 2008 17:28, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> origin git://computergmbh.de/linux netfilter
>> commit 911b3c3680fd17409c64a6589cfcaf18e4fa04ce
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Tue Jan 8 13:25:08 2008 +0100
>> 
>>     [NETFILTER]: Use const in struct xt_match, xt_target, xt_table
>
> This causes compiler warnings:
>
> net/ipv6/netfilter/ip6_tables.c: In function 'ip6t_do_table':
> net/ipv6/netfilter/ip6_tables.c:407: warning: passing argument 5 of
> 'trace_packet' discards qualifiers from pointer target type
> net/ipv6/netfilter/ip6_tables.c:406: warning: passing argument 5 of
> 'trace_packet' discards qualifiers from pointer target type
>

Please fold in this one:

commit 7084c6df091ebb6301e7e2782269784b416c98a6
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Jan 12 14:39:54 2008 +0100

    [NETFILTER]: Use const
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f5b66ec..d688147 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -286,7 +286,7 @@ static void trace_packet(struct sk_buff *skb,
 			 unsigned int hook,
 			 const struct net_device *in,
 			 const struct net_device *out,
-			 char *tablename,
+			 const char *tablename,
 			 struct xt_table_info *private,
 			 struct ipt_entry *e)
 {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 4ed16d2..e4b5418 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -316,7 +316,7 @@ static void trace_packet(struct sk_buff *skb,
 			 unsigned int hook,
 			 const struct net_device *in,
 			 const struct net_device *out,
-			 char *tablename,
+			 const char *tablename,
 			 struct xt_table_info *private,
 			 struct ip6t_entry *e)
 {
