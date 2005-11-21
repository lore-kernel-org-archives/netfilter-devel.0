From: Krzysztof Oledzki <olenf@ans.pl>
Subject: CTA_PROTO_NUM u_int8_t or u_int16_t
Date: Mon, 21 Nov 2005 15:40:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1334557230-1132584033=:30476"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

---187430788-1334557230-1132584033=:30476
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

AFAIK ip proto is u8 but I found that it is represented as u16 and used=20
both as u_int16_t and u_int8_t:

include/linux/netfilter_ipv4/ipt_conntrack.h:           u16 protonum;

net/ipv4/netfilter/ip_conntrack_netlink.c:      NFA_PUT(skb, CTA_PROTO_NUM,=
 sizeof(u_int8_t), &tuple->dst.protonum);
net/ipv4/netfilter/ip_conntrack_netlink.c:      [CTA_PROTO_NUM-1]       =3D=
 sizeof(u_int16_t),
net/ipv4/netfilter/ip_conntrack_netlink.c:      tuple->dst.protonum =3D *(u=
_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);

Was this intentionally?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1334557230-1132584033=:30476--
