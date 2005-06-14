From: "Ferry Huberts" <ferry@Hupie.com>
Subject: RE: DNAT & SNAT delay
Date: Tue, 14 Jun 2005 18:33:57 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAMMn0WexgHkOTUvbQ/69qyoKAAAAQAAAAjlR56nNTu0GJg7EDUtBYpwEAAAAA@hupie.com>
References: <Pine.LNX.4.61.0506141516010.28225@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Martin Bangiev'" <martin.bangiev@borsabg.com>
In-Reply-To: <Pine.LNX.4.61.0506141516010.28225@yvahk01.tjqt.qr>
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

You can also use a hack I sometimes use:
- reconfigure rules
- set the connection tracking timeout for your connection type to zero in
/proc
- wait 1 second
- restore the connection tracking timeout for your connection type in /proc

Or use connection tracking flushing; I had a short discussion with Pablo
Neira a while ago on this on the list but continued it privately because his
solution was for 2.6 only and I use 2.4

I have a 2.4 kernel patch for connection tracking entry flushing and Pablo
can point you to a 2.6 solution (but first check the list for our
discussion...)

Good luck!

________________________________

Ferry Huberts

 Linux Rocks!  
________________________________

Brady's First Law of Problem Solving: 

When confronted by a difficult problem, you can solve it more easily by
reducing it to the question: "How would the Lone Ranger have handled this?" 

 

> -----Original Message-----
> From: netfilter-devel-bounces@lists.netfilter.org 
> [mailto:netfilter-devel-bounces@lists.netfilter.org] On 
> Behalf Of Jan Engelhardt
> Sent: Tuesday, June 14, 2005 15:17
> To: Martin Bangiev
> Cc: netfilter-devel@lists.netfilter.org
> Subject: Re: DNAT & SNAT delay
> 
> 
> > Just before the communication starts I add rules to DNAT 
> udp packets 
> > from
> > Client1 to Client2, and to SNAT packets to Client2 to be from 
> > Firewall:IP2. I do it for the Client2 respective (of course 
> I set up the ports too).
> > The problem is that the NAT starts with about 30 seconds delay. 
> > tcpdump shows
> 
> > Can you please tell me where this delay can be coming from?
> > Thanks in advance:)
> 
> Exactly 30? Then this:
> 
> the default conntrack time-to-live for udp "connections" is 
> 30 seconds so you need to wait 30 seconds until the 
> old-and-stale udp conn (the one "without" 
> DNAT/SNAT) expires.
> 
> Well, that's a guess.
> 
> 
> 
> Jan Engelhardt                                                
>                
> --                                                            
>                 
> | Gesellschaft fuer Wissenschaftliche Datenverarbeitung 
> Goettingen, Am 
> | Fassberg, 37077 Goettingen, www.gwdg.de
> 
