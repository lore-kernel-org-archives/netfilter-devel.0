From: "Srinivasa Hebbar" <sshebbar@yahoo.com>
Subject: NAT & FORWARDING
Date: Thu, 29 Jan 2004 19:53:10 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003601c3e673$78521a60$3d40000a@wisdom>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

Hello,

I believe that the NAT PREROUTING and POSTROUTING will 
always takes place for all the incoming/outgoing packets
irrespective of whether the packet is destined to the node or not.

I have a situation that if the dest. IP address of the packet is
for the local node, then apply NAT rule, otherwise it should simply
forward the packet according to the routing table.

How can I achieve the above?

Any help is very much appreciated.

Regards,
S. Hebbar.
