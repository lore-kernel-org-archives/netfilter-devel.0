From: "Ron Lai" <ronlai@cs.stanford.edu>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Wed, 7 Nov 2007 15:54:44 -0800
Message-ID: <000a01c82199$92441f30$bb0b10ac@FireEye.com>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc> <47307498.70104@trash.net> <005301c820fc$35c63a10$6400a8c0@ronPc> <47318A3C.5070701@trash.net> <005b01c82151$4acac750$6500a8c0@ronPc> <473247F6.8090204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-15";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: <netfilter@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	"Bart De Schuymer" <bdschuym@pandora.be>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-ip link list
1: pether1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 
1000
    link/ether 00:d0:68:0d:f4:94 brd ff:ff:ff:ff:ff:ff
2: pether2: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:d0:68:0d:f4:93 brd ff:ff:ff:ff:ff:ff
3: pether6: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:98 brd ff:ff:ff:ff:ff:ff
4: pether5: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:99 brd ff:ff:ff:ff:ff:ff
5: pether4: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:9a brd ff:ff:ff:ff:ff:ff
6: pether3: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:9b brd ff:ff:ff:ff:ff:ff
7: lo: <LOOPBACK,UP,10000> mtu 16436 qdisc noqueue
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
12: ether1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc noqueue
    link/ether 00:d0:68:0d:f4:94 brd ff:ff:ff:ff:ff:ff

-ip addr show
1: pether1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 
1000
    link/ether 00:d0:68:0d:f4:94 brd ff:ff:ff:ff:ff:ff
2: pether2: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:d0:68:0d:f4:93 brd ff:ff:ff:ff:ff:ff
3: pether6: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:98 brd ff:ff:ff:ff:ff:ff
4: pether5: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:99 brd ff:ff:ff:ff:ff:ff
5: pether4: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:9a brd ff:ff:ff:ff:ff:ff
6: pether3: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:e0:ed:07:f8:9b brd ff:ff:ff:ff:ff:ff
7: lo: <LOOPBACK,UP,10000> mtu 16436 qdisc noqueue
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 brd 127.255.255.255 scope host lo
12: ether1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc noqueue
    link/ether 00:d0:68:0d:f4:94 brd ff:ff:ff:ff:ff:ff
    inet 172.16.119.87/12 brd 172.31.255.255 scope global ether1

-ip route show
172.16.0.0/12 dev ether1  proto kernel  scope link  src 172.16.119.87
default via 172.16.1.1 dev ether1  metric 1

-brctl show
bridge name     bridge id               STP enabled     interfaces
ether1          8000.00d0680df494       no              pether1

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "ron lai" <ronlai@cs.stanford.edu>
Cc: <netfilter@vger.kernel.org>; <netfilter-devel@vger.kernel.org>; "Bart De 
Schuymer" <bdschuym@pandora.be>
Sent: Wednesday, November 07, 2007 3:19 PM
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 
2.6.22.6


> ron lai wrote:
>> I am using a single bridge with one device.
>
> In that case please post the full output of:
>
> ip link list
> ip addr show
> ip route show
> brctl show
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

