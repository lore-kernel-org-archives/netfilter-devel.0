From: "Sarbeswar Mohapatra" <Sarbeswar.Mohapatra@nethawkgroup.com>
Subject: RE: MAC address update
Date: Mon, 21 May 2007 19:26:43 -0500
Message-ID: <004301c79c07$e0b2d930$6502a8c0@nethawk.fi>
References: <1179785387.12033.9.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "'Henrik Nordstrom'" <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <1179785387.12033.9.camel@henriknordstrom.net>
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

Hi Henrik,
Thanks for your response. I already figured that out before leaving the nf
hook function, I had to update the routing and got it working. 


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

-----Original Message-----
From: Henrik Nordstrom [mailto:henrik@henriknordstrom.net] 
Sent: Monday, May 21, 2007 5:10 PM
To: Sarbeswar Mohapatra
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: MAC address update

ons 2007-05-16 klockan 16:18 -0500 skrev Sarbeswar Mohapatra:
> Hi,
> I am using netfilter hook (NF_POST_ROUTING) to create IP tunnel. In 
> the nf hook function, the skb is expanded and added a new IP header (IP
tunnel).

Hmm.. shouldn't this be done before routing?

After routing the kernel has already decided which next-hop the packet
should be sent to. If you change this after the routing is done you need to
re-route the packet, the kernel won't notice otherwise.

Regards
Henrik
