From: Pete Holland <pholland27@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet due
 to helper rejection conditional on LOG_INVALID
Date: Wed, 30 Nov 2011 10:33:00 -0800
Message-ID: <CANtneHKob5AL=APFnLz0G3JwD97igVOr9eGpQ-mLd8p6XX5MdA@mail.gmail.com>
References: <CANtneH+UUgXdk1UmHKR8JfN=jqsFZ+LFYGQZ_tHF_aZ_zCn3Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40096 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1K3SdB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:33:01 -0500
Received: by bkas6 with SMTP id s6so1224888bka.19
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2011 10:33:00 -0800 (PST)
In-Reply-To: <CANtneH+UUgXdk1UmHKR8JfN=jqsFZ+LFYGQZ_tHF_aZ_zCn3Dw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

it occurred to me that I should be able to extract the protocol number
from the the tuplehash in struct nf_conn.  the original
direction tuple should always be there, and I could get it from there.

so instead of using IPPROTO_RAW, I could use
ct->tuplehash[IP_CT_ORIGINAL].src.l3num

i'm still pretty new in the netfilter code, so any thoughts are
greatly appreciated

On Tue, Nov 29, 2011 at 12:08 PM, Pete Holland <pholland27@gmail.com> w=
rote:
> From: Peter Holland <pholland27@gmail.com>
>
> Make the logging of dropped packets due to ct helper rejection
> conditional on LOG_INVALID.
> This is consistent with the other uses of nf_log_packet.
> Use the IPPROTO_RAW filter since it is unclear based on the caller
> what protocol it actually is.
> Without this check, there is a possible DoS based on traffic induced
> log generation.
> (specifically this was noted in the wild by an attacker against the S=
IP helper)
>
> Signed-off-by: Peter Holland <pholland27@gmail.com>
>
> ---
>
> --- net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.orig 2011-11-29
> 11:34:36.683717278 -0800
> +++ net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c =A0 =A0 =A02011-11=
-29
> 11:41:55.031121908 -0800
> @@ -116,8 +116,9 @@ static unsigned int ipv4_confirm(unsigne
> =A0 =A0 =A0 =A0ret =3D helper->help(skb, skb_network_offset(skb) + ip=
_hdrlen(skb),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ct, ctinfo);
> =A0 =A0 =A0 =A0if (ret !=3D NF_ACCEPT) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_log_packet(NFPROTO_IPV4, hooknum, sk=
b, in, out, NULL,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "nf_ct_%s: =
dropping packet", helper->name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (LOG_INVALID(nf_ct_net(ct, IPPROTO_R=
AW))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_log_packet(NFPROTO_I=
PV4, hooknum, skb, in, out, NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 "nf_ct_%s: dropping packet", helper->name);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> =A0 =A0 =A0 =A0}
>
> --- net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c.orig 2011-11-29
> 11:35:00.221028814 -0800
> +++ net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c =A0 =A0 =A02011-11=
-29
> 11:38:49.541033773 -0800
> @@ -180,8 +180,9 @@ static unsigned int ipv6_confirm(unsigne
>
> =A0 =A0 =A0 =A0ret =3D helper->help(skb, protoff, ct, ctinfo);
> =A0 =A0 =A0 =A0if (ret !=3D NF_ACCEPT) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_log_packet(NFPROTO_IPV6, hooknum, sk=
b, in, out, NULL,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "nf_ct_%s: =
dropping packet", helper->name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (LOG_INVALID(nf_ct_net(ct), IPPROTO_=
RAW))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_log_packet(NFPROTO_I=
PV6, hooknum, skb, in, out, NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 "nf_ct_%s: dropping packet", helper->name);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> =A0 =A0 =A0 =A0}
> =A0out:
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
