From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Sun, 04 Dec 2005 17:05:06 +0100
Message-ID: <439313B2.50601@trash.net>
References: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>	<20051124200736.GW31478@sunbeam.de.gnumonks.org>	<20051124202125.GX31478@sunbeam.de.gnumonks.org>	<43864DC7.6060109@trash.net>	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>	<20051125084427.GL31478@sunbeam.de.gnumonks.org>	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>	<438710E1.2000202@trash.net>
	<4387A946.3000005@eurodev.net>	<Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>	<20051129040925.GC3544@rama.towersoft.de>
	<438CDF45.9040308@trash.net> <4392630F.4040008@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030602010302090809090404"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <4392630F.4040008@eurodev.net>
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
--------------030602010302090809090404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>Harald Welte wrote:
>>
>>
>>>No, I oppose any kind of kernel version number checking.  I'd rather
>>>break 2.6.14 with new versions of the userspace.
>>>
>>
>>The stable tree has a couple of patches pending, so I guess there
>>will be another release. I'll ask them if they would take a patch
>>to fix this issue.
> 
> 
> Any update on this?

I've added this patch to my queue. It doesn't even affect compatiblity,
userspace can send both u_int8_t or u_int16_t, the binary representation
will look the same. Changing the library will however break
compatibility with old kernels, I'll try to push this patch to -stable
as well.


--------------030602010302090809090404
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix CTA_PROTO_NUM attribute size in ctnetlink

CTA_PROTO_NUM is a u_int8_t.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0fa82f8caa129bb2377e1b593bf2986fc13c5391
tree 0a7479acf48c9de99cb6f9fd1fac3a01dec2e220
parent 01563e56ad1c48c85e1258e2eaabcc270385e1a5
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:00:48 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:00:48 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 70402e0..d058ac4 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -503,7 +503,7 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 }
 
 static const size_t cta_min_proto[CTA_PROTO_MAX] = {
-	[CTA_PROTO_NUM-1]	= sizeof(u_int16_t),
+	[CTA_PROTO_NUM-1]	= sizeof(u_int8_t),
 	[CTA_PROTO_SRC_PORT-1]	= sizeof(u_int16_t),
 	[CTA_PROTO_DST_PORT-1]	= sizeof(u_int16_t),
 	[CTA_PROTO_ICMP_TYPE-1]	= sizeof(u_int8_t),
@@ -528,7 +528,7 @@ ctnetlink_parse_tuple_proto(struct nfatt
 
 	if (!tb[CTA_PROTO_NUM-1])
 		return -EINVAL;
-	tuple->dst.protonum = *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+	tuple->dst.protonum = *(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
 
 	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
 

--------------030602010302090809090404--
