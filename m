From: chip@innovates.com
Subject: RE: conntrack NAT problem w/ UDP
Date: Wed, 28 Dec 2005 09:12:48 -0600
Message-ID: <38081.8443409682$1135782822@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: bof@bof.de
Content-Disposition: inline; filename="BDY.TXT"
	;Creation-Date="Wed, 28 Dec 2005 09:12:47 -0600"
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

The packet rewriting is not happening for the outgoing packets, 
therefore the other end can never reply because it has a private IP 
address being sent as the source address.  

The timeout issue has been thoroughly debunked by numerous people.  
Asterisk sends a packet every 30 seconds to keep NAT connections alive.  


The problem is definitely something getting lost in netfilter.  When the 
problem occurs, DNS and other UDP traffic with different source ports 
than destination ports are still correctly rewritten.  The last time the 
problem occurred for me, I completely reload the all the tables and 
tried using SNAT vs. MASQUERADE.  Nothing made any packets get rewritten 
for Asterisk connections except rebooting the router.  Next time, I will 
try unloading all the netfilter modules and reloading them before 
rebooting.  

When this happens I don't have much time for debugging, because of the 
urgency to get a production phone system back in service.  That is why 
I'm asking what should I examine to find out where netfilter is missing 
this connection?

Chip Schweiss



-----Original Message-----
From: bof [mailto:bof@bof.de] 
Sent: Wednesday, December 28, 2005 1:16 AM
To: Chip Schweiss
Cc: netfilter-devel
Subject: Re: conntrack NAT problem w/ UDP

> There seems to be an intermittent problem w/ NAT when the source port 
> and destination port are the same on UDP traffic.
[...]
> I diagnosed the problem by sniffing the traffic between the router and 

> internet device (DSL or cable modem).

How much time was there between the last correctly rewritten packet,
and the first bad packet?

I bet it was more than 120 seconds.

UDP is connectionless. Thus, conntracking must use some form of
idle (no packets flowing) timeout for its NAT entries. The timeout
is 120 seconds for replied (packets seen in both directions)
UDP connections.

With the setup you described, having fixed "real" ports, maybe
you can just set up static nat (use the SNAT or DNAT target after
matching client IP address), instead of dynamic (random mangled port)
NAT like MASQUERADE, and your problem will go away - because the 
decision
will be the same each time a new conntrack is created after a pause.

You could also try to work around the problem by making the application
send data in the correct direction more often than each 120 seconds.

Or you could manipulate the UDP timeout on the NAT box. Look/change
/proc/sys/net/ipv4/netfilter/ip_conntrack_udp_stream. However, this
will affect all UDP traffic (traceroute, DNS lookups).

best regards
  Patrick
