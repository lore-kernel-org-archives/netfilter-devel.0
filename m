From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN
 retransmissions after SYN+ACK
Date: Sat, 26 Feb 2011 14:15:52 +0800
Message-ID: <AANLkTiminy835GRXXsJov38TYT6feEqMcbWd3c3tz45c@mail.gmail.com>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	kadlec@blackhole.kfki.hu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58157 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1BZGQN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 01:16:13 -0500
Received: by fxm17 with SMTP id 17so2412575fxm.19
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Feb 2011 22:16:12 -0800 (PST)
In-Reply-To: <20110226033324.4335.53000.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 26, 2011 at 11:33 AM, Pablo Neira Ayuso <pablo@netfilter.or=
g> wrote:
> =A0net/netfilter/nf_conntrack_proto_tcp.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/n=
f_conntrack_proto_tcp.c
> index 3fb2b73..be0b84d 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -142,12 +142,12 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTR=
ACK_MAX] =3D {
> =A0 =A0 =A0 =A0{
> =A0/* ORIGINAL */
> =A0/* =A0 =A0 =A0 =A0 =A0sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL,=
 sS2 =A0 */
> -/*syn*/ =A0 =A0 =A0 =A0 =A0 { sSS, sSS, sIG, sIG, sIG, sIG, sIG, sSS=
, sSS, sS2 },
> +/*syn*/ =A0 =A0 =A0 =A0 =A0 { sSS, sSS, sSR, sIG, sIG, sIG, sIG, sSS=
, sSS, sS2 },
> =A0/*
> =A0* =A0 =A0 sNO -> sSS =A0 =A0 =A0Initialize a new connection
> =A0* =A0 =A0 sSS -> sSS =A0 =A0 =A0Retransmitted SYN
> =A0* =A0 =A0 sS2 -> sS2 =A0 =A0 =A0Late retransmitted SYN
> - * =A0 =A0 sSR -> sIG
> + * =A0 =A0 sSR -> sSR =A0 =A0 =A0Retransmitted SYN, SYN/ACK got lost=
?
> =A0* =A0 =A0 sES -> sIG =A0 =A0 =A0Error: SYNs in window outside the =
SYN_SENT state
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 are errors. Receiver wil=
l reply with RST
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 and close the connection=
=2E
>

I think you should change [reply][eSR][syn_ack] to ignore. Then the
following code will be executed, and in fact, the following code is
for you scenario according to the comments.

 878         case TCP_CONNTRACK_IGNORE:
 879                 /* Ignored packets:
 880                  *
 881                  * Our connection entry may be out of sync, so ign=
ore
 882                  * packets which may signal the real connection be=
tween
 883                  * the client and the server.
 884                  *
 885                  * a) SYN in ORIGINAL
 886                  * b) SYN/ACK in REPLY
 887                  * c) ACK in reply direction after initial SYN in =
original.
 888                  *
 889                  * If the ignored packet is invalid, the receiver =
will send
 890                  * a RST we'll catch below.
 891                  */
 892                 if (index =3D=3D TCP_SYNACK_SET
 893                     && ct->proto.tcp.last_index =3D=3D TCP_SYN_SET
 894                     && ct->proto.tcp.last_dir !=3D dir
 895                     && ntohl(th->ack_seq) =3D=3D ct->proto.tcp.las=
t_end) {
 896                         /* b) This SYN/ACK acknowledges a SYN
that we earlier
 897                          * ignored as invalid. This means that
the client and
 898                          * the server are both in sync, while the
firewall is
 899                          * not. We get in sync from the
previously annotated
 900                          * values.
 901                          */
 902                         old_state =3D TCP_CONNTRACK_SYN_SENT;
 903                         new_state =3D TCP_CONNTRACK_SYN_RECV;
 904                         ct->proto.tcp.seen[ct->proto.tcp.last_dir]=
=2Etd_end =3D
 905                                 ct->proto.tcp.last_end;
 906
ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxend =3D
 907                                 ct->proto.tcp.last_end;
 908
ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxwin =3D
 909                                 ct->proto.tcp.last_win =3D=3D 0 ?
 910                                         1 : ct->proto.tcp.last_win=
;
 911
ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_scale =3D
 912                                 ct->proto.tcp.last_wscale;
 913                         ct->proto.tcp.seen[ct->proto.tcp.last_dir]=
=2Eflags =3D
 914                                 ct->proto.tcp.last_flags;
 915                         memset(&ct->proto.tcp.seen[dir], 0,
 916                                sizeof(struct ip_ct_tcp_state));
 917                         break;
 918                 }


--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
