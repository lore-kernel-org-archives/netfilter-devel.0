From: "Samer Talat" <samer@loop.com.tw>
Subject: htb traffic control misfunction,help
Date: Thu, 25 Aug 2005 19:30:31 +0800
Message-ID: <001901c5a968$703bb020$0116010a@loop.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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



i am using linux 2.4.25 and the lastest version of iproute2, but i face =
the problem that the flow goes all to the default class, if you could =
help me, this will be great, if i use the command ping for the dst ip =
address, it will show a flow for 1:10, if you have any clue i am waiting =
for your help.

Thanks in advance

My code
-------------------------------------------------------------------------=
-----------------------

TC=3Dtc
Dev=3Deth0

$TC qdisc del dev $Dev root
$TC qdisc add dev $Dev root handle 1: htb default 20
$TC class add dev $Dev parent 1: classid 1:1 htb rate 10mbit ceil 10mbit
$TC class add dev $Dev parent 1:1 classid 1:10 htb rate 2mbit ceil 2mbit
$TC class add dev $Dev parent 1:1 classid 1:20 htb rate 2mbit ceil 2mbit
$TC class add dev $Dev parent 1:1 classid 1:30 htb rate 1mbit ceil 2mbit
$TC qdisc add dev $Dev parent 1:10 handle 10: pfifo limit 5
$TC qdisc add dev $Dev parent 1:20 handle 20: pfifo limit 5
$TC qdisc add dev $Dev parent 1:30 handle 30: sfq pfifo limit 5
$TC filter add dev $Dev protocol ip parent 1: prio 1 u32 match ip dst =
140.3.1.4 flowid 1:10
$TC filter add dev $Dev protocol ip parent 1: prio 1 u32 match ip dst =
140.3.1.3 flowid 1:20

$TC -s -d class show dev $Dev

Result
-------------------------------------------------------------------------=
-----------------------------------------------------

class htb 1:1 root rate 10000Kbit ceil 10000Kbit burst 14098b/8 mpu 0b =
overhead
0b cburst 14098b/8 mpu 0b overhead 0b level 7
 Sent 7553889 bytes 5020 pkts (dropped 0, overlimits 0)
 rate 1020Kbit 84pps
 lended: 0 borrowed: 0 giants: 0
 tokens: 3300 ctokens: 3300

class htb 1:10 parent 1:1 leaf 10: prio 0 quantum 25000 rate 2000Kbit =
ceil 2000K
bit burst 4Kb/8 mpu 0b overhead 0b cburst 4Kb/8 mpu 0b overhead 0b level =
0
 Sent 0 bytes 0 pkts (dropped 0, overlimits 0)
 lended: 0 borrowed: 0 giants: 0
 tokens: 13434 ctokens: 13434

class htb 1:20 parent 1:1 leaf 20: prio 0 quantum 25000 rate 2000Kbit =
ceil 2000K
bit burst 4Kb/8 mpu 0b overhead 0b cburst 4Kb/8 mpu 0b overhead 0b level =
0
 Sent 7700597 bytes 5120 pkts (dropped 344, overlimits 0)
 rate 1051Kbit 87pps backlog 3p
 lended: 5020 borrowed: 0 giants: 0
 tokens: -18006 ctokens: -18006

class htb 1:30 parent 1:1 prio 0 quantum 12500 rate 1000Kbit ceil =
2000Kbit burst
 2849b/8 mpu 0b overhead 0b cburst 4Kb/8 mpu 0b overhead 0b level 0
 Sent 0 bytes 0 pkts (dropped 0, overlimits 0)
 lended: 0 borrowed: 0 giants: 0
 tokens: 18677 ctokens: 13434
