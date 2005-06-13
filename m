From: Martin Bangiev <martin.bangiev@borsabg.com>
Subject: DNAT & SNAT delay
Date: Mon, 13 Jun 2005 15:11:54 +0300
Message-ID: <42AD780A.2030601@borsabg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hi guys,
I have two applications based in different networks that has to 
communicate with each other using many small UDP packets. Due to 
security reasons I set the firewall for SNAT and DNAT dynamically. Here 
is the exact situation.

Client1:
IP - 10.0.0.2
Client2:
IP - 172.16.0.2
Firewall:
IP1 - 10.0.0.1
IP2 - 172.16.0.1

Client1 sends it's datagrams to the Firewall:IP1
Client2 sends it's datagrams to the Firewall:IP2

Just before the communication starts I add rules to DNAT udp packets 
from Client1 to Client2, and to SNAT packets to Client2 to be from 
Firewall:IP2. I do it for the Client2 respective (of course I set up the 
ports too).
The problem is that the NAT starts with about 30 seconds delay. tcpdump 
shows the packets are coming from Client1 but they are not SNATed & 
DNATed. The counters of the rules however counts the packets. Once the 
packets begin to be NATed the counters stops.
Can you please tell me where this delay can be coming from?
Thanks in advance:)
