From: Oskar Andreasson <blueflux@koffein.net>
Subject: Re: Some dumb questions...
Date: Mon, 4 Nov 2002 17:00:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0211041658260.31431-100000@laptop1.agatha>
References: <F150xCT9EioMhrQkhJn00022e7c@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joel Linuxdude <linuxlists@hotmail.com>
In-Reply-To: <F150xCT9EioMhrQkhJn00022e7c@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Joel,

See http://www.netfilter.org and http://iptables-tutorial.frozentux.net, 
both sites should answer all your questions. Sidenote, take martins 
advice, these questions are not development related. 

On Sun, 3 Nov 2002, Joel Linuxdude wrote:

> I was referred to this list by one of the Netfilter guys on order to gleen 
> some information needed to write a decent
> tutorial/reference guide.
> 
> WARNING: POSSIBLE DUMB QUESTIONS. (But, ask me if I care!)
> 
> QUESTION: Would a packet created on the Netfilter PC first
> go through the OUTPUT chain and then through POSTROUTING?
> If so, what TABLE??? NAT? What about FILTER? I assume:
> NetFilter system -> (nat)OUTPUT -> (nat)POSTROUTING -> Eth0 -> Internet
> 
> QUESTION: Absolutely everything coming INTO an interface
> first goes to (nat)PREROUTING, right?
> 
> QUESTION: Netfilter PC has 3 workstations over Eth1 and they
> are SNATing through Eth0 and out to the internet. What if
> somebody conversing with the workstation over...say...
> IRC gets the IP of the workstation (It would be the Netfilter
> PC's IP) and pings it.....Of course, it would be pinging
> the Netfilter PC and NOT the workstation, right? The workstation
> would not even see any ICMP packets at all, right?
> 
> QUESTION: Where is the most effective place to stop spoofed
> packets or block a port?
> A) -t nat PREROUTING ???
> B) -t filter INPUT (for local) and -t filter FORWARD (for LAN)?
> C) Either A or B would work fine.
> D) None. You're way off.
> 
> 
> THANK YOU VERY MUCH! These answers will help me out a lot.
> 
> Joel
> 
> 
> 
> 
> 
> 
> _________________________________________________________________
> Choose an Internet access plan right for you -- try MSN! 
> http://resourcecenter.msn.com/access/plans/default.asp
> 
> 
> 

-- 
----
Oskar Andreasson
http://www.frozentux.net
http://iptables-tutorial.frozentux.net
http://ipsysctl-tutorial.frozentux.net
mailto:blueflux@koffein.net
