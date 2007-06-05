From: Amin Azez <azez@ufomechanic.net>
Subject: RE: [PATCH] xt_gateway match
Date: Tue, 5 Jun 2007 15:04:17 +0100
Message-ID: <200706051524.l55FO3v22906@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

That looks about right.

Thanks

Sam

-----Original Message-----
From: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
To: "Amin Azez" <azez@ufomechanic.net>
Cc: netfilter-devel@lists.netfilter.org
Sent: 05/06/07 11:16
Subject: RE: [PATCH] xt_gateway match

On Jun 4 2007 11:14, Amin Azez wrote:
>
>Thanks for looking at this, Jan. I'm away from a testing box right now,=20
>but I think you got a test wrong. The gateway test is meant to exclude=20
>cases where the neighbour table matches AND the daddr matches, because=20
>that means the packet wasn't routed to that target AS a gateway.
>
>For nexthop we don't want to match daddr regardless, only if it is also=20
>matching the neighbor table.
>
>Gateway: match neighbourtable and not match daddr
>Nexthop: match neighbour table.

Ok I am a bit narrow on this, anyway, I checked again and it looks like,=20
yes, there was something wrong. I fixed it to:

	if (memcmp(&info->gateway, &neigh->primary_key, tbl->key_len) !=3D 0)
		return false;
	if (!(info->flags & XT_GATEWAY_ROUTE))
		return true;
	iph =3D ip_hdr(skb);
	if (iph->daddr !=3D info->gateway)
		return true;
	return false;

which should be matching

memcmp(&info->gateway, &skb->dst->neighbour->primary_key,
	skb->dst->neighbour->tbl->key_len) =3D=3D 0 &&
((info->flags & IPT_GATEWAY_ROUTE) =3D=3D 0 || iph->daddr !=3D info->gatewa=
y)

Will resend with that.


	Jan
--=20
