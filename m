From: Stig <stig@ubnt.com>
Subject: Re: ULOG and vlans
Date: Thu, 28 Jul 2011 10:00:15 -0700
Message-ID: <CAL-yc88wjr-0H1LF+x5FLf=h1XhswbQ78McHvZ4NL5+p08gUTw@mail.gmail.com>
References: <CAL-yc8_nbzJu8FxAVBycdeXtciz=FGYxXzQtT88xYQ3wX60hBQ@mail.gmail.com>
	<4E3144DA.7060009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33387 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755737Ab1G1RHL convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:07:11 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so3027107ewy.33
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2011 10:07:02 -0700 (PDT)
In-Reply-To: <4E3144DA.7060009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 28, 2011 at 4:15 AM, Patrick McHardy <kaber@trash.net> wrot=
e:
> On 27.07.2011 20:59, Stig wrote:
>> I'm using ULOG iptables target to capture packets for pmacct (a
>> netflow exporter). =A0I noticed when ulog gets a packet from a vlan
>> interface that the ulog header shows a mac_len of 18 bytes, but it
>> appears that the vlan tag has already been stripped from the packet
>> header:
>>
>> (gdb) p/x *ulog_pkt
>> $7 =3D {
>> =A0 mark =3D 0x0,
>> =A0 timestamp_sec =3D 0x4e2f6077,
>> =A0 timestamp_usec =3D 0x222f3,
>> =A0 hook =3D 0x0,
>> =A0 indev_name =3D {0x65, 0x74, 0x68, 0x31, 0x2e, 0x31, 0x30, 0x30, =
0x0, 0x0, 0x0,
>> =A0 =A0 0x0, 0x0, 0x0, 0x0, 0x0},
>> =A0 outdev_name =3D {0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, =
0x5, 0xf, 0x0,
>> =A0 =A0 0x0, 0x5, 0xf, 0x0, 0x0},
>> =A0 data_len =3D 0x40,
>> =A0 prefix =3D {0x0, 0x0, 0x2, 0x0, 0x72, 0x60, 0x2f, 0x4e, 0xed, 0x=
6, 0x0, 0x0,
>> =A0 =A0 0xa, 0x40, 0x80, 0xfd, 0x2, 0x0, 0x0, 0x0, 0x14, 0x0, 0x1, 0=
x0, 0xfe,
>> =A0 =A0 0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
>> =A0 mac_len =3D 0x12,
>> =A0 mac =3D {0x0, 0xd, 0xb9, 0x15, 0x6d, 0x1, 0x0, 0xf, 0x30, 0x4, 0=
x35, 0x4f,
>> =A0 =A0 0x8, 0x0, 0x45, 0x0, 0x0, 0x54, 0xff, 0x21, 0x12, 0x0, 0x0, =
0x21, 0x12,
>> =A0 =A0 0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x14, 0x0, 0x2, 0x0, 0x72, 0x=
60, 0x2f,
>> =A0 =A0 0x4e, 0xed, 0x6, 0x0, 0x0, 0xa, 0x40, 0x80, 0xfd, 0x3, 0x0, =
0x0, 0x0,
>> =A0 =A0 0x14, 0x0, 0x1, 0x0, 0xfe, 0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x=
0, 0x2, 0xd,
>> =A0 =A0 0xb9, 0xff, 0xfe, 0x15, 0x6d, 0x1, 0x14, 0x0, 0x6, 0x0, 0xff=
, 0xff, 0xff,
>> =A0 =A0 0xff, 0xff},
>> =A0 payload =3D 0x941cc35
>> }
>>
>>
>> If the vlan has been remove, shouldn't the mac_len be reduced to 14?
>
> Yes. How is your vlan device configured (ip -s link show vlanX)?

vyatta@vyatta:~$ ip -s link show eth1.100
4: eth1.100@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqu=
eue stat
    link/ether 00:0d:b9:15:6d:01 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    296652     3372     0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    344216     3376     0       0       0       0

vyatta@vyatta:~$ iptables -V
iptables v1.4.10

vyatta@vyatta:~$ uname -a
Linux alix-vyatta 2.6.37-1-586-vyatta #1 SMP Mon Jun 13 14:41:41 PDT 20=
11 i586 x

stig
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
