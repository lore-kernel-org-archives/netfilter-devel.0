From: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
Subject: Re: v2.6.8.1 breaks tspc
Date: Sun, 22 Aug 2004 17:43:22 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408221743.22561.vda@port.imtp.ilyichevsk.odessa.ua>
References: <200408212303.05143.mail@earthworm.de> <200408221012.12846.vda@port.imtp.ilyichevsk.odessa.ua> <200408221506.07883.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_KELKBWxCBL9mZHw"
Cc: linux-kernel@vger.kernel.org,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Hesse <mail@earthworm.de>
In-Reply-To: <200408221506.07883.mail@earthworm.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_KELKBWxCBL9mZHw
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> > > > > Kernel version 2.6.8.1 breaks tspc (Freenet6's Tunnel Server
> > > > > Protocol Client). It tries to connect to the server but waits
> > > > > forever. No problems with 2.6.7, booted the old kernel and it
> > > > > worked perfectly.
> > > > >
> > > > > Any ideas?
> > > >
> > > > What do you see with tcpdump on both 2.6.7 and 2.6.8.1?
> > >
> > > In the config file I've changed template from linux to checktunnel.
> > > With kernel 2.6.7 it shows all the options it receives from the server.
> > > With 2.6.8.1:
> > >
> > > root@noname:~# tspc -f /etc/freenet6/tspc.conf -vvv
> > > tspc - Tunnel Server Protocol Client
> > >
> > > Loading configuration file
> > >
> > > Connecting to server
> > >
> > > [now waits until Ctrl-c]
> > >
> > > A log of strace can be found at
> > > http://linux.eworm.net/tspc_strace.log
> >
> > Strace shows that read from the network fails:
> >
> > socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 5
> > connect(5, {sa_family=AF_INET, sin_port=htons(3653),
> > sin_addr=inet_addr("206.123.31.115")}, 16) = 0 write(5,
> > "VERSION=1.0.1\r\n", 15)       = 15
> > read(5,  <unfinished ...>
> >
> > There are several possibilities.
> > What do you see with _*tcpdump*_ on both 2.6.7 and 2.6.8.1?
>
> On 2.6.8.1:
>
> tcpdump -i ppp0 -l -n -vv | grep 206.123.31.115
> [starting tspc]
> 14:50:31.134509 IP (tos 0x0, ttl  64, id 48887, offset 0, flags [DF],
> length: 60) 80.144.45.203.1044 > 206.123.31.115.3653: S [tcp sum ok]

It linewrapped. Try to avoid that in the future.

Anyway, basically we see this:

- == 2.6.8.1
+ == 2.6.7

-14:50:31.134509 IP (tos 0x0, ttl  64, id 48887, offset 0, flags [DF], length: 60) 80.144.45.203.1044 > 206.123.31.115.3653: S [tcp sum ok] 4178156718:4178156718(0) win 5808 <mss 1452,sackOK,timestamp 58729049 0,nop,wscale 7>
+15:04:49.203584 IP (tos 0x0, ttl  64, id 52907, offset 0, flags [DF], length: 60) 80.144.41.228.1027 > 206.123.31.115.3653: S [tcp sum ok] 1954213114:1954213114(0) win 5808 <mss 1452,sackOK,timestamp 4294779473 0,nop,wscale 0>

TCP start. NB: "wscale 7"!

-14:50:31.311512 IP (tos 0x0, ttl  54, id 40688, offset 0, flags [none], length: 60) 206.123.31.115.3653 > 80.144.45.203.1044: S [tcp sum ok] 194693109:194693109(0) ack 4178156719 win 16384 <mss 1412,nop,wscale 0,nop,nop,timestamp 0 58729049>
+15:04:49.467356 IP (tos 0x0, ttl  54, id 4239, offset 0, flags [none], length: 60) 206.123.31.115.3653 > 80.144.41.228.1027: S [tcp sum ok] 128683752:128683752(0) ack 1954213115 win 16384 <mss 1412,nop,wscale 0,nop,nop,timestamp 0 4294779473>

-14:50:31.311672 IP (tos 0x0, ttl  64, id 48888, offset 0, flags [DF], length: 52) 80.144.45.203.1044 > 206.123.31.115.3653: . [tcp sum ok] 1:1(0) ack 1 win 46 <nop,nop,timestamp 58729226 0>
+15:04:49.468059 IP (tos 0x0, ttl  64, id 52908, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: . [tcp sum ok] 1:1(0) ack 1 win 5808 <nop,nop,timestamp 4294779738 0>

"win 46" looks not ok.

-14:50:31.312369 IP (tos 0x0, ttl  64, id 48889, offset 0, flags [DF], length: 67) 80.144.45.203.1044 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 46 <nop,nop,timestamp 58729227 0>
+15:04:49.468870 IP (tos 0x0, ttl  64, id 52909, offset 0, flags [DF], length: 67) 80.144.41.228.1027 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 5808 <nop,nop,timestamp 4294779739 0>

"win 46" again.

-14:50:31.485246 IP (tos 0x0, ttl  54, id 40764, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.45.203.1044: . [tcp sum ok] 1:1(0) ack 1 win 17520
+15:04:49.642549 IP (tos 0x0, ttl  54, id 4306, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.41.228.1027: . [tcp sum ok] 1:1(0) ack 1 win 17520

-14:50:32.485776 IP (tos 0x0, ttl  64, id 48890, offset 0, flags [DF], length: 67) 80.144.45.203.1044 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 46 <nop,nop,timestamp 58730401 0>
+15:04:49.651404 IP (tos 0x0, ttl  54, id 4311, offset 0, flags [none], length: 106) 206.123.31.115.3653 > 80.144.41.228.1027: P 1:67(66) ack 16 win 17520

Here tcpdump outputs start ot diverge.

Looks like window scaling is not understood or incorrectly
handled by Linux or by remote box. I am no expert on this,
thus CCing LKML and netfilter list.

Please try whether it works whan you do
"echo 0 > /proc/sys/net/ipv4/tcp_window_scaling"

Search for thread "network regression using 2.6.8.x behind Cisco 1712"
on lkml.org.

Un-linewrapped tcpdumps are attached.
--
vda

--Boundary-00=_KELKBWxCBL9mZHw
Content-Type: text/plain;
  charset="windows-1251";
  name="tspc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="tspc"

-14:50:31.134509 IP (tos 0x0, ttl  64, id 48887, offset 0, flags [DF], length: 60) 80.144.45.203.1044 > 206.123.31.115.3653: S [tcp sum ok] 4178156718:4178156718(0) win 5808 <mss 1452,sackOK,timestamp 58729049 0,nop,wscale 7>
+15:04:49.203584 IP (tos 0x0, ttl  64, id 52907, offset 0, flags [DF], length: 60) 80.144.41.228.1027 > 206.123.31.115.3653: S [tcp sum ok] 1954213114:1954213114(0) win 5808 <mss 1452,sackOK,timestamp 4294779473 0,nop,wscale 0>

-14:50:31.311512 IP (tos 0x0, ttl  54, id 40688, offset 0, flags [none], length: 60) 206.123.31.115.3653 > 80.144.45.203.1044: S [tcp sum ok] 194693109:194693109(0) ack 4178156719 win 16384 <mss 1412,nop,wscale 0,nop,nop,timestamp 0 58729049>
+15:04:49.467356 IP (tos 0x0, ttl  54, id 4239, offset 0, flags [none], length: 60) 206.123.31.115.3653 > 80.144.41.228.1027: S [tcp sum ok] 128683752:128683752(0) ack 1954213115 win 16384 <mss 1412,nop,wscale 0,nop,nop,timestamp 0 4294779473>

-14:50:31.311672 IP (tos 0x0, ttl  64, id 48888, offset 0, flags [DF], length: 52) 80.144.45.203.1044 > 206.123.31.115.3653: . [tcp sum ok] 1:1(0) ack 1 win 46 <nop,nop,timestamp 58729226 0>
+15:04:49.468059 IP (tos 0x0, ttl  64, id 52908, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: . [tcp sum ok] 1:1(0) ack 1 win 5808 <nop,nop,timestamp 4294779738 0>

-14:50:31.312369 IP (tos 0x0, ttl  64, id 48889, offset 0, flags [DF], length: 67) 80.144.45.203.1044 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 46 <nop,nop,timestamp 58729227 0>
+15:04:49.468870 IP (tos 0x0, ttl  64, id 52909, offset 0, flags [DF], length: 67) 80.144.41.228.1027 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 5808 <nop,nop,timestamp 4294779739 0>

-14:50:31.485246 IP (tos 0x0, ttl  54, id 40764, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.45.203.1044: . [tcp sum ok] 1:1(0) ack 1 win 17520
+15:04:49.642549 IP (tos 0x0, ttl  54, id 4306, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.41.228.1027: . [tcp sum ok] 1:1(0) ack 1 win 17520

-14:50:32.485776 IP (tos 0x0, ttl  64, id 48890, offset 0, flags [DF], length: 67) 80.144.45.203.1044 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 46 <nop,nop,timestamp 58730401 0>
+15:04:49.651404 IP (tos 0x0, ttl  54, id 4311, offset 0, flags [none], length: 106) 206.123.31.115.3653 > 80.144.41.228.1027: P 1:67(66) ack 16 win 17520


tcpdump -i ppp0 -l -n -vv | grep 206.123.31.115
[starting tspc]
14:50:31.134509 IP (tos 0x0, ttl  64, id 48887, offset 0, flags [DF], length: 60) 80.144.45.203.1044 > 206.123.31.115.3653: S [tcp sum ok] 4178156718:4178156718(0) win 5808 <mss 1452,sackOK,timestamp 58729049 0,nop,wscale 7>
14:50:31.311512 IP (tos 0x0, ttl  54, id 40688, offset 0, flags [none], length: 60) 206.123.31.115.3653 > 80.144.45.203.1044: S [tcp sum ok] 194693109:194693109(0) ack 4178156719 win 16384 <mss 1412,nop,wscale 0,nop,nop,timestamp 0 58729049>
14:50:31.311672 IP (tos 0x0, ttl  64, id 48888, offset 0, flags [DF], length: 52) 80.144.45.203.1044 > 206.123.31.115.3653: . [tcp sum ok] 1:1(0) ack 1 win 46 <nop,nop,timestamp 58729226 0>
14:50:31.312369 IP (tos 0x0, ttl  64, id 48889, offset 0, flags [DF], length: 67) 80.144.45.203.1044 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 46 <nop,nop,timestamp 58729227 0>
14:50:31.485246 IP (tos 0x0, ttl  54, id 40764, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.45.203.1044: . [tcp sum ok] 1:1(0) ack 1 win 17520
14:50:32.485776 IP (tos 0x0, ttl  64, id 48890, offset 0, flags [DF], length: 67) 80.144.45.203.1044 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 46 <nop,nop,timestamp 58730401 0>
14:50:32.659688 IP (tos 0x0, ttl  54, id 40933, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.45.203.1044: . [tcp sum ok] 67:67(0) ack 16 win 17520
14:50:36.277473 IP (tos 0x0, ttl  54, id 41580, offset 0, flags [none], length: 106) 206.123.31.115.3653 > 80.144.45.203.1043: FP 1:67(66) ack 1 win 17520
14:50:36.277615 IP (tos 0x0, ttl  64, id 21, offset 0, flags [DF], length: 40) 80.144.45.203.1043 > 206.123.31.115.3653: R [tcp sum ok] 4088698672:4088698672(0) win 0

[killing tspc with Ctrl-c]

14:52:10.496550 IP (tos 0x0, ttl  64, id 48891, offset 0, flags [DF], length: 52) 80.144.45.203.1044 > 206.123.31.115.3653: F [tcp sum ok] 16:16(0) ack 1 win 46 <nop,nop,timestamp 58828426 0>
14:52:10.694101 IP (tos 0x0, ttl  54, id 55750, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.45.203.1044: . [tcp sum ok] 68:68(0) ack 17 win 17520

On 2.6.7:

tcpdump -i ppp0 -l -n -vv | grep 206.123.31.115
15:04:49.196225 IP (tos 0x0, ttl  55, id 24594, offset 0, flags [none], length: 167) 206.123.31.101.53 > 80.144.41.228.1024:  9057* q: A? tsps2.freenet6.net. 1/1/3 tsps2.freenet6.net. A 206.123.31.115[|domain]
15:04:49.203584 IP (tos 0x0, ttl  64, id 52907, offset 0, flags [DF], length: 60) 80.144.41.228.1027 > 206.123.31.115.3653: S [tcp sum ok] 1954213114:1954213114(0) win 5808 <mss 1452,sackOK,timestamp 4294779473 0,nop,wscale 0>
15:04:49.467356 IP (tos 0x0, ttl  54, id 4239, offset 0, flags [none], length: 60) 206.123.31.115.3653 > 80.144.41.228.1027: S [tcp sum ok] 128683752:128683752(0) ack 1954213115 win 16384 <mss 1412,nop,wscale 0,nop,nop,timestamp 0 4294779473>
15:04:49.468059 IP (tos 0x0, ttl  64, id 52908, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: . [tcp sum ok] 1:1(0) ack 1 win 5808 <nop,nop,timestamp 4294779738 0>
15:04:49.468870 IP (tos 0x0, ttl  64, id 52909, offset 0, flags [DF], length: 67) 80.144.41.228.1027 > 206.123.31.115.3653: P [tcp sum ok] 1:16(15) ack 1 win 5808 <nop,nop,timestamp 4294779739 0>
15:04:49.642549 IP (tos 0x0, ttl  54, id 4306, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.41.228.1027: . [tcp sum ok] 1:1(0) ack 1 win 17520
15:04:49.651404 IP (tos 0x0, ttl  54, id 4311, offset 0, flags [none], length: 106) 206.123.31.115.3653 > 80.144.41.228.1027: P 1:67(66) ack 16 win 17520
15:04:49.651887 IP (tos 0x0, ttl  64, id 52910, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: . [tcp sum ok] 16:16(0) ack 67 win 5808 <nop,nop,timestamp 4294779922 0>
15:04:49.652383 IP (tos 0x0, ttl  64, id 52911, offset 0, flags [DF], length: 77) 80.144.41.228.1027 > 206.123.31.115.3653: P [tcp sum ok] 16:41(25) ack 67 win 5808 <nop,nop,timestamp 4294779922 0>
15:04:49.835957 IP (tos 0x0, ttl  54, id 4362, offset 0, flags [none], length: 133) 206.123.31.115.3653 > 80.144.41.228.1027: P 67:160(93) ack 41 win 17520
15:04:49.837496 IP (tos 0x0, ttl  64, id 52912, offset 0, flags [DF], length: 302) 80.144.41.228.1027 > 206.123.31.115.3653: P 41:291(250) ack 160 win 5808 <nop,nop,timestamp 4294780107 0>
15:04:50.041174 IP (tos 0x0, ttl  54, id 4383, offset 0, flags [none], length: 97) 206.123.31.115.3653 > 80.144.41.228.1027: P 160:217(57) ack 291 win 17520
15:04:50.080752 IP (tos 0x0, ttl  64, id 52913, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: . [tcp sum ok] 291:291(0) ack 217 win 5808 <nop,nop,timestamp 4294780351 0>
15:04:50.260391 IP (tos 0x0, ttl  54, id 4410, offset 0, flags [none], length: 53) 206.123.31.115.3653 > 80.144.41.228.1027: P [tcp sum ok] 217:230(13) ack 291 win 17520
15:04:50.260887 IP (tos 0x0, ttl  64, id 52914, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: . [tcp sum ok] 291:291(0) ack 230 win 5808 <nop,nop,timestamp 4294780531 0>
15:04:50.263472 IP (tos 0x0, ttl  64, id 52915, offset 0, flags [DF], length: 73) 80.144.41.228.1027 > 206.123.31.115.3653: P [tcp sum ok] 291:312(21) ack 230 win 5808 <nop,nop,timestamp 4294780533 0>
15:04:50.661978 IP (tos 0x0, ttl  54, id 4500, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.41.228.1027: . [tcp sum ok] 230:230(0) ack 312 win 17520
15:04:50.662433 IP (tos 0x0, ttl  64, id 52916, offset 0, flags [DF], length: 172) 80.144.41.228.1027 > 206.123.31.115.3653: P 312:432(120) ack 230 win 5808 <nop,nop,timestamp 4294780932 0>
15:04:51.042350 IP (tos 0x0, ttl  54, id 4580, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.41.228.1027: . [tcp sum ok] 230:230(0) ack 432 win 17520
15:04:52.497728 IP (tos 0x0, ttl  20, id 4857, offset 0, flags [none], length: 92) 206.123.31.115 > 80.144.41.228: fe80::2a0:a5ff:fe4b:5ef > ff02::1:ff00:23a4: HBH (padn)(rtalert: 0x0000) icmp6: multicast listener report[hlim 1] (len 32)
15:04:52.497916 IP (tos 0xc0, ttl 255, id 20027, offset 0, flags [none], length: 120) 80.144.41.228 > 206.123.31.115: icmp 100: 80.144.41.228 protocol 41 port 0 unreachable for IP (tos 0x0, ttl  20, id 4857, offset 0, flags [none], length: 92) 206.123.31.115 > 80.144.41.228: [|ip6]
15:04:53.613692 IP (tos 0x0, ttl  54, id 5043, offset 0, flags [none], length: 552) 206.123.31.115.3653 > 80.144.41.228.1027: . 230:742(512) ack 432 win 17520
15:04:53.654199 IP (tos 0x0, ttl  64, id 52917, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: . [tcp sum ok] 432:432(0) ack 742 win 6432 <nop,nop,timestamp 4294783925 0>
15:04:53.827195 IP (tos 0x0, ttl  54, id 5102, offset 0, flags [none], length: 86) 206.123.31.115.3653 > 80.144.41.228.1027: FP 742:788(46) ack 432 win 17520
15:04:53.827743 IP (tos 0x0, ttl  64, id 52918, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: F [tcp sum ok] 432:432(0) ack 789 win 6432 <nop,nop,timestamp 4294784098 0>
15:04:53.827883 IP (tos 0x0, ttl  64, id 52919, offset 0, flags [DF], length: 52) 80.144.41.228.1027 > 206.123.31.115.3653: R [tcp sum ok] 433:433(0) ack 789 win 6432 <nop,nop,timestamp 4294784098 0>
15:04:54.012200 IP (tos 0x0, ttl  54, id 5138, offset 0, flags [none], length: 40) 206.123.31.115.3653 > 80.144.41.228.1027: . [tcp sum ok] 789:789(0) ack 433 win 17520
15:04:54.012343 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], length: 40) 80.144.41.228.1027 > 206.123.31.115.3653: R [tcp sum ok] 1954213547:1954213547(0) win 0
15:05:00.815925 IP (tos 0x0, ttl  20, id 6489, offset 0, flags [none], length: 92) 206.123.31.115 > 80.144.41.228: fe80::2a0:a5ff:fe4b:5ef > ff02::1:ff00:23a4: HBH (padn)(rtalert: 0x0000) icmp6: multicast listener report[hlim 1] (len 32)
15:05:00.816111 IP (tos 0xc0, ttl 255, id 20028, offset 0, flags [none], length: 120) 80.144.41.228 > 206.123.31.115: icmp 100: 80.144.41.228 protocol 41 port 0 unreachable for IP (tos 0x0, ttl  20, id 6489, offset 0, flags [none], length: 92) 206.123.31.115 > 80.144.41.228: [|ip6]

--Boundary-00=_KELKBWxCBL9mZHw--
