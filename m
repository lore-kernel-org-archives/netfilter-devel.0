From: "Javier Martin" <martin@trymedia.com>
Subject: Wrong count on bytes
Date: Fri, 18 Oct 2002 14:40:41 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003001c276ef$01c5b270$8432a8c0@mcpollo>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I'm getting confusing numbers from the iptables counters. The numbres
apparently show that the output bandwidth is >140 Mbit/sec on a 100
Mbit/sec.

I'm running:

- RH 7.3
- Kernel 2.4.18 (RH release is 2.4.18-10)
- iptables 1.2.5 (RH release 1.2.5-3).

This server is running an intel EEPRO100 nic with own intel's driver
(e100.o). The driver provides byte accounting at
/proc/net/PRO_LAN_Adapters/eth0.info, and this number differs BY FAR
from iptables. If I run the following script:

  cat /proc/net/PRO_LAN_Adapters/eth0.info |grep Tx_Bytes
  iptables -L -n -v -x |grep OUTPUT
  sleep 10
  cat /proc/net/PRO_LAN_Adapters/eth0.info |grep Tx_Bytes
  iptables -L -n -v -x |grep OUTPUT

This is the result:

  Tx_Bytes                  2501299733
  Chain OUTPUT (policy ACCEPT 410429507 packets, 581914465274 bytes)
  Tx_Bytes                  2626036933
  Chain OUTPUT (policy ACCEPT 410555345 packets, 582099636248 bytes)

Substract the numbers, then divide by 10 seconds and you will have the
speed rate:

  Intel's driver counter:   95,17 Mbit/sec
  iptables:                141,27 Mbit/sec!?!?

The driver's counter is correct as the server is truly under heavy
traffic load and the rate is peaking at the ethernet limit. But the
iptables number is way not coherent.

I'm using the following rules:

  iptables -I INPUT -i eth0 --destination x.x.x.x
  iptables -I OUTPUT -o eth0 --source x.x.x.x

And x.x.x.x is an address added to the eth0 device via the iproute's ip
command:

  ip address add x.x.x.x dev eth0

I also have some queue discipline filters for bandwidth shaping which I
don't really believe they have anything to do.

Please help!

Javier
