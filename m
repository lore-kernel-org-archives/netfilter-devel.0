From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Fri, 11 Jan 2008 13:53:21 +0100
Message-ID: <9a4a382a0801110453m66b42329w15c6ae3b68d37699@mail.gmail.com>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>
	 <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>
	 <476A5130.6050800@trash.net>
	 <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>
	 <476CC345.7050108@trash.net>
	 <9a4a382a0712260154l5f0773fy1d2da6cc94a780c6@mail.gmail.com>
	 <4777DB2F.4010307@trash.net>
	 <9a4a382a0801020118n4166e505l5eb84a9f07f620be@mail.gmail.com>
	 <9a4a382a0801110010h3b4ed334sb53392ab564c00b5@mail.gmail.com>
	 <47876013.2040405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <47876013.2040405@trash.net>
Content-Disposition: inline
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Jan 11, 2008 1:24 PM, Patrick McHardy <kaber@trash.net> wrote:
> Damien Th=E9bault wrote:
> >
> > By the way, Patrick, what do you think about this bug? Maybe I
> > shouldn't rely on bridges but it's a useful feature sometimes.
> >
>
> No, this should work properly. I just tried to reproduce it,
> but I only get a single POSTROUTING invocation. I tried with
> real bridged traffic, traffic routed between two different
> bridge devices and traffic routed between a bridge device
> and a normal ethernet device, but everything seems to work
> correctly.
>
> Could you send me the commands you're using to configure
> your setup and everything (routing, iptables, ...) that
> could be related?
>

On the router, I'm using this script :

ifconfig eth0 0.0.0.0 up
brctl addbr br0
brctl addif br0 eth0
ifconfig br0 192.168.1.70 up
ifconfig br0:0 192.168.2.70 up
iptables -t nat -A POSTROUTING -d 192.168.2.0/24 -j MASQUERADE
iptables -t nat -A PREROUTING -d 192.168.2.250 -j DNAT
--to-destination 192.168.2.50
modprobe nf_nat_ftp
echo 1 > /proc/sys/net/ipv4/ip_forward

And for logging :

modprobe ipt_LOG
iptables -t raw -A OUTPUT -p tcp --dport 21 -j TRACE
iptables -t raw -A OUTPUT -p tcp --sport 21 -j TRACE
iptables -t raw -A PREROUTING -p tcp --dport 21 -j TRACE
iptables -t raw -A PREROUTING -p tcp --sport 21 -j TRACE

I only have one interface (eth0), that's why I use br0 and br0:0, so
the wireshark captures show each packet twice, input on br0 and output
on br0:0 (or input on br0:0 and output on br0) when capturing on eth0.

On the ftp client/server :

ifconfig eth2 192.168.1.50
ifconfig eth2:0 192.168.2.50
ip route del 192.168.2.0/24
ip route add 192.168.2.0/24 dev eth2 via 192.168.1.70

And then I try to connect to 192.168.2.250, this will use the router
192.168.1.70 on eth2, wille be DNATted to 192.168.2.50 and will come
back on eth2:0 on the ftp server.

Like the router captures, we have eth2 and eth2:0 together when
capturing on eth2.

This configuration will work fine, but if I run any of this on the
router, it will not work well anymore :

ifconfig br0:0 192.168.2.7 up

or

ifconfig br0:0 192.168.2.170 up

I don't think I'm using anything else.
--=20
Damien Thebault
