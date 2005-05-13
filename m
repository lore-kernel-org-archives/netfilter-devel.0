From: cranium2003 <cranium2003@yahoo.com>
Subject: Re: Linux Routers working
Date: Thu, 12 May 2005 23:09:39 -0700 (PDT)
Message-ID: <20050513060939.18564.qmail@web41422.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: 6667
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


--- Jonas Berlin <xkr47@outerspace.dyndns.org> wrote:
> Quoting cranium2003 on 2005-05-13 04:15 UTC:
> >         Is there any way on linux routers to know
> on
> > which interface packet is forwarded before
> actually
> > packet trasmission begins?
> 
> In the FORWARD table you know both the incoming and
> outgoing interface:
> 
> This will match packets coming in from eth0 and
> going out on eth1:
> 
> iptables -A FORWARD -i eth0 -o eth1 ...
> 
   Can i get that information thru' C program
user/kernel mode netfilter program? Because you have
given the rule to forward packet but what if Router
have 3 or 4 NIC network interfaces? I want to print
somrthing like LOG that prints that packet has srcip
and dstip and is going through eth0/eth1/eth2/eth3.
 
> > Also before packet
> > processed by IP layer can it be possible to know
> from
> > which adjecent Router'IP packet came to that
> router?
> 
> No, but the MAC address is available. You just have
> to find out what the
> mac address of the router in question and do:
> 
> iptables -A INPUT -m mac --mac-source
> 01:23:45:67:89:AB ...
       No suppose i have no info about adjecent
routers mac addresses and when packet came at
destination Router at Link layer/IP layer can i
determine from which router the packet came to
destination router?
regards,
cranium


		
Discover Yahoo! 
Get on-the-go sports scores, stock quotes, news and more. Check it out! 
http://discover.yahoo.com/mobile.html
