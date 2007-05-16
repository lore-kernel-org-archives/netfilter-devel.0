From: "Sarbeswar Mohapatra" <Sarbeswar.Mohapatra@nethawkgroup.com>
Subject: MAC address update
Date: Wed, 16 May 2007 16:18:06 -0500
Message-ID: <00d401c797ff$b2f60230$9f0201c0@nethawk.fi>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
I am using netfilter hook (NF_POST_ROUTING) to create IP tunnel. In the nf
hook function, the skb is expanded and added a new IP header (IP tunnel).
When I see the packet in ethereal it does not update the MAC address
according to the new IP header, rather the MAC address is the one for the
original ip header (I am talking about the destination only, the source MAC
header is the same as both src ip addresses belong to the local machine).
Also for testing purpose, I tried to modify the destination ip address
instead of adding a new IP header, it still has the old MAC address. What I
understood was after the hook the skb should go to ip_finish_output2 and it
should call use the ARP module to update the MAC address. Please send me
your suggestion, if I am missing anything.

Regards,
Sarbeswar
 
Sarbeswar Mohapatra
NetHawk Corp
3400 Waterview Pkwy
Suite 100
Richardson, TX - 75080
 
Email: Sarbeswar.Mohapatra@nethawkgroup.com
Tel:   +1 972 761 9271 Ext. 299
CELL:  +1 214 682 5645
FAX:   +1 972 761 9067 
