From: Roberto Nibali <ratz@tac.ch>
Subject: Re: strange INVALID SYN in ip_conntrack (tcp window tracking
 enabled) in 2.4.27 kernel
Date: Fri, 17 Dec 2004 13:01:13 +0100
Message-ID: <41C2CA89.2040007@tac.ch>
References: <41C2BDF7.6080509@tac.ch>
	<Pine.LNX.4.58.0412171215330.26459@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: chris@tac.ch
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.58.0412171215330.26459@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

>>I just wanted to know if this is a known feature of the conntrack code. When I
>>issue a local redirect ssh command, I get an ACCEPT followed by an INVALID on
>>the SYN packet but the connection still works (kernel 2.4.27).
>>
>># /foobar/bin/sshc www@172.23.139.11 -o BatchMode=yes -2 -q -f -N -p 2345 -R
>>1513:127.0.0.1:1514
>>
>># tail -f /var/log/kernlog
>>Dec 17 11:18:41 s_int@foobar tfx3: fw-tcp2fw [110] a:ACCEPT s:NEW
>>f:INPUT IN=eth0 OUT= SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1059
>>DPT=2345 SYN
>>Dec 17 11:18:41 s_int@foobar ip_conntrack_tcp: INVALID: invalid SYN
>>(ignored) SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1059 DPT=2345
>>SYN OPT (020405B40402080A0085041F0000000001030300)
> Please dump the traffic and send the corresponding log lines. (It seems to
> be a retransmitted SYN, which is harmless.)

foobar:~# grep DPT=2345 /var/log/kernlog | tail -2
Dec 17 12:40:49 s_int@foobar tfx3: fw-tcp2fw [110] a:ACCEPT s:NEW
f:INPUT IN=eth0 OUT= SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1040
DPT=2345 SYN
Dec 17 12:40:49 s_int@foobar ip_conntrack_tcp: INVALID: invalid SYN
(ignored) SRC=172.23.139.20 DST=172.23.139.11 DF PROTO=TCP SPT=1040 DPT=2345
SYN OPT (020405B40402080A00007E750000000001030300)

foobar:~# tcpdump -nvi eth0 port 2345 and tcp #edited for ledgibility
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 68 bytes

12:40:49.907439 IP (tos 0x0, ttl  64, id 59607, offset 0, flags [DF], length:
60) 172.23.139.20.1040 > 172.23.139.11.2345: S 1063163554:1063163554(0) win
5840 <mss 1460,sackOK,timestamp 32373[|tcp]>

#SYN 172.23.139.20.1040 > 172.23.139.11.2345

12:40:49.907583 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], length: 60)
172.23.139.11.2345 > 172.23.139.20.1040: S 1491192392:1491192392(0) ack
1063163555 win 5792 <mss 1460,sackOK,timestamp 9210436[|tcp]>

#SYN/ACK 172.23.139.11.2345 > 172.23.139.20.1040

12:40:49.907443 IP (tos 0x0, ttl  64, id 59607, offset 0, flags [DF], length:
60) 172.23.139.20.1040 > 172.23.139.11.2345: S 1063163554:1063163554(0) win
5840 <mss 1460,sackOK,timestamp 32373[|tcp]>

#SYN 172.23.139.20.1040 > 172.23.139.11.2345

12:40:49.907748 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], length: 60)
172.23.139.11.2345 > 172.23.139.20.1040: S 1491192392:1491192392(0) ack
1063163555 win 5792 <mss 1460,sackOK,timestamp 9210436[|tcp]>

#SYN/ACK 172.23.139.11.2345 > 172.23.139.20.1040

12:40:49.908559 IP (tos 0x0, ttl  64, id 59608, offset 0, flags [DF], length:
52) 172.23.139.20.1040 > 172.23.139.11.2345: . [tcp sum ok] ack 1 win 5840
<nop,nop,timestamp 32373 9210436>

#ACK 172.23.139.20.1040 > 172.23.139.11.2345

12:40:49.908562 IP (tos 0x0, ttl  64, id 59608, offset 0, flags [DF], length:
52) 172.23.139.20.1040 > 172.23.139.11.2345: . [tcp sum ok] ack 1 win 5840
<nop,nop,timestamp 32373 9210436>

#ACK 172.23.139.20.1040 > 172.23.139.11.2345

[repeat ad nauseum]

foobar:~# ping 172.23.139.11
PING 172.23.139.11 (172.23.139.11): 56 data bytes
64 bytes from 172.23.139.11: icmp_seq=0 ttl=64 time=0.963 ms
64 bytes from 172.23.139.11: icmp_seq=0 ttl=64 time=1.343 ms (DUP!)
64 bytes from 172.23.139.11: icmp_seq=0 ttl=64 time=1.609 ms (DUP!)
64 bytes from 172.23.139.11: icmp_seq=0 ttl=64 time=1.704 ms (DUP!)
--- 172.23.139.11 ping statistics ---
1 packets transmitted, 1 packets received, +3 duplicates, 0% packet loss
round-trip min/avg/max = 0.963/1.404/1.704 ms
taclog-central:~#

D'oh, I feel kind of stupid now. I should have looked closer at the tcpdump 
output. Thanks for helping me engaging my brain. We set up a cluster on VMWare 
GSX and configure multiple secondary IP addresses on the same virtual bridge.

> That path covers multiple cases and the comment refers to ignored SYN/ACK
> packets :-) .

True.

> You can't be in sNO state: if the assumption is valid (i.e. that's a
> resent SYN) then the connection is in sSR or above.

Of course it's in sSR, I was just being mentally slow. Unfortunately I've got to 
debug on so many things right now that my brain stack flushes every 10 minutes.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
