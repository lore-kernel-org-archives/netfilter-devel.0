From: Kerin Millar <kerframil@gmail.com>
Subject: scheduling while atomic followed by oops upon conntrackd -c execution
Date: Fri, 02 Mar 2012 15:11:07 +0000
Message-ID: <4F50E30B.6000704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54023 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030183Ab2CBPLY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:11:24 -0500
Received: by bkcik5 with SMTP id ik5so1561741bkc.19
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Mar 2012 07:11:23 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have recently set up a pair of Dell PowerEdge R610 servers (Xeon 
X5650, 8GB RAM) for active-backup firewall duty. I've installed 
conntrack-tools-1.0.1 and libnetfilter_conntrack-1.0.0 and am using the 
FTFW mode for synchronization across a dedicated gigabit interface. The 
active firewall has to contend with fairly heavy traffic, much of which 
is in the form of long-lived TCP connections to an internal (LVS) load 
balancer, behind which a bunch of application servers sit.

The number of active, concurrent connections to this service peaks at 
around 480,000. At last count, the number of conntrack states was 
785,785 which is typical. I have net.nf_conntrack_max set to 1048576 and 
the nf_conntrack module is loaded with hashsize=262144. The firewall is 
fully stateful in that new connections must match on -ctstate NEW. I'm 
also using "-t raw -A PREROUTING -j CT --ctevents assured" as mentioned 
in the docs.

This is my current test case for the backup:-

1) Boot the system and start conntrackd
2) Run conntrackd -n to sync with the active firewall
3) Run conntrackd -c to commit the states from the external cache

Originally, while conntrackd -c was performing its work, I would 
experience protracted soft lockups. After some investigation, I noticed 
that conntrackd was trying to more states than net.nf_conntrack_max 
which, in turn, led me to this patch:-

https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=af14cca

Although Jozsef's patch was helpful, I'm still experiencing a nasty 
kernel oops after conntrackd -c has finished executing. This always 
occurs within 15 seconds or so - sometimes immediately. Here's a recent 
netconsole trace from 3.3-rc5 + patch:-

http://paste.pocoo.org/raw/559736/

Though I ultimately intend to use the 3.0 kernel, I tried various other 
versions going as far back as 2.6.32. In each case, an oops is 
reproducible - though the details do vary. Using 3.3-rc5, I even noticed 
a null ptr deref on one occcasion. Alas, I was unable to capture it at 
the time.

Here's some other configuration information which may be useful ...

conntrackd.conf: http://paste.pocoo.org/raw/559727/
sysctl.conf: http://paste.pocoo.org/raw/559726/
kernel .config: http://paste.pocoo.org/raw/559725/

It's perhaps worth noting that I followed the advice to set HashLimit in 
conntrackd.conf to at least double that of net.nf_conntrack_max 
(commented in my config because I was experimenting with the issue that 
Jozef's patch rectifies). One thing that puzzles me is why conntrackd 
always tries to commit more state entries than can be accommodated. On 
the master, the internal cache grows to the maximum size and, afaict, 
nothing is ever expired. This is from the master which has been up for a 
while ...

# conntrackd -s | head -n 5
cache internal:
current active connections:          2097152
connections created:                31649757    failed:    234788761
connections updated:               105516073    failed:            0
connections destroyed:              29552605    failed:            0

# conntrack -S | head -n1
entries                 792495

It seems that the cache usage grows to the maximum, at which point the 
creation failed counter starts going skyward. On the backup, it seems 
that conntrackd -n && conntrackd -c tries to commit all of this, but I 
don't really understand why.

Any advice would be most welcome. I can't tinker too much with the 
active firewall at this point but, if it helps, I can conduct any number 
of tests with the backup.

Cheers,

--Kerin
