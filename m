From: "dimitri borjac" <dimitri_borjac@hotmail.com>
Subject: RE: iptables and SPI...
Date: Fri, 31 Oct 2003 15:32:46 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Law10-F126ORH9HWP5R0002a333@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thx for trying to help me Harald :)

what i'm trying to do is to perform NAT based on IP_addresses/Ports/SPIs.

The situation would be different users NATted by a common local gateway (all 
the users are located on the same private network), making each one an IPsec 
tunnel (using ESP) to the same remote gateway.

The different tunnels start from each user, go through the local gateway 
(which NATts the users) and end at the remote gateway.

The problem for the local gateway is to NAT the different VPN, based on the 
private IP adresses of the users, the ports used (port 50 for ESP...) and 
the SPIs (in order to distinguish the different tunnels).

The problem is not for the chosen ipsec implementation since the local 
gateway only NATts and forwards the ispec packets. But with the current 
version of iptables, is it possible for the local gateway to perform NAT 
based on the SPIs (and @IP and ports...) ?  (i saw that extracting the SPI 
from the ESP header is possible thx to last p-o-m... but NAT with it ?)

I hope this explanation is more understandable :-/
Thx very much for your help !!

Regards,
dimo

_________________________________________________________________
Trouvez l'âme soeur sur MSN Rencontres http://g.msn.fr/FR1000/9551
