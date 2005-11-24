From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Fri, 25 Nov 2005 00:54:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
References: <4381FDF8.6030508@trash.net> <43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net> <43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1133068489-1132876496=:14092"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43864DC7.6060109@trash.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1133068489-1132876496=:14092
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 25 Nov 2005, Patrick McHardy wrote:
<CUT>
> I think just the first patch is fine. I really hope we don't find
> more of these.

It is not. It breaks old binaries:

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -57,7 +57,7 @@ ctnetlink_dump_tuples_proto(struct sk_bu
         struct ip_conntrack_protocol *proto;
         int ret =3D 0;

-       NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum)=
;
+       NFA_PUT(skb, CTA_PROTO, sizeof(u_int8_t), &tuple->dst.protonum);

         /* If no protocol helper is found, this function will return the
          * generic protocol helper, so proto won't *ever* be NULL */

Old binaries are not able to deal with CTA_PROTO and will not be able to=20
parse this attribute received from kernel. We should keep CTA_PROTO_NUM=20
here, but this leads to u_int8_t/u_int16_t mismatch in the code.

Anyway, new userspace applications will only need to send both=20
CTA_PROTO_NUM and CTA_PROTO to work with both new and old kernel. No=20
kernel version checking. Great.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1133068489-1132876496=:14092--
