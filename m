From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: don't always initialize ct->proto
Date: Sun, 24 Oct 2010 16:40:31 +0800
Message-ID: <AANLkTimpfnc1K9rf6v2Z6WQ+PE3SyXFg-yyDCHwojGmQ@mail.gmail.com>
References: <1287888016-25213-1-git-send-email-xiaosuo@gmail.com> <alpine.LNX.2.01.1010241019360.5890@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60242 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab0JXIkx convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 04:40:53 -0400
Received: by wyf28 with SMTP id 28so2322361wyf.19
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Oct 2010 01:40:52 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1010241019360.5890@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 24, 2010 at 4:27 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>
> On Sunday 2010-10-24 04:40, Changli Gao wrote:
>
>>ct->proto is big(60 bytes) due to structure ip_ct_tcp, and we don't n=
eed
>>to initialize the whole for all the other protocols. This patch moves
>>proto to the end of structure nf_conn, and pushes the initialization =
down
>>to the individual protocols.
>>
>>diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/=
nf_conntrack_proto_dccp.c
>>index 5292560..9ae57c5 100644
>>--- a/net/netfilter/nf_conntrack_proto_dccp.c
>>+++ b/net/netfilter/nf_conntrack_proto_dccp.c
>>@@ -452,6 +452,9 @@ static bool dccp_new(struct nf_conn *ct, const st=
ruct sk_buff *skb,
>> =A0 =A0 =A0 ct->proto.dccp.role[IP_CT_DIR_ORIGINAL] =3D CT_DCCP_ROLE=
_CLIENT;
>> =A0 =A0 =A0 ct->proto.dccp.role[IP_CT_DIR_REPLY] =3D CT_DCCP_ROLE_SE=
RVER;
>> =A0 =A0 =A0 ct->proto.dccp.state =3D CT_DCCP_NONE;
>>+ =A0 =A0 =A0ct->proto.dccp.last_pkt =3D DCCP_PKT_REQUEST;
>>+ =A0 =A0 =A0ct->proto.dccp.last_dir =3D IP_CT_DIR_ORIGINAL;
>>+ =A0 =A0 =A0ct->proto.dccp.handshake_seq =3D 0;
>> =A0 =A0 =A0 return true;
>>
>> out_invalid:
>
> This hunk seems unrelated to the actual move of the union member -

There are only three fields left uninitialized, so I use assignments
instead of memset().

>
>>diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/n=
f_conntrack_proto_tcp.c
>>index c4c885d..69da4b0 100644
>>--- a/net/netfilter/nf_conntrack_proto_tcp.c
>>+++ b/net/netfilter/nf_conntrack_proto_tcp.c
>>@@ -1066,9 +1066,7 @@ static bool tcp_new(struct nf_conn *ct, const s=
truct sk_buff *skb,
>> =A0 =A0 =A0 BUG_ON(th =3D=3D NULL);
>>
>> =A0 =A0 =A0 /* Don't need lock here: this conntrack not in circulati=
on yet */
>>- =A0 =A0 =A0new_state
>>- =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D tcp_conntracks[0][get_conntrack_inde=
x(th)]
>>- =A0 =A0 =A0 =A0 =A0 =A0 =A0[TCP_CONNTRACK_NONE];
>>+ =A0 =A0 =A0new_state =3D tcp_conntracks[0][get_conntrack_index(th)]=
[TCP_CONNTRACK_NONE];
>>
>> =A0 =A0 =A0 /* Invalid: delete conntrack */
>> =A0 =A0 =A0 if (new_state >=3D TCP_CONNTRACK_MAX) {
>
> as does this change. Can you elaborate on why they are now needed,
> or did you happen to erroneously squash multiple patches?
>

It is trivial code cleanup, and isn't worth an individual patch IMO. Th=
anks.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
