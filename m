From: "Emiel Mols" <emiel@fulgor-hosting.nl>
Subject: RE: IPSEC and NAT
Date: Sat, 16 Oct 2004 00:03:44 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <E1CIaAp-0006Vi-00@deer.gmane.org>
References: <1097877726.2771.47.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'John A. Sullivan III'" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1097877726.2771.47.camel@localhost>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Well, I only control one end of the link :). This one ip address is assigned
to me and I have to find a way to NAT it :(.

netfilter-devel@lists.netfilter.org
-----Original Message-----
From: John A. Sullivan III [mailto:john.sullivan@nexusmgmt.com] 
Sent: zaterdag 16 oktober 2004 0:02
To: Emiel Mols
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: IPSEC and NAT

On Fri, 2004-10-15 at 14:00, Emiel Mols wrote:
> Hi,
> 
>  
> 
> I've managed to setup a host-to-net ipsec connection with a remote network
> on a linux router using (ported) isakmpd and kernel 2.6.8.1. However, I
want
> to be able to 'share' this ipsec connection with the rest of the network,
> but since no ipsecn virtual interface is created in the 2.6 kernels I
can't
> use ordinary SNAT/MASQUERADE targets in iptables: ipsec packets get
> encrypted before entering the POSTROUTING table :(, so the source address
of
> the encapsulated packet can't be changed anymore. I've read
>
http://lists.netfilter.org/pipermail/netfilter-devel/2004-January/thread.htm
> l#13879, but the supplied patch doesn't work very well.
> 
>  
> 
> Does anyone have any suggestions on how to get this working?
<snip>
I may be a bit tired at the end of a long week and have thus missed your
point . . . but why not set it up as a net-to-net connection? - John
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
