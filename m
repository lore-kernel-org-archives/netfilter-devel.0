From: "Paul Rolland" <rol@as2917.net>
Subject: Netfilter and IPPROTO_RAW
Date: Tue, 19 Nov 2002 20:02:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <00ba01c28ffe$3bc9a0d0$6a00a8c0@witbe>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <rol@as2917.net>
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

Hello,

I hope my question is not completely stupid....

I've read most of the documentation I can find related to Netfilter
in Kernel 2.4, and thru that, I now have a quite good idea of how to
use it...

My question is : at which place in the kernel does the Netfilter
code interact ?

I've a machine with more than one interface, and different default
routes.
To manage this, I have installed some rules :

/sbin/ip rule add from "IP.int.1" table eth1
/sbin/ip route add default via "IP.gw.1" dev eth1 table eth1

/sbin/ip rule add from "IP.int.2" table eth2
/sbin/ip route add default via "IP.gw.2" dev eth2 table eth2

This is supposed to route packets based on the source IP of the
packet, and throw it directly to the correct interface.

My problem is that one of the program we are using is sending
its packets to a socket that has been created by :
theSocket = socket(PF_INET, SOCK_RAW, IPPROTO_RAW);
and it seems from all the tests I've conducted that these packets
are bypassing all the rules aboved mentionned...

Is there a way to interact on packets sent to such a socket ?

Thanks for your help,
Regards,

Paul Rolland, rol@as2917.net
