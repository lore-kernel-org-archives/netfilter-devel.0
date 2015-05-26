From: =?UTF-8?B?Tml5YXppIFPEsXJ0?= <nyzsirt@gmail.com>
Subject: SynProxy can not return syn ack packets with asymmetric dual bridge
	topology
Date: Tue, 26 May 2015 09:53:47 +0300
Message-ID: <5564187B.3010805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vker.kernel.org,
	"kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Return-path: <kernelnewbies-bounces@kernelnewbies.org>
List-Unsubscribe: <http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=unsubscribe>
List-Archive: <http://lists.kernelnewbies.org/pipermail/kernelnewbies>
List-Post: <mailto:kernelnewbies@kernelnewbies.org>
List-Help: <mailto:kernelnewbies-request@kernelnewbies.org?subject=help>
List-Subscribe: <http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=subscribe>
Sender: kernelnewbies-bounces@kernelnewbies.org
Errors-To: kernelnewbies-bounces@kernelnewbies.org
List-Id: netfilter-devel.vger.kernel.org

Hello all,

I have a asymmetric dual bridge topology as shown below
when i connect from 172.16.11.5 and 172.16.10.6 with ssh
but i can not connect because of SynProxy.

                       -------
                       |     |
                       ---o--- 172.16.11.5
                          |
                          |
                     -----o----- 172.16.11.6
                     |         |
                     |         | default gw 1.1.1.1
                     |         |
          1.1.1.2/30 --o----o--- 2.2.2.2/30
                       |    |
                       |    |
                       |    | (enp10s0f0)
                   ----o----o-----
                   |             |
                   |     XXX     |
                   |             |
                   |  br1   br0  | synproxy
                   |             |
                   ----o----o-----
                       |    |
                       |    |
                       |    |
          1.1.1.1/30 --o----o--- 2.2.2.1/30
                     |         |
                     |         | default gw 2.2.2.2
                     |         |
                     -----o----- 172.16.10.1
                          |
                          |
                       ---o--- 172.16.10.6
                       |     |
                       -------

On all machines between 172.16.11.5 and 172.16.10.6
"rp filtering" is off and "ip forwarding" is on.
There is a machine at the middle of topology which is
called "XXX" machine. XXX has two bridges and a SynProxy.


When SynProxy is turned OFF on XXX, I can ping from
172.16.11.5 to 172.16.10.6 and icmp packets follow
this path: br1->172.16.10.1->172.16.10.6->172.16.10.1->br0.
In addition, I can access from 172.16.11.5 to
172.16.10.6 with ssh. So the TCP traffic works as I expect.


However, when SynProxy is turned ON on XXX, I can ping
from 172.16.11.5 to 172.16.10.6 and icmp packets follow
the same path. But I can not access from 172.16.11.5
to 172.16.10.6 using ssh. This is because synproxy can
not send syn ack replies through br1 iface. If I add a
route for synack packets on XXX, i can connect from
172.16.11.5 to 172.16.10.6 with ssh.

route add 172.16.11.5 dev enp10s0f0


But this is not acceptable because 172.16.11.0 network
is cloud. So i could not add route all cloud network
to route table and could not add mac address to arp
table.

How can I connect from 172.16.11.5 to the 172.16.10.6
machine using ssh when SynProxy is turned ON on XXX?
oris It possible?

Thanks in advance,

Niyazi
