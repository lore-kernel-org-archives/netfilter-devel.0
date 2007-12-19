From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Wed, 19 Dec 2007 18:00:47 +0100
Message-ID: <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Patrick McHardy" <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:34964 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbXLSRAu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:00:50 -0500
Received: by wr-out-0506.google.com with SMTP id c49so2089006wra.1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Dec 2007 09:00:48 -0800 (PST)
In-Reply-To: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I sent the quoted mail to linux-net with my problem yesterday, but I
did a git bisect today and I got the following output :

> 2bf540b73ed5b304e84bb4d4c390d49d1cfa0ef8 is first bad commit
> commit 2bf540b73ed5b304e84bb4d4c390d49d1cfa0ef8
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Wed Dec 13 16:54:25 2006 -0800
>
>     [NETFILTER]: bridge-netfilter: remove deferred hooks
>
>     Remove the deferred hooks and all related code as scheduled in
>     feature-removal-schedule.
>
>     Signed-off-by: Patrick McHardy <kaber@trash.net>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> :040000 040000 c49ea947455937566b6129991dde5e86f2453aae 6611736ce5c0f=
cde7627494b66b9ea94e37ea42e M      Documentation
> :040000 040000 d0dd0700fe68f98b52687be3a0c31d73f7b15b81 f8ddf15a0389c=
5f5b7f2c11d7d0db039a660e1d5 M      include
> :040000 040000 dafccf7ff8657be9adca6b28dbd365cdd6c01ca5 3eeb1cb4b16cc=
5cb698ab559b47ea6b0991d4d3a M      net

With exactly this version, the behaviour is similar with what I see
with 2.6.23 and 2.6.24-rc5 (see below).


The original mail :

