From: Kerin Millar <kerframil@gmail.com>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c execution
Date: Sat, 03 Mar 2012 17:49:22 +0000
Message-ID: <jitljg$d3b$1@dough.gmane.org>
References: <4F50E30B.6000704@gmail.com> <20120303133002.GA18802@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43542 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2CCRzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Mar 2012 12:55:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1S3tAd-0001tb-Fr
	for netfilter-devel@vger.kernel.org; Sat, 03 Mar 2012 18:55:03 +0100
Received: from cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com ([94.170.82.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Mar 2012 18:55:03 +0100
Received: from kerframil by cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Mar 2012 18:55:03 +0100
In-Reply-To: <20120303133002.GA18802@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 03/03/2012 13:30, Pablo Neira Ayuso wrote:
 > Hi,
 >
 > On Fri, Mar 02, 2012 at 03:11:07PM +0000, Kerin Millar wrote:
 >> Hello,
 >>
 >> I have recently set up a pair of Dell PowerEdge R610 servers (Xeon
 >> X5650, 8GB RAM) for active-backup firewall duty. I've installed
 >> conntrack-tools-1.0.1 and libnetfilter_conntrack-1.0.0 and am using
 >> the FTFW mode for synchronization across a dedicated gigabit
 >> interface. The active firewall has to contend with fairly heavy
 >> traffic, much of which is in the form of long-lived TCP connections
 >> to an internal (LVS) load balancer, behind which a bunch of
 >> application servers sit.
 >>
 >> The number of active, concurrent connections to this service peaks
 >> at around 480,000. At last count, the number of conntrack states was
 >> 785,785 which is typical. I have net.nf_conntrack_max set to 1048576
 >> and the nf_conntrack module is loaded with hashsize=262144. The
 >> firewall is fully stateful in that new connections must match on
 >> -ctstate NEW. I'm also using "-t raw -A PREROUTING -j CT --ctevents
 >> assured" as mentioned in the docs.
 >
 > Docs explictly says that you require Linux kernel>= 2.6.38 to use
 > this filtering. You seem to be using 2.6.32.

I'm aware of this requirement. In point of fact, I am using 3.3-rc5 as 
indicated by the head of the submitted .config and the words "Here's a 
recent netconsole trace from 3.3-rc5 ..."

The only reference to 2.6.32 was to mention in passing that "I tried 
various other versions going as far back as 2.6.32". That's because I 
wanted to establish whether it could be considered a regression. Neither 
the configuration modifications required for - nor the outcome of - 
using 2.6.32 was the subject of the post. My point was that *all* tested 
versions crash under the test case, be they old or bleeding edge.

It was actually a typo; I meant to say that I went "as far back as 
2.6.33" but that seems neither here nor there. See below for the exact 
versions tested.

 >> This is my current test case for the backup:-
 >>
 >> 1) Boot the system and start conntrackd
 >> 2) Run conntrackd -n to sync with the active firewall
 >> 3) Run conntrackd -c to commit the states from the external cache
 >>
 >> Originally, while conntrackd -c was performing its work, I would
 >> experience protracted soft lockups. After some investigation, I
 >> noticed that conntrackd was trying to more states than
 >> net.nf_conntrack_max which, in turn, led me to this patch:-
 >>
 >> 
https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=af14cca
 >
 > I just posted another patch to the ML that is a relative fix to
 > Jozsef's patch. You have to apply that as well.

Presumably, that would be the one removing the spinlocks? I'll try that now.

 >
 >> Although Jozsef's patch was helpful, I'm still experiencing a nasty
 >> kernel oops after conntrackd -c has finished executing. This always
 >> occurs within 15 seconds or so - sometimes immediately. Here's a
 >> recent netconsole trace from 3.3-rc5 + patch:-
 >>
 >> http://paste.pocoo.org/raw/559736/
 >
 > It seems ctnetlink is trying to load nf_nat over and over again, but
 > it doesn't seem to find it. One of the firewalls seem to be performing
 > NAT but the other doesn't have access to the NAT module. This is
 > strange, I guess you have the same rule-set loaded in both firewalls
 > correctly.

Yes, the ruleset is identical. Furthermore, the hardware is identical 
and the software is identical except that the master continues to run 
3.1.10 as originally deployed because I can't bring this down until a 
reliable failover process is probable.

