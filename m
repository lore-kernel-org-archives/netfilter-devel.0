From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: DNAT & SNAT delay
Date: Tue, 14 Jun 2005 15:16:52 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506141516010.28225@yvahk01.tjqt.qr>
References: <42AD780A.2030601@borsabg.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Bangiev <martin.bangiev@borsabg.com>
In-Reply-To: <42AD780A.2030601@borsabg.com>
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


> Just before the communication starts I add rules to DNAT udp packets from
> Client1 to Client2, and to SNAT packets to Client2 to be from Firewall:IP2. I
> do it for the Client2 respective (of course I set up the ports too).
> The problem is that the NAT starts with about 30 seconds delay. tcpdump shows

> Can you please tell me where this delay can be coming from?
> Thanks in advance:)

Exactly 30? Then this:

the default conntrack time-to-live for udp "connections" is 30 seconds so you 
need to wait 30 seconds until the old-and-stale udp conn (the one "without" 
DNAT/SNAT) expires.

Well, that's a guess.



Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
