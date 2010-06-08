From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: Redundant calls to nf_ct_tuplehash_to_ctrack
Date: Tue, 8 Jun 2010 21:26:45 +0530
Message-ID: <AANLkTinRGGEyg0b2RzYgM3CIHrtnIn-Lim3F-awFRRaH@mail.gmail.com>
References: <AANLkTikuYXpQrc3MECpkj_h8E19D5ZM07Li_CpqRYc7k@mail.gmail.com>
	<1276010168.2486.227.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48928 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0FHP4t convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:56:49 -0400
Received: by pwj5 with SMTP id 5so1389344pwj.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Jun 2010 08:56:48 -0700 (PDT)
In-Reply-To: <1276010168.2486.227.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 8, 2010 at 8:46 PM, Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
> Le mardi 08 juin 2010 =E0 19:48 +0530, Anand Raj Manickam a =E9crit :
>> This my observation ..
>>
>> There is a redundant call to nf_ct_tuplehash_to_ctrack() after every
>> nf_conntrack_find_get() call .
>>
>> Why is ct not returned from nf_conntrack_find_get() , since in all t=
he
>> occurances of nf_conntrack_find_get() there is immediate call to
>> nf_ct_tuplehash_to_ctrack() . Although =A0nf_ct_tuplehash_to_ctrack(=
) is
>> invoked to check the ct after we get a valid hash .
>>
>
> One random sample :
>
> net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>
> =A0 =A0 =A0 =A0h =3D nf_conntrack_find_get(net, zone, &innertuple);
> =A0 =A0 =A0 =A0if (!h) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pr_debug("icmp_error_message: no match=
\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -NF_ACCEPT;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (NF_CT_DIRECTION(h) =3D=3D IP_CT_DIR_REPLY)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*ctinfo +=3D IP_CT_IS_REPLY;
>
>
> As you can see, we need 'h' here (to get NF_CT_DIRECTION(h)), not 'ct=
'

I did think about it,
Can we derive the direction from conntrack  mabbe we replace
NF_CT_DIRECTION with the following  .

/* If we're the first tuple, it's the original dir. */
 #define NF_CT_DIRECTION(h)      ((enum ip_conntrack_dir)(h)->tuple.dst=
=2Edir)

if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.dir =3D=3D IP_CT_DIR_RE=
PLY)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