Here are the modules which are shown as loaded after the ruleset has 
been initialised and prior to conntrackd being initialised:-

# lsmod | awk 'NR!=1{print $1}' | tr '\n' ' '
iptable_nat nf_nat xt_CT xt_multiport xt_NOTRACK iptable_raw 
xt_conntrack xt_u32 xt_limit xt_recent xt_addrtype ipt_REJECT xt_comment 
ipt_LOG iptable_filter ip_tables nf_conntrack_ftp nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iTCO_wdt

After initialising conntrackd, the nfnetlink and nf_conntrack_netlink 
modules are dynamically loaded in addition to the above.

The pattern you describe is bothersome but it's what happens after 
conntrackd -c has finished that really worries me! As alluded to before, 
the crash dump varies depending on the kernel version. What remains 
entirely consistent is that the kernel crashes spectacularly within 
approximately 15 seconds of conntrackd -c returning to prompt.

 >
 >> Though I ultimately intend to use the 3.0 kernel, I tried various
 >> other versions going as far back as 2.6.32. In each case, an oops is
 >> reproducible - though the details do vary. Using 3.3-rc5, I even
 >> noticed a null ptr deref on one occcasion. Alas, I was unable to
 >> capture it at the time.
 >
 > For reporting problems, you have to stick latest Linux kernel version.
 > 2.6.32 is rather old kernel.

I submitted my report based on the results in 3.3-rc5 specifically so as 
to be amenable to upstream. Precis:-

1) Both systems are deployed with 3.1.10 - issue is then discovered
2) Tested 3.2.9 on backup
3) Tested 2.6.33.20 on backup (with appropriate config modifications)
4) Tested 3.3.0-rc5 + Jozsef's patch on backup
5) Tested 3.3.0-62d222b+ on backup (pulled from linux-2.6 git tree)

The results submitted in my original post were for case (4).

 >
 >> Here's some other configuration information which may be useful ...
 >>
 >> conntrackd.conf: http://paste.pocoo.org/raw/559727/
 >
 >          Options {
 >                  TCPWindowTracking On
 >          }
 >
 > You cannot use this with 2.6.32 either. It's also documented in the
 > user manual and the example config file (it requires 2.6.36). Please,
 > take the time to read the docs.

I'm aware of this.

 >
 >> sysctl.conf: http://paste.pocoo.org/raw/559726/
 >> kernel .config: http://paste.pocoo.org/raw/559725/
 >>
 >> It's perhaps worth noting that I followed the advice to set
 >> HashLimit in conntrackd.conf to at least double that of
 >> net.nf_conntrack_max (commented in my config because I was
 >> experimenting with the issue that Jozef's patch rectifies). One
 >> thing that puzzles me is why conntrackd always tries to commit more
 >> state entries than can be accommodated. On the master, the internal
 >> cache grows to the maximum size and, afaict, nothing is ever
 >> expired. This is from the master which has been up for a while ...
 >>
 >> # conntrackd -s | head -n 5
 >> cache internal:
 >> current active connections:          2097152
 >> connections created:                31649757    failed:    234788761
 >> connections updated:               105516073    failed:            0
 >> connections destroyed:              29552605    failed:            0
 >>
 >> # conntrack -S | head -n1
 >> entries                 792495
 >>
 >> It seems that the cache usage grows to the maximum, at which point
 >> the creation failed counter starts going skyward. On the backup, it
 >> seems that conntrackd -n&&  conntrackd -c tries to commit all of
 >> this, but I don't really understand why.
 >>
 >> Any advice would be most welcome. I can't tinker too much with the
 >> active firewall at this point but, if it helps, I can conduct any
 >> number of tests with the backup.
 >
 > I need that you stick to a reasonable configuration to help you. Then,
 > we can fix issues, if any shows up.

What is unreasonable about my configuration? Even if it were, the 
inference that a crash is not an issue because the user may or may not 
have followed best practice is one I find somewhat perplexing. I don't 
see how it could possibly be deemed that there is not an issue with the 
kernel's behaviour here.

Given that the misunderstanding over 2.6.32 has been put to bed, if you 
still have any concerns as to the nature of my configuration, by all 
means please air them and I'll take remedial action. Further, the 
servers are equipped with remote access cards so I'm ready and willing 
to do whatever is necessary to conduct and/or assist any further diagnosis.

Cheers,

--Kerin