On Dec 18, 2007 3:48 PM, Damien Th=E9bault <damien.thebault@gmail.com> =
wrote:
> Hello,
>
> I was trying to use a setup with nat and bridge, but conntrack doesn'=
t
> work properly (at first I tried rtsp, but since it's an external patc=
h
> with some modifications, I used ftp for my tests).
> I removed everything but the minimal setup to report this bug :
>
> A) one ftp client, on 192.168.1.0/24 (192.168.1.50 or 192.168.1.5 or
> 192.168.1.150 or 192.168.1.15, see below)
> B) one router doing nat
>   b1) one interface is on 192.168.1.0/24 with the ftp client (192.168=
=2E1.70)
>   b2) the other interface is on 192.168.2.0/24 with the ftp server
> (192.168.2.70 or 192.168.2.7, see below)
> C) one ftp server, on 192.168.2.0/24 (192.168.2.50)
>
> To do my tests, I used only one physical interface on the router,
> configured with two ip addresses. This interface is either a real
> interface or a bridge on top of only this same real interface, for
> exemple :
> ifconfig eth0 192.168.1.70 up
> ifconfig eth0:0 192.168.2.70 up
> or :
> ifconfig eth0:0 down
> brctl addbr br0
> brctl addif br0 eth0
> ifconfig eth0 0.0.0.0 up
> ifconfig br0 192.168.1.70 up
> ifconfig br0:0 192.168.2.70 up
>
> the following netfilter configuration is used :
> iptables -t nat -A POSTROUTING -d 192.168.2.0/24 -j MASQUERADE
>
> I tried this once with three computers, and the today with only two
> computers. But to do this two-computers setup, I had to add another
> rule to do the trick :
> iptables -t nat -A PREROUTING -d 192.168.2.250 -j DNAT
> --to-destination 192.168.2.50
> And I connect from the computer with both 192.168.1.50 and
> 192.168.2.50 to the ftp server 192.168.2.250, the route for
> 192.168.2.0/24 goes via the router, is natted and comes back.
> The behaviour is the same with three distinct computers or with this,
> so it's not really interesting here.
>
> What I'm seeing, is that when the bridge is used, and when the output
> ip address of the router is longer or smaller than the ip address of
> the client, then conntrack doesn't work!
> The good address is present after nat_ftp ("wan"-side ip address of
> ther router), everything seems to work well but the incoming connexio=
n
> from port 20 is not forwarded (RST is replied to the SYN).
> If the bridge is not used, or if the two ip addresses have the same
> length, then it works as expected.
>
> The kernel used on the router is 2.6.24-rc5-git5, and active ftp is u=
sed.
> I collected /proc/net/nf_conntrack on each try, if something else is
> needed, I'll get what is needed (the packets captures with wireshark
> look ok in every case, but maybe someone will need them?).
>
> 1) without a bridge
>  * 192.168.1.50 -> 192.168.1.70 [ nat ] 192.168.2.7  -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 118 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.7
> sport=3D20 dport=3D51956 packets=3D5 bytes=3D334 src=3D192.168.1.50
> dst=3D192.168.2.250 sport=3D51956 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
> ipv4     2 tcp      6 431998 ESTABLISHED src=3D192.168.1.50
> dst=3D192.168.2.250 sport=3D52709 dport=3D21 packets=3D11 bytes=3D635
> src=3D192.168.2.50 dst=3D192.168.2.7 sport=3D21 dport=3D52709 packets=
=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
>
>  * 192.168.1.50 -> 192.168.1.70 [ nat ] 192.168.2.70 -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 431998 ESTABLISHED src=3D192.168.1.50
> dst=3D192.168.2.250 sport=3D52747 dport=3D21 packets=3D11 bytes=3D634
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D52747 packet=
s=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
> ipv4     2 tcp      6 118 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D20 dport=3D43608 packets=3D5 bytes=3D334 src=3D192.168.1.50
> dst=3D192.168.2.250 sport=3D43608 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
>
>  * 192.168.1.5  -> 192.168.1.70 [ nat ] 192.168.2.7  -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 117 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.7
> sport=3D20 dport=3D41758 packets=3D5 bytes=3D334 src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D41758 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
> ipv4     2 tcp      6 431997 ESTABLISHED src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D47397 dport=3D21 packets=3D11 bytes=3D633
> src=3D192.168.2.50 dst=3D192.168.2.7 sport=3D21 dport=3D47397 packets=
=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
>
>  * 192.168.1.5  -> 192.168.1.70 [ nat ] 192.168.2.70 -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 431998 ESTABLISHED src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D53851 dport=3D21 packets=3D11 bytes=3D634
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D53851 packet=
s=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
> ipv4     2 tcp      6 118 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D20 dport=3D51600 packets=3D5 bytes=3D334 src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D51600 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
>
>  * 192.168.1.150-> 192.168.1.70 [ nat ] 192.168.2.70 -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 431998 ESTABLISHED src=3D192.168.1.150
> dst=3D192.168.2.250 sport=3D41108 dport=3D21 packets=3D11 bytes=3D636
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D41108 packet=
s=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
> ipv4     2 tcp      6 118 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D20 dport=3D35479 packets=3D5 bytes=3D334 src=3D192.168.1.150
> dst=3D192.168.2.250 sport=3D35479 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
>
>  * 192.168.1.15 -> 192.168.1.70 [ nat ] 192.168.2.70 -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 118 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D20 dport=3D46819 packets=3D5 bytes=3D334 src=3D192.168.1.15
> dst=3D192.168.2.250 sport=3D46819 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
> ipv4     2 tcp      6 431998 ESTABLISHED src=3D192.168.1.15
> dst=3D192.168.2.250 sport=3D44839 dport=3D21 packets=3D11 bytes=3D635
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D44839 packet=
s=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
>
> 2) with a bridge
>  * 192.168.1.50 -> 192.168.1.70 [ nat ] 192.168.2.7  -> 192.168.2.50
> ftp doesn't work
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 431998 ESTABLISHED src=3D192.168.1.50
> dst=3D192.168.2.250 sport=3D56140 dport=3D21 packets=3D13 bytes=3D796
> src=3D192.168.2.50 dst=3D192.168.2.7 sport=3D21 dport=3D56140 packets=
=3D13
> bytes=3D1109 [ASSURED] mark=3D0 secmark=3D0 use=3D1
>
>  * 192.168.1.50 -> 192.168.1.70 [ nat ] 192.168.2.70 -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 431997 ESTABLISHED src=3D192.168.1.50
> dst=3D192.168.2.250 sport=3D34334 dport=3D21 packets=3D11 bytes=3D635
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D34334 packet=
s=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
> ipv4     2 tcp      6 118 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D20 dport=3D59124 packets=3D5 bytes=3D334 src=3D192.168.1.50
> dst=3D192.168.2.250 sport=3D59124 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
>
>  * 192.168.1.5  -> 192.168.1.70 [ nat ] 192.168.2.7  -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 116 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.7
> sport=3D20 dport=3D36148 packets=3D5 bytes=3D334 src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D36148 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
> ipv4     2 tcp      6 431996 ESTABLISHED src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D46925 dport=3D21 packets=3D11 bytes=3D633
> src=3D192.168.2.50 dst=3D192.168.2.7 sport=3D21 dport=3D46925 packets=
=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
>
>  * 192.168.1.5  -> 192.168.1.70 [ nat ] 192.168.2.70 -> 192.168.2.50
> ftp doesn't work
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 59 CLOSE_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D20 dport=3D60875 packets=3D4 bytes=3D282 src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D60875 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
> ipv4     2 tcp      6 431999 ESTABLISHED src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D48877 dport=3D21 packets=3D12 bytes=3D687
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D48877 packet=
s=3D9
> bytes=3D939 [ASSURED] mark=3D0 secmark=3D0 use=3D2
>
>  * 192.168.1.150-> 192.168.1.70 [ nat ] 192.168.2.70  -> 192.168.2.50
> ftp doesn't work
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 431999 ESTABLISHED src=3D192.168.1.150
> dst=3D192.168.2.250 sport=3D33847 dport=3D21 packets=3D14 bytes=3D878
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D33847 packet=
s=3D14
> bytes=3D1173 [ASSURED] mark=3D0 secmark=3D0 use=3D1
>
>  * 192.168.1.15 -> 192.168.1.70 [ nat ] 192.168.2.70 -> 192.168.2.50
> ftp works
> /proc/net/nf_conntrack :
> ipv4     2 tcp      6 431998 ESTABLISHED src=3D192.168.1.15
> dst=3D192.168.2.250 sport=3D46792 dport=3D21 packets=3D11 bytes=3D633
> src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D21 dport=3D46792 packet=
s=3D8
> bytes=3D880 [ASSURED] mark=3D0 secmark=3D0 use=3D2
> ipv4     2 tcp      6 118 TIME_WAIT src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D20 dport=3D56576 packets=3D5 bytes=3D334 src=3D192.168.1.15
> dst=3D192.168.2.250 sport=3D56576 dport=3D20 packets=3D3 bytes=3D164 =
[ASSURED]
> mark=3D0 secmark=3D0 use=3D1
>

--
Damien Th=E9bault
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
