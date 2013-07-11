From: Bill Fink <billfink@mindspring.com>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Thu, 11 Jul 2013 11:19:16 -0400
Message-ID: <20130711111916.8a9b9d73.billfink@mindspring.com>
References: <20130705020312.25783ccd.billfink@mindspring.com>
	<20130706132333.GA3279@localhost>
	<20130707030458.fbf22472.billfink@mindspring.com>
	<20130709013023.2fb1fef1.billfink@mindspring.com>
	<20130709182223.GA6266@localhost>
	<20130710055815.a1bd2c1d.billfink@mindspring.com>
	<20130710220820.GA20666@localhost>
	<20130711004827.GA5500@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20130711004827.GA5500@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Jul 2013, Pablo Neira Ayuso wrote:

> On Thu, Jul 11, 2013 at 12:08:20AM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jul 10, 2013 at 05:58:15AM -0400, Bill Fink wrote:
> > > Almost there.  With the above patch, I now successfully get
> > > IPv6 expectations on the backup firewall.  Unfortunately they're
> > > not quite right.  On the backup firewall, the expectation src-IP
> > > is the same as the dst-IP (either IPv4 or IPv6).
> > > 
> > > Primary firewall:
> > > 
> > > [root@sen-fw1 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> > > 251 proto=6 src=192.168.218.199 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> > > conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> > > 
> > > Backup firewall:
> > > 
> > > [root@sen-fw2 linux-3.7.3-101.fc17.x86_64]# conntrack -L expect
> > > 245 proto=6 src=192.168.28.198 dst=192.168.28.198 sport=0 dport=54705 mask-src=255.255.255.255 mask-dst=255.255.255.255 sport=0 dport=65535 master-src=192.168.218.199 master-dst=192.168.28.198 sport=56877 dport=21 class=0 helper=ftp
> > > conntrack v1.4.0 (conntrack-tools): 1 expectations have been shown.
> > > 
> > > This was an unfortunate side affect of the patch to fix the
> > > conntrackd segfault problem.  If I use Florian's version
> > > of the fix segfault patch rather than Pablo's then all is
> > > good.
> > 
> > Thanks for the information, however, we still need to get working back
> > the filtering support.
> > 
> > Could you give a try to the following patch, please?
> > 
> > It applies on top of conntrack-tools master branch, thanks.
> 
> There are still some downsides in the previous solution, please, give
> a try to this patch instead.

The firewalls are now in production, so I don't have the same freedom
I did previously.  I'll check the patch out sometime after hours.
Normally, this weekend would be a good time, but I'm going to be
away this weekend.  So it might be a few days until I get a chance.

Thanks again for all your (and Florian's) great help!

						-Bill
