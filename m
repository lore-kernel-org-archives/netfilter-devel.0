From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: snatting ipsec decrypted packtes
Date: Tue, 06 Dec 2005 18:35:31 +0100
Message-ID: <BAY103-F107A205D64B97DB0CFBFD6B2400@phx.gbl>
References: <20051206145945.GH4038@rama.exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20051206145945.GH4038@rama.exocore.com>
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

[I know that this kind of issues (ipsec & NAT) will be addressed in 2.6.16]
This my network schema:

ftp client (windows nt4) 172.22.1.14
|
|
|172.22.1.254 (network 172.22.1.0/24)
linux box Openswan 2.4.4 IPsec
| public ip
|
|
internet
|
|
| public ip
linux box kernel 2.6.14 26sec IPsec + ipsec-01-output-hooks patch + nth 
patch
| 172.16.1.1 (network 172.16.0.0/23)
|
|
| 172.16.1.253
router (it's doing SNAT)
|
|
ftp server  10.180.71.9

The two networks 172.22.1.0/24 and 172.16.0.0/23 are connected with an ipsec 
tunnel implemented by Openswan 2.4.4 (KLIPS) on the 172.22.1.254 box and by 
Openswan 2.4.4 (NEYKEY) on the 172.16.1.1 box.
I'm snatting packets from 172.22.1.0/24 -->> 10.0.0.0/8 to 172.16.1.1 on the 
2.6.14 linux box. Then on the 172.16.1.1 box there is static route that 
forward all packets with DST ip 10.0.0.0/8 to 172.16.1.253
Today people complain that ftp isn't working anymore from the (for example) 
172.22.1.14 to the 10.180.71.9 host.
I have tried to download a pretty small file (194122 bytes) and ncftp on 
windows is downloading only 18980 bytes (both active and passive mode). 
After a while ncftp is telling me "connection reset...".

This is the tcpdump capture on the 2.6.14 box (tcpdump -n -p -i eth2 ip host 
10.180.71.9):

17:15:06.547724 IP (tos 0x10, ttl  54, id 24346, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42717 > 172.16.1.1.1334: . 
2739649786:2739651246(1460) ack 2282813263 win 65535
17:15:32.708428 IP (tos 0x10, ttl  54, id 25931, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42912 > 172.16.1.1.1360: . 
4260815896:4260817356(1460) ack 2346367135 win 65535
17:15:36.258178 IP (tos 0x0, ttl 126, id 43179, offset 0, flags [DF], proto: 
TCP (6), length: 59) 172.16.1.1.1321 > 10.180.71.9.21: P, cksum 0x3847 
(correct), 2243331842:2243331861(19) ack 2800541527 win 8760
17:15:36.264275 IP (tos 0x10, ttl  54, id 26011, offset 0, flags [none], 
proto: TCP (6), length: 52) 10.180.71.9.21 > 172.16.1.1.1321: P, cksum 
0x0eac (correct), 1:13(12) ack 19 win 65535
17:15:36.293443 IP (tos 0x0, ttl 126, id 43947, offset 0, flags [DF], proto: 
TCP (6), length: 59) 172.16.1.1.1321 > 10.180.71.9.21: P, cksum 0x4431 
(correct), 19:38(19) ack 13 win 8748
17:15:36.299554 IP (tos 0x10, ttl  54, id 26013, offset 0, flags [none], 
proto: TCP (6), length: 60) 10.180.71.9.21 > 172.16.1.1.1321: P, cksum 
0x49b3 (correct), 13:33(20) ack 38 win 65535
17:15:36.330105 IP (tos 0x0, ttl 126, id 44971, offset 0, flags [DF], proto: 
TCP (6), length: 46) 172.16.1.1.1321 > 10.180.71.9.21: P, cksum 0x45bd 
(correct), 38:44(6) ack 33 win 8728
17:15:36.336409 IP (tos 0x10, ttl  54, id 26014, offset 0, flags [none], 
proto: TCP (6), length: 88) 10.180.71.9.21 > 172.16.1.1.1321: P 33:81(48) 
ack 44 win 65535
17:15:36.375794 IP (tos 0x0, ttl 126, id 45483, offset 0, flags [DF], proto: 
TCP (6), length: 44) 172.16.1.1.1365 > 10.180.71.9.43049: S, cksum 0x0501 
(correct), 2395682829:2395682829(0) win 8192 <mss 1460>
17:15:36.387245 IP (tos 0x0, ttl  54, id 26015, offset 0, flags [none], 
proto: TCP (6), length: 44) 10.180.71.9.43049 > 172.16.1.1.1365: S, cksum 
0x8805 (correct), 29203245:29203245(0) ack 2395682830 win 65535 <mss 1460>
17:15:36.418587 IP (tos 0x0, ttl 126, id 45739, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x7d8a 
(correct), 1:1(0) ack 1 win 8760
17:15:36.420139 IP (tos 0x0, ttl 126, id 46507, offset 0, flags [DF], proto: 
TCP (6), length: 59) 172.16.1.1.1321 > 10.180.71.9.21: P, cksum 0x3f12 
(correct), 44:63(19) ack 81 win 8680
17:15:36.426501 IP (tos 0x10, ttl  54, id 26017, offset 0, flags [none], 
proto: TCP (6), length: 102) 10.180.71.9.21 > 172.16.1.1.1321: P 81:143(62) 
ack 63 win 65535
17:15:36.434135 IP (tos 0x10, ttl  54, id 26018, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
1:1461(1460) ack 1 win 65535
17:15:36.440041 IP (tos 0x10, ttl  54, id 26019, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
1461:2921(1460) ack 1 win 65535
17:15:36.440045 IP (tos 0x10, ttl  54, id 26021, offset 0, flags [none], 
proto: TCP (6), length: 64) 10.180.71.9.21 > 172.16.1.1.1321: P, cksum 
0x48e8 (correct), 143:167(24) ack 63 win 65535
17:15:36.446757 IP (tos 0x10, ttl  54, id 26020, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
2921:4381(1460) ack 1 win 65535
17:15:36.477041 IP (tos 0x0, ttl 126, id 47019, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x7222 
(correct), 1:1(0) ack 2921 win 8760
17:15:36.477967 IP (tos 0x0, ttl 126, id 47275, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1321 > 10.180.71.9.21: ., cksum 0xf651 
(correct), 63:63(0) ack 167 win 8594
17:15:36.483059 IP (tos 0x0, ttl 126, id 47531, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x6c6c 
(correct), 1:1(0) ack 4381 win 8760
17:15:36.489089 IP (tos 0x10, ttl  54, id 26024, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
4381:5841(1460) ack 1 win 65535
17:15:36.494991 IP (tos 0x10, ttl  54, id 26025, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
5841:7301(1460) ack 1 win 65535
17:15:36.501351 IP (tos 0x10, ttl  54, id 26026, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
7301:8761(1460) ack 1 win 65535
17:15:36.532281 IP (tos 0x0, ttl 126, id 48299, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x6106 
(correct), 1:1(0) ack 7301 win 8760
17:15:36.536893 IP (tos 0x0, ttl 126, id 48555, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x5b52 
(correct), 1:1(0) ack 8761 win 8760
17:15:36.544470 IP (tos 0x10, ttl  54, id 26027, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
8761:10221(1460) ack 1 win 65535
17:15:36.550374 IP (tos 0x10, ttl  54, id 26028, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
10221:11681(1460) ack 1 win 65535
17:15:36.556732 IP (tos 0x10, ttl  54, id 26029, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
11681:13141(1460) ack 1 win 65535
17:15:36.562634 IP (tos 0x10, ttl  54, id 26030, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
13141:14601(1460) ack 1 win 65535
17:15:36.568992 IP (tos 0x10, ttl  54, id 26031, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
14601:16061(1460) ack 1 win 65535
17:15:36.574897 IP (tos 0x10, ttl  54, id 26032, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
16061:17521(1460) ack 1 win 65535
17:15:36.583546 IP (tos 0x0, ttl 126, id 49067, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x4fea 
(correct), 1:1(0) ack 11681 win 8760
17:15:36.593221 IP (tos 0x0, ttl 126, id 49323, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x4a36 
(correct), 1:1(0) ack 13141 win 8760
17:15:36.605163 IP (tos 0x10, ttl  54, id 26033, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
17521:18981(1460) ack 1 win 65535
17:15:36.610376 IP (tos 0x0, ttl 126, id 49835, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x4482 
(correct), 1:1(0) ack 14601 win 8760
17:15:36.611068 IP (tos 0x10, ttl  54, id 26034, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:15:36.617424 IP (tos 0x10, ttl  54, id 26035, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
20441:21901(1460) ack 1 win 65535
17:15:36.623327 IP (tos 0x10, ttl  54, id 26036, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
21901:23361(1460) ack 1 win 65535
17:15:36.650645 IP (tos 0x0, ttl 126, id 50091, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x4482 
(correct), 1:1(0) ack 14601 win 8760
17:15:36.653481 IP (tos 0x0, ttl 126, id 50347, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x4482 
(correct), 1:1(0) ack 14601 win 8760
17:15:36.658056 IP (tos 0x0, ttl 126, id 50603, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x4482 
(correct), 1:1(0) ack 14601 win 8760
17:15:36.669872 IP (tos 0x10, ttl  54, id 26037, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
14601:16061(1460) ack 1 win 65535
17:15:36.700948 IP (tos 0x0, ttl 126, id 50859, offset 0, flags [DF], proto: 
TCP (6), length: 40) 172.16.1.1.1365 > 10.180.71.9.43049: ., cksum 0x3366 
(correct), 1:1(0) ack 18981 win 8760
17:15:36.712642 IP (tos 0x10, ttl  54, id 26038, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:15:36.718457 IP (tos 0x10, ttl  54, id 26039, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
23361:24821(1460) ack 1 win 65535
17:15:38.218459 IP (tos 0x10, ttl  54, id 26097, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:15:41.228486 IP (tos 0x10, ttl  54, id 26308, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:15:43.778858 IP (tos 0x10, ttl  54, id 26584, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42875 > 172.16.1.1.1358: . 
1915964949:1915966409(1460) ack 2340912482 win 65535
17:15:47.318707 IP (tos 0x10, ttl  54, id 26719, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42636 > 172.16.1.1.1331: . 
908333443:908334903(1460) ack 2264468519 win 65535
17:15:47.324525 IP (tos 0x10, ttl  54, id 26720, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:15:59.408971 IP (tos 0x10, ttl  54, id 27607, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:16:11.119084 IP (tos 0x10, ttl  54, id 28699, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42717 > 172.16.1.1.1334: . 
0:1460(1460) ack 1 win 65535
17:16:23.760621 IP (tos 0x10, ttl  54, id 29040, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:16:37.340060 IP (tos 0x10, ttl  54, id 29604, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42912 > 172.16.1.1.1360: . 
0:1460(1460) ack 1 win 65535
17:16:48.470893 IP (tos 0x10, ttl  54, id 30044, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42875 > 172.16.1.1.1358: . 
0:1460(1460) ack 1 win 65535
17:16:51.986240 IP (tos 0x10, ttl  54, id 30133, offset 0, flags [none], 
proto: TCP (6), length: 40) 10.180.71.9.42636 > 172.16.1.1.1331: R, cksum 
0x0df7 (correct), 7300:7300(0) ack 1 win 65535
17:17:12.110450 IP (tos 0x10, ttl  54, id 30851, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:17:15.614600 IP (tos 0x10, ttl  54, id 30949, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42717 > 172.16.1.1.1334: . 
0:1460(1460) ack 1 win 65535
17:17:41.706430 IP (tos 0x10, ttl  54, id 31501, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42912 > 172.16.1.1.1360: . 
0:1460(1460) ack 1 win 65535
17:17:52.808282 IP (tos 0x10, ttl  54, id 31741, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42875 > 172.16.1.1.1358: . 
0:1460(1460) ack 1 win 65535
17:18:16.442355 IP (tos 0x10, ttl  54, id 32776, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:18:19.938728 IP (tos 0x10, ttl  54, id 32894, offset 0, flags [none], 
proto: TCP (6), length: 40) 10.180.71.9.42717 > 172.16.1.1.1334: R, cksum 
0x0310 (correct), 8760:8760(0) ack 1 win 65535
17:18:46.093447 IP (tos 0x10, ttl  54, id 33460, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42912 > 172.16.1.1.1360: . 
0:1460(1460) ack 1 win 65535
17:18:57.154983 IP (tos 0x10, ttl  54, id 33645, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42875 > 172.16.1.1.1358: . 
0:1460(1460) ack 1 win 65535
17:19:20.781708 IP (tos 0x10, ttl  54, id 34382, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:19:50.509880 IP (tos 0x10, ttl  54, id 39421, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42912 > 172.16.1.1.1360: . 
0:1460(1460) ack 1 win 65535
17:20:01.609381 IP (tos 0x10, ttl  54, id 40574, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42875 > 172.16.1.1.1358: . 
0:1460(1460) ack 1 win 65535
17:20:25.296845 IP (tos 0x10, ttl  54, id 43700, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:20:55.016260 IP (tos 0x10, ttl  54, id 51231, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.42912 > 172.16.1.1.1360: . 
0:1460(1460) ack 1 win 65535
17:21:06.102182 IP (tos 0x10, ttl  54, id 52899, offset 0, flags [none], 
proto: TCP (6), length: 40) 10.180.71.9.42875 > 172.16.1.1.1358: R, cksum 
0x18ce (correct), 8760:8760(0) ack 1 win 65535
17:21:29.762998 IP (tos 0x10, ttl  54, id 57499, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:21:59.505606 IP (tos 0x10, ttl  54, id 61417, offset 0, flags [none], 
proto: TCP (6), length: 40) 10.180.71.9.42912 > 172.16.1.1.1360: R, cksum 
0xbb4f (correct), 8760:8760(0) ack 1 win 65535
17:22:34.296136 IP (tos 0x10, ttl  54, id 343, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:23:38.866224 IP (tos 0x10, ttl  54, id 4147, offset 0, flags [none], 
proto: TCP (6), length: 1500) 10.180.71.9.43049 > 172.16.1.1.1365: . 
18981:20441(1460) ack 1 win 65535
17:24:43.252005 IP (tos 0x10, ttl  54, id 7871, offset 0, flags [none], 
proto: TCP (6), length: 40) 10.180.71.9.43049 > 172.16.1.1.1365: R, cksum 
0x3eca (correct), 24821:24821(0) ack 1 win 65535

and this is the tcpdump capture on the KLIPS box (tcpdump -n -p -i ipsec0 ip 
host 10.180.71.9):

17:15:37.707048 IP (tos 0x0, ttl 127, id 43179, offset 0, flags [DF], 
length: 59) 172.22.1.14.1321 > 10.180.71.9.21: P [tcp sum ok] 
2243331842:2243331861(19) ack 2800541527 win 8760
17:15:37.743010 IP (tos 0x10, ttl  53, id 26011, offset 0, flags [none], 
length: 52) 10.180.71.9.21 > 172.22.1.14.1321: P [tcp sum ok] 1:13(12) ack 
19 win 65535
17:15:37.744227 IP (tos 0x0, ttl 127, id 43947, offset 0, flags [DF], 
length: 59) 172.22.1.14.1321 > 10.180.71.9.21: P [tcp sum ok] 19:38(19) ack 
13 win 8748
17:15:37.778629 IP (tos 0x10, ttl  53, id 26013, offset 0, flags [none], 
length: 60) 10.180.71.9.21 > 172.22.1.14.1321: P [tcp sum ok] 13:33(20) ack 
38 win 65535
17:15:37.780917 IP (tos 0x0, ttl 127, id 44971, offset 0, flags [DF], 
length: 46) 172.22.1.14.1321 > 10.180.71.9.21: P [tcp sum ok] 38:44(6) ack 
33 win 8728
17:15:37.814955 IP (tos 0x10, ttl  53, id 26014, offset 0, flags [none], 
length: 88) 10.180.71.9.21 > 172.22.1.14.1321: P 33:81(48) ack 44 win 65535
17:15:37.826280 IP (tos 0x0, ttl 127, id 45483, offset 0, flags [DF], 
length: 44) 172.22.1.14.1365 > 10.180.71.9.43049: S [tcp sum ok] 
2395682829:2395682829(0) win 8192 <mss 1460>
17:15:37.868829 IP (tos 0x0, ttl  53, id 26015, offset 0, flags [none], 
length: 44) 10.180.71.9.43049 > 172.22.1.14.1365: S [tcp sum ok] 
29203245:29203245(0) ack 2395682830 win 65535 <mss 1460>
17:15:37.869444 IP (tos 0x0, ttl 127, id 45739, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
1 win 8760
17:15:37.870240 IP (tos 0x0, ttl 127, id 46507, offset 0, flags [DF], 
length: 59) 172.22.1.14.1321 > 10.180.71.9.21: P [tcp sum ok] 44:63(19) ack 
81 win 8680
17:15:37.909652 IP (tos 0x10, ttl  53, id 26017, offset 0, flags [none], 
length: 102) 10.180.71.9.21 > 172.22.1.14.1321: P 81:143(62) ack 63 win 
65535
17:15:37.923158 IP (tos 0x10, ttl  53, id 26018, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 1:1389(1388) ack 1 win 
65535
17:15:37.923581 IP (tos 0x10, ttl  53, id 26018, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:37.926284 IP (tos 0x10, ttl  53, id 26019, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 1461:2849(1388) ack 1 
win 65535
17:15:37.926782 IP (tos 0x10, ttl  53, id 26019, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:37.927340 IP (tos 0x10, ttl  53, id 26021, offset 0, flags [none], 
length: 64) 10.180.71.9.21 > 172.22.1.14.1321: P [tcp sum ok] 143:167(24) 
ack 63 win 65535
17:15:37.928387 IP (tos 0x0, ttl 127, id 47019, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
2921 win 8760
17:15:37.928835 IP (tos 0x0, ttl 127, id 47275, offset 0, flags [DF], 
length: 40) 172.22.1.14.1321 > 10.180.71.9.21: . [tcp sum ok] 63:63(0) ack 
167 win 8594
17:15:37.932623 IP (tos 0x10, ttl  53, id 26020, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 2921:4309(1388) ack 1 
win 65535
17:15:37.933088 IP (tos 0x10, ttl  53, id 26020, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:37.934406 IP (tos 0x0, ttl 127, id 47531, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
4381 win 8760
17:15:37.973301 IP (tos 0x10, ttl  53, id 26024, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 4381:5769(1388) ack 1 
win 65535
17:15:37.973777 IP (tos 0x10, ttl  53, id 26024, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:37.982410 IP (tos 0x10, ttl  53, id 26025, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 5841:7229(1388) ack 1 
win 65535
17:15:37.982902 IP (tos 0x10, ttl  53, id 26025, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:37.984176 IP (tos 0x0, ttl 127, id 48299, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
7301 win 8760
17:15:37.986110 IP (tos 0x10, ttl  53, id 26026, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 7301:8689(1388) ack 1 
win 65535
17:15:37.986597 IP (tos 0x10, ttl  53, id 26026, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:37.987867 IP (tos 0x0, ttl 127, id 48555, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
8761 win 8760
17:15:38.028184 IP (tos 0x10, ttl  53, id 26027, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 8761:10149(1388) ack 1 
win 65535
17:15:38.028753 IP (tos 0x10, ttl  53, id 26027, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.033299 IP (tos 0x10, ttl  53, id 26028, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 10221:11609(1388) ack 
1 win 65535
17:15:38.033814 IP (tos 0x10, ttl  53, id 26028, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.035003 IP (tos 0x0, ttl 127, id 49067, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
11681 win 8760
17:15:38.041255 IP (tos 0x10, ttl  53, id 26029, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 11681:13069(1388) ack 
1 win 65535
17:15:38.041669 IP (tos 0x10, ttl  53, id 26029, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.042967 IP (tos 0x0, ttl 127, id 49323, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
13141 win 8760
17:15:38.045716 IP (tos 0x10, ttl  53, id 26030, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 13141:14529(1388) ack 
1 win 65535
17:15:38.046201 IP (tos 0x10, ttl  53, id 26030, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.053400 IP (tos 0x10, ttl  53, id 26031, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.059326 IP (tos 0x10, ttl  53, id 26032, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 16061:17449(1388) ack 
1 win 65535
17:15:38.059820 IP (tos 0x10, ttl  53, id 26032, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.061091 IP (tos 0x0, ttl 127, id 49835, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
14601 win 8760
17:15:38.087740 IP (tos 0x10, ttl  53, id 26033, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 17521:18909(1388) ack 
1 win 65535
17:15:38.088102 IP (tos 0x10, ttl  53, id 26033, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.089422 IP (tos 0x0, ttl 127, id 50091, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
14601 win 8760
17:15:38.096316 IP (tos 0x10, ttl  53, id 26034, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:15:38.102472 IP (tos 0x10, ttl  53, id 26035, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 20441:21829(1388) ack 
1 win 65535
17:15:38.102904 IP (tos 0x10, ttl  53, id 26035, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.104207 IP (tos 0x0, ttl 127, id 50347, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
14601 win 8760
17:15:38.107650 IP (tos 0x10, ttl  53, id 26036, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 21901:23289(1388) ack 
1 win 65535
17:15:38.108133 IP (tos 0x10, ttl  53, id 26036, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.109388 IP (tos 0x0, ttl 127, id 50603, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
14601 win 8760
17:15:38.151445 IP (tos 0x10, ttl  53, id 26037, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 14601:15989(1388) ack 
1 win 65535
17:15:38.151972 IP (tos 0x10, ttl  53, id 26037, offset 1408, flags [none], 
length: 92) 10.180.71.9 > 172.22.1.14: tcp
17:15:38.153030 IP (tos 0x0, ttl 127, id 50859, offset 0, flags [DF], 
length: 40) 172.22.1.14.1365 > 10.180.71.9.43049: . [tcp sum ok] 1:1(0) ack 
18981 win 8760
17:15:38.196509 IP (tos 0x10, ttl  53, id 26038, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:15:38.203432 IP (tos 0x10, ttl  53, id 26039, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 23361:24749(1388) ack 
1 win 65535
17:15:39.703129 IP (tos 0x10, ttl  53, id 26097, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:15:42.714740 IP (tos 0x10, ttl  53, id 26308, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:15:48.809293 IP (tos 0x10, ttl  53, id 26720, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:16:00.893634 IP (tos 0x10, ttl  53, id 27607, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:16:25.246332 IP (tos 0x10, ttl  53, id 29040, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:17:13.597427 IP (tos 0x10, ttl  53, id 30851, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:18:17.931314 IP (tos 0x10, ttl  53, id 32776, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:19:22.274858 IP (tos 0x10, ttl  53, id 34382, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:20:26.790019 IP (tos 0x10, ttl  53, id 43700, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:21:31.258485 IP (tos 0x10, ttl  53, id 57499, offset 0, flags [+], 
length: 1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 
1 win 65535
17:22:35.793613 IP (tos 0x10, ttl  53, id 343, offset 0, flags [+], length: 
1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 1 win 
65535
17:23:40.366337 IP (tos 0x10, ttl  53, id 4147, offset 0, flags [+], length: 
1428) 10.180.71.9.43049 > 172.22.1.14.1365: . 18981:20369(1388) ack 1 win 
65535
17:24:44.748067 IP (tos 0x10, ttl  53, id 7871, offset 0, flags [none], 
length: 40) 10.180.71.9.43049 > 172.22.1.14.1365: R [tcp sum ok] 
24821:24821(0) ack 1 win 65535

The 2.6.14 box has 36 days uptime. Shoud I reboot and see if the problem 
goes away?

TIA
