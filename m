From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: NAT & FORWARDING
Date: Fri, 30 Jan 2004 00:35:40 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1075440940.1868.30.camel@jasiiitosh.nexusmgmt.com>
References: <003601c3e673$78521a60$3d40000a@wisdom>
	 <1075422511.1868.18.camel@jasiiitosh.nexusmgmt.com>
	 <200401301020.53669.sshebbar@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Srinivasa Hebbar <sshebbar@yahoo.com>
In-Reply-To: <200401301020.53669.sshebbar@yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Strange, I just took a quick look at the iptables man page and didn't
see it but I thought there was a RETURN target.  You may want to look
into that.  As I recall, you would just create a rule that if the packet
matched -i eth0 -j RETURN and it would not continue traversing the
current chain.  You would also add the same type rule for -i xpeth0.

On Thu, 2004-01-29 at 23:50, Srinivasa Hebbar wrote:
> Dear John,
> 
> Your solution works fine for me.
> Actually, I want to know how I can build a NAT rule 
> which will have "and" condition.
> 
> My box has atleast 50 interfaces and I want to do NAT on
> all interfaces except "eth0" and "xpeth0"
> 
> So I want some thing like, 
> 
> iptables -t nat -A PREROUTING  -i ! (eth0 && xpeth0)  -p tcp --dport 3021 -j 
> ACCEPT
> 
> But, the iptables doesn't take the above syntax.
> 
> Could you give me some hint how to solve the above probelm.
> One solution is to add the rule for all other 48 interfaces
> to accept the connection on port 3021. I can't use wildcards because each 
> interface name is different.
> 
> Regards,
> S. Hebbar.
> 
> 
> > On Thu, 2004-01-29 at 09:23, Srinivasa Hebbar wrote:
> > > Hello,
> > >
> > > I believe that the NAT PREROUTING and POSTROUTING will
> > > always takes place for all the incoming/outgoing packets
> > > irrespective of whether the packet is destined to the node or not.
> > >
> > > I have a situation that if the dest. IP address of the packet is
> > > for the local node, then apply NAT rule, otherwise it should simply
> > > forward the packet according to the routing table.
> > >
> > > How can I achieve the above?
> > >
> > > Any help is very much appreciated.
> > >
> > > Regards,
> > > S. Hebbar.
> >
> > Could you give a little more information, please.  That would help us
> > understand why you would want to NAT a packet destined for the local
> > node itself and why one would not simply NAT only if the destination
> > address matched the local node.  Thanks - John
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
