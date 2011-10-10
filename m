From: Ajith Adapa <adapa.ajith@gmail.com>
Subject: Re: doubt with NAPT on icmp packet
Date: Mon, 10 Oct 2011 08:54:43 +0530
Message-ID: <CADAe=+J+C608p1-p29+i9j-DQ=cQP45_tb-v8L=Pd-SB=P7j-w@mail.gmail.com>
References: <CADAe=+LWJQxnuMT2LW4Bm7pJAsHP_PHNpde0Vpue4ULMMj17Wg@mail.gmail.com>
 <CADAe=+LpSVuLUohYUXAV+RJh_p8CUmXhQmLLZ+SM5KQayYWaEg@mail.gmail.com> <CADAe=+Jb-D-dJ++MuPLV5sfUHwj+4RCf2Sv7V2sVpPDPP20wJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1JJDZO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Oct 2011 23:25:14 -0400
Received: by bkbzt4 with SMTP id zt4so7918301bkb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Oct 2011 20:25:13 -0700 (PDT)
In-Reply-To: <CADAe=+Jb-D-dJ++MuPLV5sfUHwj+4RCf2Sv7V2sVpPDPP20wJw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In my case even log level wouldnt help me as the MASQUERADE rule is on
postrouting chain of nat which is the last chain. Once it hits the
rule with target as MASQUERADE is there a way to see the output of it
?

But why does it happen so with an ICMP packet ?

Regards,
Ajith


On Sun, Oct 9, 2011 at 2:17 PM, Ajith Adapa <adapa.ajith@gmail.com> wro=
te:
> Hi,
>
> It seems IP MASQUERADING is not working in the case of icmp packet
> same rules for a TCP and UDP packet are working without any issue..
>
> Is there any way to debug in this case ?
>
> Regards,
> Ajith
>
>
>
>
> On Sun, Oct 9, 2011 at 12:24 PM, Ajith Adapa <adapa.ajith@gmail.com> =
wrote:
>> Hi,
>>
>> I have a doubt regarding the NAPT mechanism part of netfilter in lin=
ux
>> kernel for a ICMP packet.=C2=A0I am using Redhat 5.7 64 bit OS.
>>
>> In case of ICMP packets basically it is the echoid and source addres=
s
>> are used as a tuple or a key. So based on the NAPT rules present in
>> iptables the echo id
>> module in icmp packet has to be modified.
>>
>> But its not happening so. Echoid in icmp packet remains same. My
>> iptable nat rules are shown below. Ideal case icmp echo id has to
>> modified to the range as shown below.
>> I am sorry if I am wrong .. anyway to debug such a scenarios ?
>>
>> iptables -t nat -L -nv
>> Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
>> =C2=A0pkts bytes target =C2=A0 =C2=A0 prot opt in =C2=A0 =C2=A0 out =
=C2=A0 =C2=A0 source
>> destination
>> =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 0 DNAT =C2=A0 =C2=A0 =C2=A0 all =C2=A0=
-- =C2=A0eth1 =C2=A0 * =C2=A0 =C2=A0 =C2=A0 0.0.0.0/0
>> 0.0.0.0/0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 to:192.168.1.1
>> Chain POSTROUTING (policy ACCEPT 104 packets, 6628 bytes)
>> =C2=A0pkts bytes target =C2=A0 =C2=A0 prot opt in =C2=A0 =C2=A0 out =
=C2=A0 =C2=A0 source
>> destination
>> =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 0 MASQUERADE =C2=A0icmp -- =C2=A0* =C2=
=A0 =C2=A0 =C2=A0eth1 =C2=A0 =C2=A0192.168.1.0/24
>> 0.0.0.0/0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 masq ports: 63232-63359
>>
>> Regards,
>> Ajith
>>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
