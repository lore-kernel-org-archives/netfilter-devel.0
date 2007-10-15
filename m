From: Al Boldi <a1426z@gawab.com>
Subject: Re: [netfilter-core] Mangle table rules are not taken into account
Date: Tue, 16 Oct 2007 00:32:48 +0300
Message-ID: <200710160032.09405.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [212.12.190.81] ([212.12.190.81]:43682 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755505AbXJOVdH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:33:07 -0400
Received: from localhost ([10.0.0.111])
	by raad.intranet (8.8.7/8.8.7) with ESMTP id AAA21273
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Oct 2007 00:31:49 +0300
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pascal Hambourg wrote:
> Konstantin Ushakov a =E9crit :
> >>What about the REJECT target ?
> >
> > Correct me if I'm mistaken, but REJECT target is only valid in filt=
er
> > table.
>
> Correct.
>
> > But the packet does not reach filter table because of reasons
> > described by Patric (as we DROP it after mangle).
>
> Im meant to use the REJECT target /instead of/ an "unreachable" routi=
ng
> rule.
>
> Remove
> ip rule add from all fwmark 0xb lookup 99 unreachable prio 40000
>
> And add
> iptables -t filter -A OUTPUT -m mark --mark 0xb \
>    -j REJECT --rejected-with icmp-net-unreachable

Or make it really simple, and use REJECT in mangle with something like =
this:

--- ipt_REJECT.bak.c    2007-10-12 08:25:17.000000000 +0300
+++ ipt_REJECT.c        2007-10-12 08:31:44.000000000 +0300
@@ -165,6 +165,7 @@ static void send_reset(struct sk_buff *o
=20
 static inline void send_unreach(struct sk_buff *skb_in, int code)
 {
+       if (!skb_in->dst) ip_route_me_harder(&skb_in, RTN_UNSPEC);
        icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 }
=20
@@ -245,9 +246,6 @@ static struct xt_target ipt_reject_reg =3D
        .family         =3D AF_INET,
        .target         =3D reject,
        .targetsize     =3D sizeof(struct ipt_reject_info),
-       .table          =3D "filter",
-       .hooks          =3D (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD=
) |
-                         (1 << NF_IP_LOCAL_OUT),
        .checkentry     =3D check,
        .me             =3D THIS_MODULE,
 };


Thanks!

--
Al

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
