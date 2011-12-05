From: Pete Holland <pholland27@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet due
 to helper rejection conditional on LOG_INVALID (resubmit)
Date: Mon, 5 Dec 2011 10:09:51 -0800
Message-ID: <CANtneHJbS_3QhAEJ3b7ifN1ywDy7Lj+ycve5X2ydqgY2FC5erg@mail.gmail.com>
References: <CANtneHLYOANXQ432me_htXrMcQkv-WVpNYTrwmxAjc2gV68iPA@mail.gmail.com>
	<20111204224946.GC28125@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47149 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab1LESJx convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:09:53 -0500
Received: by eaak14 with SMTP id k14so4315398eaa.19
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Dec 2011 10:09:51 -0800 (PST)
In-Reply-To: <20111204224946.GC28125@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

would you like that I check *net for NULL as is done for *ct, *help,
and *helper?

On Sun, Dec 4, 2011 at 2:49 PM, Pablo Neira Ayuso <pablo@netfilter.org>=
 wrote:
> Hi Peter,
>
> On Fri, Dec 02, 2011 at 09:37:04AM -0800, Pete Holland wrote:
>> From: Peter Holland <pholland27@gmail.com>
>>
>> Make the logging of dropped packets due to ct helper rejection
>> conditional on LOG_INVALID.
>> This is consistent with the other uses of nf_log_packet.
>> Use protocol from conntrack tuple (original direction).
>> Without this check, there is a possible DoS based on traffic induced
>> log generation.
>> (specifically this was noted in the wild by an attacker against the =
SIP helper)
>>
>> Signed-off-by: Peter Holland <pholland27@gmail.com>
>> ---
>> --- net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.orig =A0 =A0 =A0 =
2011-11-29
>> 11:34:36.683717278 -0800
>> +++ net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c =A0 =A02011-12-02
>> 09:32:00.727064563 -0800
>> @@ -116,8 +116,10 @@ static unsigned int ipv4_confirm(unsigne
>> =A0 =A0 =A0 ret =3D helper->help(skb, skb_network_offset(skb) + ip_h=
drlen(skb),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ct, ctinfo);
>> =A0 =A0 =A0 if (ret !=3D NF_ACCEPT) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 nf_log_packet(NFPROTO_IPV4, hooknum, skb, =
in, out, NULL,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "nf_ct_%s: dro=
pping packet", helper->name);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (LOG_INVALID(nf_ct_net(ct),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ct->tupleh=
ash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum))
>
> You can use nf_ct_protonum here.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_log_packet(NFPROTO_IPV4=
, hooknum, skb, in, out, NULL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 "nf_ct_%s: dropping packet", helper->name);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> =A0 =A0 =A0 }
>
> Below you can find:
>
> /* adjust seqs for loopback traffic only in outgoing direction */
> if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
> =A0 =A0!nf_is_loopback_packet(skb)) {
> =A0 =A0 =A0 =A0typeof(nf_nat_seq_adjust_hook) seq_adjust;
>
> =A0 =A0 =A0 =A0seq_adjust =3D rcu_dereference(nf_nat_seq_adjust_hook)=
;
> =A0 =A0 =A0 =A0if (!seq_adjust || !seq_adjust(skb, ct, ctinfo)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), d=
rop);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0^^^^^^^^^^^^
>
> Please, declare in ipv4_confirm:
>
> struct net *net =3D nf_ct_net(ct);
>
> And use the net pointer in that function.
>
> Same thing for the IPv6 side.
>
> Thank you.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
