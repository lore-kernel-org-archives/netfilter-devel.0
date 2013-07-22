From: Bill Fink <billfink@mindspring.com>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Mon, 22 Jul 2013 03:00:31 -0400
Message-ID: <20130722030031.56b18fd7.billfink@mindspring.com>
References: <20130706132333.GA3279@localhost>
	<20130707030458.fbf22472.billfink@mindspring.com>
	<20130709013023.2fb1fef1.billfink@mindspring.com>
	<20130709182223.GA6266@localhost>
	<20130710055815.a1bd2c1d.billfink@mindspring.com>
	<20130710220820.GA20666@localhost>
	<20130711004827.GA5500@localhost>
	<20130712030114.0362fb5a.billfink@mindspring.com>
	<20130715124905.GA21260@localhost>
	<20130716015503.735ca678.billfink@mindspring.com>
	<20130716213354.GA17466@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:55492 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212Ab3GVHAk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 03:00:40 -0400
In-Reply-To: <20130716213354.GA17466@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 16 Jul 2013, Pablo Neira Ayuso wrote:

> On Tue, Jul 16, 2013 at 01:55:03AM -0400, Bill Fink wrote:
> > On Mon, 15 Jul 2013, Pablo Neira Ayuso wrote:
> > 
> > > On Fri, Jul 12, 2013 at 03:01:14AM -0400, Bill Fink wrote:
> > > 
> > > > I did notice a couple of other things but they're not necessarily
> > > > related to these patches.  I noticed that my long lived BGP tcp
> > > > connection was getting some duplicate conntrackd ct entries (both
> > > > IPv4 and IPv6).  The duplicate ct entry occurred 60 seconds after
> > > > the original, and once I saw a second duplicate ct IPv4 entry,
> > > > again with about a 60 second separation.
> > > 
> > > That's strange. Please, tell me if this happening in the primary
> > > and/or the backup. If you are using the cache mode, also dump the
> > > caches via -i and -e to see the content.
> > 
> > I'm not using the external cache.  The duplicate BGP conntrackd
> > entries seem to have multiplied (this is on the primary with the
> > "conntrackd -i" command):
> > 
> > tcp      6 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=61888 dport=179 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=179 dport=61888 [ASSURED] mark=0 [active since 18464s]
> > tcp      6 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=61888 dport=179 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=179 dport=61888 [ASSURED] mark=0 [active since 245497s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271387s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271447s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271508s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271568s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271628s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271689s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271749s]
> > tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] [active since 271803s]
> 
> Interesting. Can you apply the following patch? It should help to
> debug the issue. Basically, it displays the conntrack unique ID. They
> should have different IDs.

I tried the debugging patch, but the "conntrackd -i" output wasn't
any different (no conntrack unique IDs).

> > > > And on the expectation entries, they seem to have a lifetime
> > > > of 300 seconds.  The IPv6 expectation entries are deleted after
> > > > the 300 seconds as expected, but the IPv4 expectation entries
> > > > actually go away in a minute or less.  I don't know if that
> > > > is expected behavior or not.  Note I was leaving the ftp
> > > > control connection open the entire time.  Also it may have
> > > > just been my imagination, but it seemed if I queried it more
> > > > often with "conntrack -L expect" it would stick around somewhat
> > > > longer (but would go away within the minute).
> > > 
> > > Expectations depends on the master conntrack, if the master is
> > > released, the expectations will be released too. You may be noticing
> > > that effect.
> > 
> > I wasn't expecting that since I was leaving the ftp control
> > connection open.
> > 
> > > You can use `conntrack -E` and `conntrack -E exp` to verify this.
> > 
> > I couldn't get filtering to work with expect:
> > 
> > [root@sen-fw1 ~]# conntrack -E expect -d aaa.aaa.aaa.ccc
> > conntrack v1.4.0 (conntrack-tools): Illegal option `--dst' with this command
> > Try `conntrack -h' or 'conntrack --help' for more information.
> > 
> > [root@sen-fw1 ~]# conntrack -E expect --tuple-dst aaa.aaa.aaa.ccc
> > conntrack v1.4.0 (conntrack-tools): Illegal option `--tuple-dst' with this command
> > Try `conntrack -h' or 'conntrack --help' for more information.
> > 
> > But with the help of grep:
> > 
> > x100ssd2% nc aaa.aaa.aaa.ccc 21
> > 220 FTP Server ready.
> > 
> > gives:
> > 
> >     [NEW] tcp      6 120 SYN_SENT src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 [UNREPLIED] src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 helper=ftp
> >  [UPDATE] tcp      6 60 SYN_RECV src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 helper=ftp
> >  [UPDATE] tcp      6 432000 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 [ASSURED] helper=ftp
> > 
> > Then doing:
> > 
> > USER anonymous
> > 331 Anonymous login ok, send your complete email address as your password
> > PASS bill@
> > 230-
> > ...
> > 230 Anonymous login ok, restrictions apply.
> > PASV
> > 227 Entering Passive Mode (aaa,aaa,aaa,ccc,175,61).
> > 
> > yields:
> > 
> >     [NEW] 300 proto=6 src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=0 dport=44861 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=aaa.aaa.aaa.bbb master-dst=aaa.aaa.aaa.ccc sport=49840 dport=21 class=0 helper=ftp
> > 
> > Not doing anything but waiting, a little while later:
> 
> Can you catch the last event before this one below? I'd like to know
> in what TCP state the flow was before the destroy event.

All the events were listed above in order, so the last event on the
master ftp connection before the following DESTROY/UPDATE was the
UPDATE to the ESTABLISHED state.

> > [DESTROY] tcp      6 src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 [ASSURED]
> >  [UPDATE] tcp      6 433405 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 [ASSURED] mark=0 helper=ftp
> > 
> > together with:
> > 
> > [DESTROY] 273 proto=6 src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=0 dport=44861 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=aaa.aaa.aaa.bbb master-dst=aaa.aaa.aaa.ccc sport=49840 dport=21 class=0 helper=ftp
> > 
> > So that's why the expect goes away.  Remember this didn't happen
> > with IPv6 (it didn't go away until the 300 seconds expired).
> > 
> > Is the DESTROY/UPDATE on the master ftp connection normal when
> > the ftp control connection hasn't been closed?
> 
> That's not normal. I guess you have tcp pick enabled:
> 
> cat /proc/sys/net/netfilter/nf_conntrack_tcp_loose

Yes, I have nf_conntrack_tcp_loose set.

> shows 1. That allows conntrack to create new entries from the first
> packet seen (no mater if it's not a tcp syn packet). It seems that
> conntrack is creating a new TCP established flow for some late packet
> retransmission. Florian Westphal posted a patch to reduce the default
> timeout for pickup flows:
> 
> 6547a22 netfilter: nf_conntrack: avoid large timeout for mid-stream pickup
> 
> That should mitigate this effect. Still, you'll have to trace traffic
> from your network to reach the root cause of this. You can gather pcap
> traces of the BGP's TCP connection, as it seems reproducible with it,
> to simplify things. I think both things are different manifestations
> of the same issue.

For whatever reason, I can't reproduce this anymore.  The expectations
now expire after the expected 5 minutes.  I'm not sure what's different
now.  If it happens again, I'll try and get more debugging info.

> Thanks for the very detailed report. Let me know how it goes with your
> tracing.

						-Thanks

						-Bill
