From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: NAT & FORWARDING
Date: Thu, 29 Jan 2004 19:28:31 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1075422511.1868.18.camel@jasiiitosh.nexusmgmt.com>
References: <003601c3e673$78521a60$3d40000a@wisdom>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Srinivasa Hebbar <sshebbar@yahoo.com>
In-Reply-To: <003601c3e673$78521a60$3d40000a@wisdom>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-01-29 at 09:23, Srinivasa Hebbar wrote:
> Hello,
> 
> I believe that the NAT PREROUTING and POSTROUTING will 
> always takes place for all the incoming/outgoing packets
> irrespective of whether the packet is destined to the node or not.
> 
> I have a situation that if the dest. IP address of the packet is
> for the local node, then apply NAT rule, otherwise it should simply
> forward the packet according to the routing table.
> 
> How can I achieve the above?
> 
> Any help is very much appreciated.
> 
> Regards,
> S. Hebbar.

Could you give a little more information, please.  That would help us
understand why you would want to NAT a packet destined for the local
node itself and why one would not simply NAT only if the destination
address matched the local node.  Thanks - John
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
---
If you are interested in helping to develop a GPL enterprise class
VPN/Firewall/Security device management console, please visit
http://iscs.sourceforge.net 
