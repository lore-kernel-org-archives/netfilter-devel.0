From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Tue, 22 Nov 2005 20:04:15 +0100
Message-ID: <43836BAF.2050501@eurodev.net>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>	<4381DF77.2030704@eurodev.net>
	<4381FDF8.6030508@trash.net> <43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010709060704000900030702"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4382A19D.9090201@trash.net>
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
--------------010709060704000900030702
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>> Patrick McHardy wrote:
>>
>>> If you have to break compatibility, please do it before 2.6.15 is
>>> released. But the easiest solution looks like keeping it a u_int16_t
>>> and adjusting the NFA_PUT.
>>
>> I think that I can fix it in nf_conntrack_netlink. ip_conntrack_netlink
>> will go sooner or later.
> 
> I'm not sure that will be an avantage to breaking it immediately.
> People should be able to use ctnetlink application with nfctnetlink,
> so it will still break, but at that point the interface will already
> be more established. We could just leave it a u_int16_t, but it won't
> be in network byte order as the other attributes, which IMO needs to
> be fixed if we ever want to use ctnetlink over the network without
> adding lots of code in userspace just to fix up this single field.

Better to fix it, break backward compatibility now and forget about this
issue. Patch attached. Thanks for the feedback Patrick.

-- 
Pablo

--------------010709060704000900030702
Content-Type: text/plain;
 name="u8proto_num.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="u8proto_num.patch"

CTA_PROTO_NUM is u_int8_t, not u_int16_t

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-22 02:46:00.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-22 19:57:16.000000000 +0100
@@ -502,7 +502,7 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 }
 
 static const size_t cta_min_proto[CTA_PROTO_MAX] = {
-	[CTA_PROTO_NUM-1]	= sizeof(u_int16_t),
+	[CTA_PROTO_NUM-1]	= sizeof(u_int8_t),
 	[CTA_PROTO_SRC_PORT-1]	= sizeof(u_int16_t),
 	[CTA_PROTO_DST_PORT-1]	= sizeof(u_int16_t),
 	[CTA_PROTO_ICMP_TYPE-1]	= sizeof(u_int8_t),
@@ -527,7 +527,7 @@ ctnetlink_parse_tuple_proto(struct nfatt
 
 	if (!tb[CTA_PROTO_NUM-1])
 		return -EINVAL;
-	tuple->dst.protonum = *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+	tuple->dst.protonum = *(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
 
 	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
 

--------------010709060704000900030702--
