From: Bill Fink <billfink@mindspring.com>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Tue, 16 Jul 2013 01:55:03 -0400
Message-ID: <20130716015503.735ca678.billfink@mindspring.com>
References: <20130705020312.25783ccd.billfink@mindspring.com>
	<20130706132333.GA3279@localhost>
	<20130707030458.fbf22472.billfink@mindspring.com>
	<20130709013023.2fb1fef1.billfink@mindspring.com>
	<20130709182223.GA6266@localhost>
	<20130710055815.a1bd2c1d.billfink@mindspring.com>
	<20130710220820.GA20666@localhost>
	<20130711004827.GA5500@localhost>
	<20130712030114.0362fb5a.billfink@mindspring.com>
	<20130715124905.GA21260@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20130715124905.GA21260@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 15 Jul 2013, Pablo Neira Ayuso wrote:

> On Fri, Jul 12, 2013 at 03:01:14AM -0400, Bill Fink wrote:
> > Pablo,
> > 
> > On Thu, 11 Jul 2013, Pablo Neira Ayuso wrote:
> > 
> > > On Thu, Jul 11, 2013 at 12:08:20AM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Jul 10, 2013 at 05:58:15AM -0400, Bill Fink wrote:
> > > > > Almost there.  With the above patch, I now successfully get
> > > > > IPv6 expectations on the backup firewall.  Unfortunately they're
> > > > > not quite right.  On the backup firewall, the expectation src-IP
> > > > > is the same as the dst-IP (either IPv4 or IPv6).
> > > > > 
> > > > > Primary firewall:
> > > > > 
> > > > > [root@sen-fw1 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> > > > > 251 proto=6 src=192.168.218.199 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> > > > > conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> > > > > 
> > > > > Backup firewall:
> > > > > 
> > > > > [root@sen-fw2 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> > > > > 245 proto=6 src=192.168.28.198 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> > > > > conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> > > > > 
> > > > > This was an unfortunate side affect of the patch to fix the
> > > > > conntrackd segfault problem.  If I use Florian's version
> > > > > of the fix segfault patch rather than Pablo's then all is
> > > > > good.
> > > > 
> > > > Thanks for the information, however, we still need to get working back
> > > > the filtering support.
> > > > 
> > > > Could you give a try to the following patch, please?
> > > > 
> > > > It applies on top of conntrack-tools master branch, thanks.
> > > 
> > > There are still some downsides in the previous solution, please, give
> > > a try to this patch instead.
> > 
> > It appears to work pretty well and does fix the src-IP issue!
> 
> Thanks for testing and reporting back, I have pushed the patch to
> master.
> 
> > I did notice a couple of other things but they're not necessarily
> > related to these patches.  I noticed that my long lived BGP tcp
> > connection was getting some duplicate conntrackd ct entries (both
> > IPv4 and IPv6).  The duplicate ct entry occurred 60 seconds after
> > the original, and once I saw a second duplicate ct IPv4 entry,
> > again with about a 60 second separation.
> 
> That's strange. Please, tell me if this happening in the primary
> and/or the backup. If you are using the cache mode, also dump the
> caches via -i and -e to see the content.

I'm not using the external cache.  The duplicate BGP conntrackd
entries seem to have multiplied (this is on the primary with the
"conntrackd -i" command):

tcp      6 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=61888 dport=179 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=179 dport=61888 [ASSURED] mark=0 [active since 18464s]
tcp      6 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=61888 dport=179 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=179 dport=61888 [ASSURED] mark=0 [active since 245497s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271387s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271447s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271508s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271568s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271628s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271689s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] mark=0 [active since 271749s]
tcp      6 ESTABLISHED src=2001:xxxx:xxxx:xxxx::yyyy dst=2001:xxxx:xxxx:xxxx::zzzz sport=49166 dport=179 src=2001:xxxx:xxxx:xxxx::zzzz dst=2001:xxxx:xxxx:xxxx::yyyy sport=179 dport=49166 [ASSURED] [active since 271803s]

> > And on the expectation entries, they seem to have a lifetime
> > of 300 seconds.  The IPv6 expectation entries are deleted after
> > the 300 seconds as expected, but the IPv4 expectation entries
> > actually go away in a minute or less.  I don't know if that
> > is expected behavior or not.  Note I was leaving the ftp
> > control connection open the entire time.  Also it may have
> > just been my imagination, but it seemed if I queried it more
> > often with "conntrack -L expect" it would stick around somewhat
> > longer (but would go away within the minute).
> 
> Expectations depends on the master conntrack, if the master is
> released, the expectations will be released too. You may be noticing
> that effect.

I wasn't expecting that since I was leaving the ftp control
connection open.

> You can use `conntrack -E` and `conntrack -E exp` to verify this.

I couldn't get filtering to work with expect:

[root@sen-fw1 ~]# conntrack -E expect -d aaa.aaa.aaa.ccc
conntrack v1.4.0 (conntrack-tools): Illegal option `--dst' with this command
Try `conntrack -h' or 'conntrack --help' for more information.

[root@sen-fw1 ~]# conntrack -E expect --tuple-dst aaa.aaa.aaa.ccc
conntrack v1.4.0 (conntrack-tools): Illegal option `--tuple-dst' with this command
Try `conntrack -h' or 'conntrack --help' for more information.

But with the help of grep:

x100ssd2% nc aaa.aaa.aaa.ccc 21
220 FTP Server ready.

gives:

    [NEW] tcp      6 120 SYN_SENT src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 [UNREPLIED] src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 helper=ftp
 [UPDATE] tcp      6 60 SYN_RECV src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 helper=ftp
 [UPDATE] tcp      6 432000 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 [ASSURED] helper=ftp

Then doing:

USER anonymous
331 Anonymous login ok, send your complete email address as your password
PASS bill@
230-
...
230 Anonymous login ok, restrictions apply.
PASV
227 Entering Passive Mode (aaa,aaa,aaa,ccc,175,61).

yields:

    [NEW] 300 proto=6 src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=0 dport=44861 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=aaa.aaa.aaa.bbb master-dst=aaa.aaa.aaa.ccc sport=49840 dport=21 class=0 helper=ftp

Not doing anything but waiting, a little while later:

[DESTROY] tcp      6 src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 [ASSURED]
 [UPDATE] tcp      6 433405 ESTABLISHED src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=49840 dport=21 src=aaa.aaa.aaa.ccc dst=aaa.aaa.aaa.bbb sport=21 dport=49840 [ASSURED] mark=0 helper=ftp

together with:

[DESTROY] 273 proto=6 src=aaa.aaa.aaa.bbb dst=aaa.aaa.aaa.ccc sport=0 dport=44861 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=aaa.aaa.aaa.bbb master-dst=aaa.aaa.aaa.ccc sport=49840 dport=21 class=0 helper=ftp

So that's why the expect goes away.  Remember this didn't happen
with IPv6 (it didn't go away until the 300 seconds expired).

Is the DESTROY/UPDATE on the master ftp connection normal when
the ftp control connection hasn't been closed?

At least for ftp it's not a big problem in practice since the
expectation seems to be used almost immediately after creation
for normal ftp transfers.

					-Thanks

					-Bill
