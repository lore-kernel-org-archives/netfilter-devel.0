From: Olivier GRALL <olivier.grall@neotip.com>
Subject: SNAT/Masquerade binding ports generate conflicts
Date: Thu, 08 Dec 2005 15:50:20 +0100
Message-ID: <4398482C.3040102@neotip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi,

I have a problem using iptables as a NAT box. I'm testing a p2p VoIP 
system trying to establish UDP channels using something like STUN.


-------      snat              ------------               -----
|  A  |-----| X |-----<-->-----| Server S |---<----->-----| B | 

-------(p1)       \(P1)        ------------         /(P2) -----
                    \                               /
                     \-----<----->-----<---->------/

X is iptables with a MASQUERADE (or SNAT) rule

1- A sends a packet to S from port p1
2- X opens port P1 (should be equal to p1)
3- S answers to A with a message containing UDP port of B
4- B knows port P1 of X thanks to S too
=> Sometimes A sends the first packets of the communication to B through 
X, then B can send packets to A too. Otherwise B sends the first packets 
and X seems to drop them (we can see icmp). Then A sends UDP packets to 
B and at this time iptables opens a new port 1024 for instance different 
from P1.
      It is like the uplet 
[(src=(@A,p1),dst=(@B,P2)),(src=(@X,P1),dst=(@B,P2))] wasn't  available 
anymore and so iptables changes P1 to P1'. Doing this, only one part of 
the uplet changes. I thought that conntrack forces the fact that for 
(@A,p1),(@B,P2) there is only a unique couple on the other side (= at 
the end of iptables treatments).

I used iptables 1.2.7a for that test. Anyone can tell me if  a recent 
version can solve this problem ?

Otherwise, is it possible to update the first conntrack record instead 
of creating a new one (with port P1') ?

Thanks.

Olivier GRALL.
