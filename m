From: "pankaj jain" <jainp1979@gmail.com>
Subject: problem in adding a gateway
Date: Mon, 18 Jun 2007 17:55:43 +0530
Message-ID: <d41814cf0706180525s41d0c2aej9c825a4086ed73b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

HI,
I was using iptables and arptables for SNAT/DNAT and responding arp-requests,
I did not assign the ip on any of my interfaces
Now I want to add a gateway from the same subnet, for example:
I am sending arp responses for 203.200.192.24 (sorry if some one has
this IP) using arp tables.
Now I want to add a gateway e.g. 203.200.192.1 in the route table
I am using command-
"ip route add default via  203.200.192.1 dev eth0 table 10"
but when I try this it says
RTNETLINK answers: Network is unreachable

is it because any of the interfaces does not belong to the subnet?
please suggest some solution.

-- 
Thanks
Pankaj Jain
