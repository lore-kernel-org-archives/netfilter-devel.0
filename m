From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: FW: RE: ftp nat doesn't work for ipsec tunnel outgoinging packets
Date: Wed, 26 Oct 2005 17:47:58 +0200
Message-ID: <BAY103-F3780D8AF44F224049FEAB9B2690@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello. I was browsing the devel archive and I have taken a look
about this messge:
https://lists.netfilter.org/pipermail/netfilter-devel/2005-October/021821.html

Could anyone tell me if this problem is related?


>From: "Marco Berizzi" <pupilla@hotmail.com>
>To: netfilter@lists.netfilter.org
>Subject: RE: ftp nat doesn't work for ipsec tunnel outgoinging packets
>Date: Wed, 26 Oct 2005 10:29:01 +0200
>
>Here is a ftp tcpdump trace between 172.22.1.14 (ftp client) and 
>172.16.1.25
>(ftp server) without nat. It is working:
>
>09:28:49.669821 IP 172.22.1.14.3678 > 172.16.1.25.21: S 
>586313385:586313385(0) win 8192 <mss 1460>
>09:28:49.669976 IP 172.16.1.25.21 > 172.22.1.14.3678: S 
>3113475971:3113475971(0) ack 586313386 win 65535 <mss 1460>
>09:28:49.699793 IP 172.22.1.14.3678 > 172.16.1.25.21: . ack 1 win 8760
>09:28:49.700165 IP 172.16.1.25.21 > 172.22.1.14.3678: P 1:50(49) ack 1 win 
>65535
>09:28:49.834164 IP 172.22.1.14.3678 > 172.16.1.25.21: . ack 50 win 8711
>09:28:51.430985 IP 172.22.1.14.3678 > 172.16.1.25.21: P 1:17(16) ack 50 win 
>8711
>09:28:51.431398 IP 172.16.1.25.21 > 172.22.1.14.3678: P 50:122(72) ack 17 
>win 65519
>09:28:51.642721 IP 172.22.1.14.3678 > 172.16.1.25.21: . ack 122 win 8639
>09:28:53.026576 IP 172.22.1.14.3678 > 172.16.1.25.21: P 17:24(7) ack 122 
>win 8639
>09:28:53.062425 IP 172.16.1.25.21 > 172.22.1.14.3678: P 122:153(31) ack 24 
>win 65512
>09:28:53.244467 IP 172.22.1.14.3678 > 172.16.1.25.21: . ack 153 win 8608
>
>*****here I issue an ls command*****
>
>09:29:02.303606 IP 172.22.1.14.3678 > 172.16.1.25.21: P 24:48(24) ack 153 
>win 8608
>09:29:02.303993 IP 172.16.1.25.21 > 172.22.1.14.3678: P 153:183(30) ack 48 
>win 65488
>09:29:02.332793 IP 172.22.1.14.3678 > 172.16.1.25.21: P 48:57(9) ack 183 
>win 8578
>09:29:02.333069 IP 172.16.1.25.21 > 172.22.1.14.3678: P 183:236(53) ack 57 
>win 65479
>09:29:02.333596 IP 172.16.1.25.20 > 172.22.1.14.3679: S 
>3116415472:3116415472(0) win 65535 <mss 1460,nop,nop,sackOK>
>09:29:02.362748 IP 172.22.1.14.3679 > 172.16.1.25.20: S 
>589509170:589509170(0) ack 3116415473 win 8760 <mss 1460>
>09:29:02.362869 IP 172.16.1.25.20 > 172.22.1.14.3679: . ack 1 win 65535
>09:29:02.366752 IP 172.16.1.25.20 > 172.22.1.14.3679: . 1:1405(1404) ack 1 
>win 65535
>09:29:02.366871 IP 172.16.1.25.20 > 172.22.1.14.3679: . 1405:2809(1404) ack 
>1 win 65535
>09:29:02.410653 IP 172.22.1.14.3679 > 172.16.1.25.20: . ack 2809 win 8760
>09:29:02.410918 IP 172.16.1.25.20 > 172.22.1.14.3679: FP 2809:3445(636) ack 
>1 win 65535
>09:29:02.445843 IP 172.22.1.14.3679 > 172.16.1.25.20: . ack 3446 win 8124
>09:29:02.473782 IP 172.22.1.14.3678 > 172.16.1.25.21: . ack 236 win 8525
>09:29:02.473923 IP 172.16.1.25.21 > 172.22.1.14.3678: P 236:260(24) ack 57 
>win 65479
>09:29:02.487792 IP 172.22.1.14.3679 > 172.16.1.25.20: F 1:1(0) ack 3446 win 
>8124
>09:29:02.487908 IP 172.16.1.25.20 > 172.22.1.14.3679: . ack 2 win 65535
>09:29:02.674414 IP 172.22.1.14.3678 > 172.16.1.25.21: . ack 260 win 8501
>09:29:05.149337 IP 172.22.1.14.3678 > 172.16.1.25.21: P 57:63(6) ack 260 
>win 8501
>09:29:05.149706 IP 172.16.1.25.21 > 172.22.1.14.3678: P 260:267(7) ack 63 
>win 65473
>09:29:05.149886 IP 172.16.1.25.21 > 172.22.1.14.3678: F 267:267(0) ack 63 
>win 65473
>09:29:05.181120 IP 172.22.1.14.3678 > 172.16.1.25.21: . ack 268 win 8494
>09:29:05.181697 IP 172.22.1.14.3678 > 172.16.1.25.21: F 63:63(0) ack 268 
>win 8494
>09:29:05.182321 IP 172.16.1.25.21 > 172.22.1.14.3678: . ack 64 win 65473
>
>This is a ftp tcpdump trace between 172.22.1.14 (ftp client) and 
>172.16.1.25
>(ftp server) with nat. Linux box with 2.6.14rc5 is (should?) natting all 
>packets
>from 172.22.1.14 to 172.16.1.1
>It is not working as you can see:
>
>09:28:10.010228 IP 172.16.1.1.3676 > 172.16.1.25.21: S 
>576382064:576382064(0) win 8192 <mss 1460>
>09:28:10.010368 IP 172.16.1.25.21 > 172.16.1.1.3676: S 
>3104343236:3104343236(0) ack 576382065 win 65535 <mss 1460>
>09:28:10.037069 IP 172.16.1.1.3676 > 172.16.1.25.21: . ack 1 win 8760
>09:28:10.037467 IP 172.16.1.25.21 > 172.16.1.1.3676: P 1:50(49) ack 1 win 
>65535
>09:28:10.207573 IP 172.16.1.1.3676 > 172.16.1.25.21: . ack 50 win 8711
>09:28:11.774173 IP 172.16.1.1.3676 > 172.16.1.25.21: P 1:17(16) ack 50 win 
>8711
>09:28:11.774593 IP 172.16.1.25.21 > 172.16.1.1.3676: P 50:122(72) ack 17 
>win 65519
>09:28:11.913619 IP 172.16.1.1.3676 > 172.16.1.25.21: . ack 122 win 8639
>09:28:12.557657 IP 172.16.1.1.3676 > 172.16.1.25.21: P 17:24(7) ack 122 win 
>8639
>09:28:12.592606 IP 172.16.1.25.21 > 172.16.1.1.3676: P 122:153(31) ack 24 
>win 65512
>09:28:12.817730 IP 172.16.1.1.3676 > 172.16.1.25.21: . ack 153 win 8608
>
>***here I issue an ls command***
>
>09:28:20.163987 IP 172.16.1.1.3676 > 172.16.1.25.21: P 24:47(23) ack 153 
>win 8608
>09:28:20.164392 IP 172.16.1.25.21 > 172.16.1.1.3676: P 153:183(30) ack 47 
>win 65489
>09:28:21.936329 IP 172.16.1.25.21 > 172.16.1.1.3676: P 153:183(30) ack 47 
>win 65489
>09:28:22.046174 IP 172.16.1.1.3676 > 172.16.1.25.21: P 24:47(23) ack 153 
>win 8608
>09:28:22.046309 IP 172.16.1.25.21 > 172.16.1.1.3676: . ack 47 win 65489
>09:28:25.655195 IP 172.16.1.25.21 > 172.16.1.1.3676: P 153:183(30) ack 47 
>win 65489
>09:28:25.655295 IP 172.16.1.1.3676 > 172.16.1.25.21: R 
>576382111:576382111(0) win 0
>
>***Again, what is the following packet? Why the source ip address isn't 
>changed?***
>09:28:25.857742 IP 172.22.1.14.3676 > 172.16.1.25.21: P 
>576382111:576382112(1) ack 3104343389 win 8608
>
>09:28:25.857898 IP 172.16.1.25.21 > 172.22.1.14.3676: R 
>3104343389:3104343389(0) win 0
>
>I have opened a bug at: 
>https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=392
>Any feedback are welcome.
>
>Marco Berizzi wrote:
>
>>Hello. I have a very strange problem with ftp.
>>Here is my network schema:
>>
>>ftp client (windows nt4) 172.22.1.14
>>|
>>|
>>|172.22.1.254 (network 172.22.1.0/24)
>>linux box FreeS/WAN IPsec
>>| public ip
>>|
>>|
>>internet
>>|
>>|
>>| public ip
>>linux box kernel 2.6.14rc5 26sec IPsec
>>| 172.16.1.1 (network 172.16.0.0/23)
>>|
>>|
>>|
>>ftp server (windows 2000 server) 172.16.1.25
>>
>>
>>The two networks 172.22.1.0/24 and 172.16.0.0/23
>>are connected with an ipsec tunnel implemented by
>>FreeS/WAN (KLIPS) on the 172.22.1.254 box and by
>>Openswan (26sec) on the 172.16.1.1 box.
>>
>>Here is the "iptables -t nat -L -n" output on the
>>linux 2.6.14rc5 box (172.16.1.1):
>>
>>Chain POSTROUTING (policy ACCEPT)
>>target     prot opt source               destination
>>SNAT       all  --  172.22.1.14          172.16.1.25         to:172.16.1.1
>>
>>
>>I'm natting all packets from 172.22.1.14 to 172.16.1.25
>>with 172.16.1.1 (don't ask me why). Running ls on the
>>ftp client I get errors like: connections closed from host,
>>sometimes it works, command not understood.
>>
>>This is a tcpdump capture on the 172.16.1.1 box:
>>
>>12:21:47.709908 IP 172.16.1.1.2976 > 172.16.1.25.21: P 
>>2885906235:2885906259(24) ack 2893999520 win 8608
>>12:21:47.710303 IP 172.16.1.25.21 > 172.16.1.1.2976: P 1:31(30) ack 24 win 
>>65488
>>12:21:49.603650 IP 172.22.1.14.2976 > 172.16.1.25.21: P 
>>2885906235:2885906260(25) ack 2893999520 win 8608
>>                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>>What is this packet? Why the source ip address is not changed?
>>
>>12:21:49.603811 IP 172.16.1.25.21 > 172.22.1.14.2976: R 
>>2893999520:2893999520(0) win 0
>>12:21:49.651794 IP 172.16.1.25.21 > 172.16.1.1.2976: P 1:31(30) ack 24 win 
>>65488
>>12:21:49.651907 IP 172.16.1.1.2976 > 172.16.1.25.21: R 
>>2885906259:2885906259(0) win 0
>>
>>Ftp nat & conntrack modules are loaded.
>>
>>PS: The same system with linux 2.4.31 and SWAN KLIPS is working.
>
>
>
