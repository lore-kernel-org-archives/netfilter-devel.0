From: Stig <stig@ubnt.com>
Subject: Re: ULOG and vlans
Date: Fri, 29 Jul 2011 11:59:53 -0700
Message-ID: <CAL-yc8_DYLjKKE9OHjtFuiEB0me5XgJr8ABMmsJEXWjG-vC04A@mail.gmail.com>
References: <CAL-yc8_nbzJu8FxAVBycdeXtciz=FGYxXzQtT88xYQ3wX60hBQ@mail.gmail.com>
	<4E3144DA.7060009@trash.net>
	<CAL-yc88wjr-0H1LF+x5FLf=h1XhswbQ78McHvZ4NL5+p08gUTw@mail.gmail.com>
	<4E32C25C.8080003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39030 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752631Ab1G2S7z convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:59:55 -0400
Received: by mail-ey0-f173.google.com with SMTP id 7so5983008eyb.32
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2011 11:59:53 -0700 (PDT)
In-Reply-To: <4E32C25C.8080003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 29, 2011 at 7:23 AM, Patrick McHardy <kaber@trash.net> wrot=
e:
> On 28.07.2011 19:00, Stig wrote:
>> On Thu, Jul 28, 2011 at 4:15 AM, Patrick McHardy <kaber@trash.net> w=
rote:
>>> On 27.07.2011 20:59, Stig wrote:
>>>> I'm using ULOG iptables target to capture packets for pmacct (a
>>>> netflow exporter). =A0I noticed when ulog gets a packet from a vla=
n
>>>> interface that the ulog header shows a mac_len of 18 bytes, but it
>>>> appears that the vlan tag has already been stripped from the packe=
t
>>>> header:
>>>>
>>>> (gdb) p/x *ulog_pkt
>>>> $7 =3D {
>>>> =A0 mark =3D 0x0,
>>>> =A0 timestamp_sec =3D 0x4e2f6077,
>>>> =A0 timestamp_usec =3D 0x222f3,
>>>> =A0 hook =3D 0x0,
>>>> =A0 indev_name =3D {0x65, 0x74, 0x68, 0x31, 0x2e, 0x31, 0x30, 0x30=
, 0x0, 0x0, 0x0,
>>>> =A0 =A0 0x0, 0x0, 0x0, 0x0, 0x0},
>>>> =A0 outdev_name =3D {0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff=
, 0x5, 0xf, 0x0,
>>>> =A0 =A0 0x0, 0x5, 0xf, 0x0, 0x0},
>>>> =A0 data_len =3D 0x40,
>>>> =A0 prefix =3D {0x0, 0x0, 0x2, 0x0, 0x72, 0x60, 0x2f, 0x4e, 0xed, =
0x6, 0x0, 0x0,
>>>> =A0 =A0 0xa, 0x40, 0x80, 0xfd, 0x2, 0x0, 0x0, 0x0, 0x14, 0x0, 0x1,=
 0x0, 0xfe,
>>>> =A0 =A0 0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
>>>> =A0 mac_len =3D 0x12,
>>>> =A0 mac =3D {0x0, 0xd, 0xb9, 0x15, 0x6d, 0x1, 0x0, 0xf, 0x30, 0x4,=
 0x35, 0x4f,
>>>> =A0 =A0 0x8, 0x0, 0x45, 0x0, 0x0, 0x54, 0xff, 0x21, 0x12, 0x0, 0x0=
, 0x21, 0x12,
>>>> =A0 =A0 0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x14, 0x0, 0x2, 0x0, 0x72, =
0x60, 0x2f,
>>>> =A0 =A0 0x4e, 0xed, 0x6, 0x0, 0x0, 0xa, 0x40, 0x80, 0xfd, 0x3, 0x0=
, 0x0, 0x0,
>>>> =A0 =A0 0x14, 0x0, 0x1, 0x0, 0xfe, 0x80, 0x0, 0x0, 0x0, 0x0, 0x0, =
0x0, 0x2, 0xd,
>>>> =A0 =A0 0xb9, 0xff, 0xfe, 0x15, 0x6d, 0x1, 0x14, 0x0, 0x6, 0x0, 0x=
ff, 0xff, 0xff,
>>>> =A0 =A0 0xff, 0xff},
>>>> =A0 payload =3D 0x941cc35
>>>> }
>>>>
>>>>
>>>> If the vlan has been remove, shouldn't the mac_len be reduced to 1=
4?
>>>
>>> Yes. How is your vlan device configured (ip -s link show vlanX)?
>>
>> vyatta@vyatta:~$ ip -s link show eth1.100
>> 4: eth1.100@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc n=
oqueue stat
>> =A0 =A0 link/ether 00:0d:b9:15:6d:01 brd ff:ff:ff:ff:ff:ff
>> =A0 =A0 RX: bytes =A0packets =A0errors =A0dropped overrun mcast
>> =A0 =A0 296652 =A0 =A0 3372 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0=
 =A0 =A0 0
>> =A0 =A0 TX: bytes =A0packets =A0errors =A0dropped carrier collsns
>> =A0 =A0 344216 =A0 =A0 3376 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0=
 =A0 =A0 0
>
> Sorry, I actually meant ip -d link show vlanX. Also, what driver are
> you using?

vyatta@vyatta:~# ip -d link sh eth1.100
4: eth1.100@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqu=
eue stat
    link/ether 00:0d:b9:15:6d:01 brd ff:ff:ff:ff:ff:ff
    vlan id 100 <REORDER_HDR>

vyatta@vyatta:~# ethtool -i eth1.100
driver: 802.1Q VLAN Support
version: 1.8
firmware-version: N/A
bus-info:

vyatta@vyatta:~# ethtool -i eth1
driver: via-rhine
version: 1.4.3
firmware-version:
bus-info: 0000:00:0a.0


I've also see the same issue under kvm with:

root@dut2:/home/vyatta# ip -d link show eth1.123
12: eth1.123@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
noqueue state UP
    link/ether 52:54:00:e7:68:9e brd ff:ff:ff:ff:ff:ff
    vlan id 123 <REORDER_HDR>

root@dut2:/home/vyatta# ethtool -i eth1
driver: pcnet32
version: 1.35
firmware-version:
bus-info: 0000:00:06.0

stig
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
