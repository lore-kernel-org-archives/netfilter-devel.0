From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Fri, 11 Jan 2008 13:57:11 +0100
Message-ID: <478767A7.9000807@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>	 <476A5130.6050800@trash.net>	 <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>	 <476CC345.7050108@trash.net>	 <9a4a382a0712260154l5f0773fy1d2da6cc94a780c6@mail.gmail.com>	 <4777DB2F.4010307@trash.net>	 <9a4a382a0801020118n4166e505l5eb84a9f07f620be@mail.gmail.com>	 <9a4a382a0801110010h3b4ed334sb53392ab564c00b5@mail.gmail.com>	 <47876013.2040405@trash.net> <9a4a382a0801110453m66b42329w15c6ae3b68d37699@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-1?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51215 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451AbYAKM5P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:57:15 -0500
In-Reply-To: <9a4a382a0801110453m66b42329w15c6ae3b68d37699@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Damien Th=E9bault wrote:
> On Jan 11, 2008 1:24 PM, Patrick McHardy <kaber@trash.net> wrote:
>  =20
>> No, this should work properly. I just tried to reproduce it,
>> but I only get a single POSTROUTING invocation. I tried with
>> real bridged traffic, traffic routed between two different
>> bridge devices and traffic routed between a bridge device
>> and a normal ethernet device, but everything seems to work
>> correctly.
>>
>> Could you send me the commands you're using to configure
>> your setup and everything (routing, iptables, ...) that
>> could be related?
>>
>>    =20
>
> On the router, I'm using this script :
>
> ifconfig eth0 0.0.0.0 up
> brctl addbr br0
> brctl addif br0 eth0
> ifconfig br0 192.168.1.70 up
> ifconfig br0:0 192.168.2.70 up
> iptables -t nat -A POSTROUTING -d 192.168.2.0/24 -j MASQUERADE
> iptables -t nat -A PREROUTING -d 192.168.2.250 -j DNAT
> --to-destination 192.168.2.50
> modprobe nf_nat_ftp
> echo 1 > /proc/sys/net/ipv4/ip_forward
>
> And for logging :
>
> modprobe ipt_LOG
> iptables -t raw -A OUTPUT -p tcp --dport 21 -j TRACE
> iptables -t raw -A OUTPUT -p tcp --sport 21 -j TRACE
> iptables -t raw -A PREROUTING -p tcp --dport 21 -j TRACE
> iptables -t raw -A PREROUTING -p tcp --sport 21 -j TRACE
>
> I only have one interface (eth0), that's why I use br0 and br0:0, so
> the wireshark captures show each packet twice, input on br0 and outpu=
t
> on br0:0 (or input on br0:0 and output on br0) when capturing on eth0=
=2E
>
> On the ftp client/server :
>
> ifconfig eth2 192.168.1.50
> ifconfig eth2:0 192.168.2.50
> ip route del 192.168.2.0/24
> ip route add 192.168.2.0/24 dev eth2 via 192.168.1.70
>
> And then I try to connect to 192.168.2.250, this will use the router
> 192.168.1.70 on eth2, wille be DNATted to 192.168.2.50 and will come
> back on eth2:0 on the ftp server.
>
> Like the router captures, we have eth2 and eth2:0 together when
> capturing on eth2.
>
> This configuration will work fine, but if I run any of this on the
> router, it will not work well anymore :
>
> ifconfig br0:0 192.168.2.7 up
>
> or
>
> ifconfig br0:0 192.168.2.170 up
>
> I don't think I'm using anything else.
>  =20

Thanks. Its the DNAT rule thats causing this, the bridge netfilter code
calls dst_output directly for bridged dnated frames, causing these
hook invocations:

                PREROUTING
dst_output()    POSTROUTING
                FORWARD
                POSTROUTING


which is obviously broken. I'll see if I can come up with a fix for thi=
s.

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
