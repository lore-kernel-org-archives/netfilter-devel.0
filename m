From: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Subject: Syn proxy causes vcenter traffic not working properly
Date: Mon, 21 Dec 2015 13:22:51 +0200
Message-ID: <CAK6Qs9kNO0P1LJ1_3cEm+wqe97zR970dC7_TgnBtuu21HnhmMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37243 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbLULWw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Dec 2015 06:22:52 -0500
Received: by mail-wm0-f46.google.com with SMTP id p187so64953517wmp.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Dec 2015 03:22:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

There is a firewall between vcenter server and vsphere machines. We
have trouble with vcenter traffic and syn proxy. Vcenter works fine
when I disable synproxy but it does not work properly when I enable
it.

This is rules I added.

iptables -t raw -A PREROUTING -i enp12s0f0 -p tcp -m tcp --tcp-flags
FIN,SYN,RST,ACK SYN -j CT --notrack
iptables -A FORWARD -i enp12s0f0 -p tcp -m tcp -m state --state
INVALID,UNTRACKED --sack-perm --timestamp --wscale 7 --mss 1460 -j
SYNPROXY
iptables -A FORWARD -i enp12s0f0 -p tcp -m tcp -m state --state INVALID -j DROP


I inspected the packets and realized that when syn proxy enabled,
server send rst packets just after tcp handshake. 192.168.0.1 is
vcenter server's IP address.

13:47:59.478585 IP 192.168.0.1.49210 > 192.168.0.20.443: Flags [S],
seq 3891662468, win 14600, options [mss 1460,sackOK,TS val 603479375
ecr 0,nop,wscale 7], length 0
13:47:59.478607 IP 192.168.0.20.443 > 192.168.0.1.49210: Flags [S.],
seq 3361123086, ack 3891662469, win 0, options [mss 1460,sackOK,TS val
1137639895 ecr 603479375,nop,wscale 7], length 0
13:47:59.478728 IP 192.168.0.1.49210 >192.168.0.20.443: Flags [.], ack
1, win 115, options [nop,nop,TS val 603479376 ecr 1137639895], length
0
13:47:59.478890 IP 192.168.0.20.443 > 192.168.0.1.49210: Flags [.],
ack 1, win 127, options [nop,nop,TS val 1137639895 ecr 603479376],
length 0
13:47:59.478985 IP 192.168.0.20.443 > 192.168.0.1.49210: Flags [R],
seq 3361123087, win 0, length 0
13:47:59.479008 IP 192.168.0.1.49210 > 192.168.0.20.443: Flags [P.],
seq 1:63, ack 1, win 115, options [nop,nop,TS val 603479376 ecr
1137639895], length 62
13:47:59.479121 IP 192.168.0.20.443 > 192.168.0.1.49210: Flags [R],
seq 3361123087, win 0, length 0

And below packets recorded while syn proxy disabled.

15:03:40.157064 IP 192.168.0.1.53169 > 192.168.0.20.443: Flags [S],
seq 2940370351, win 14600, options [mss 1460,sackOK,TS val 604614515
ecr 0,nop,wscale 7], length 0
15:03:40.157200 IP 192.168.0.20.443 > 192.168.0.1.53169: Flags [S.],
seq 3175370053, ack 2940370352, win 65535, options [mss
1460,nop,wscale 9,sackOK,TS val 317544961 ecr 604614515], length 0
15:03:40.157326 IP 192.168.0.1.53169 > 192.168.0.20.443: Flags [.],
ack 1, win 115, options [nop,nop,TS val 604614515 ecr 317544961],
length 0
15:03:40.157626 IP 192.168.0.1.53169 > 192.168.0.20.443: Flags [P.],
seq 1:63, ack 1, win 115, options [nop,nop,TS val 604614515 ecr
317544961], length 62
15:03:40.158336 IP 192.168.0.20.443 > 192.168.0.1.53169: Flags [P.],
seq 1:1093, ack 63, win 130, options [nop,nop,TS val 317544961 ecr
604614515], length 1092
15:03:40.158599 IP 192.168.0.1.53169 > 192.168.0.20.443: Flags [.],
ack 1093, win 137, options [nop,nop,TS val 604614516 ecr 317544961],
length 0
15:03:40.159197 IP 192.168.0.1.53169 > 192.168.0.20.443: Flags [P.],
seq 63:403, ack 1093, win 137, options [nop,nop,TS val 604614516 ecr
317544961], length 340
15:03:40.169577 IP 192.168.0.20.443 > 192.168.0.1.53169: Flags [P.],
seq 1093:1168, ack 403, win 130, options [nop,nop,TS val 317544962 ecr
604614516], length 75
15:03:40.170677 IP 192.168.0.1.53169 > 192.168.0.20.443: Flags [P.],
seq 403:653, ack 1168, win 137, options [nop,nop,TS val 604614519 ecr
317544962], length 250
15:03:40.176009 IP 192.168.0.20.443 > 192.168.0.1.53169: Flags [P.],
seq 1168:1530, ack 653, win 130, options [nop,nop,TS val 317544962 ecr
604614519], length 362
15:03:40.214456 IP 192.168.0.1.53169 > 192.168.0.20.443: Flags [.],
ack 1530, win 154, options [nop,nop,TS val 604614530 ecr 317544962],
length 0

I can simply solve problem by adding exception rule for vcenter IP .
But I want to know why it doesn't work and solve it if it is possible.
Thanks for any help.

--
ibrahim
