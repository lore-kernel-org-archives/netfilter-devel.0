From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: Sun, 9 Jun 2002 19:17:15 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020609171715.GC3181@naboo.de.gnumonks.org>
References: <1023365846.845.26.camel@tux> <20020608073733.GB1109@naboo.de.gnumonks.org> <1023548616.19835.59.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1023548616.19835.59.camel@tux>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jun 08, 2002 at 05:03:36PM +0200, Martin Josefsson wrote:
> On Sat, 2002-06-08 at 09:37, Harald Welte wrote:
>  
> > ah. now I understand what the exporting was all about :)
> 
> :)
>  
> > sounds interesting and should give quite some speedup.  Did you do any
> > benchmarking on that?
> 
> I need to get a slower test-router so I can benchmark properly :(
> I need to get a very old pentium or high-end 486 with PCI.

ok, but even then the benchmarking results would most likely be a bit 
different, since modern CPU's tend to have quite different cache sizes
and I/O respectively memory bandwidth.

> I implemented this a while ago and then accidentally lost the sourcetree
> but I did do some profiling which I can't find now :(

no problem.  I was just asking in case you had some numbers handy...

> A similar thing was recently done in VFS in kernel 2.5 for the atime
> updates and it gave a very nice speedup, I doubt the speedup will be as
> large here since the timer handling is a lot faster than disk-io.

I think I will do some stress testing with and without your patch.

> I'm currently in the process of going through the locking in conntrack
> to try and make it more scalable (splitting ip_conntrack_lock) and
> trying to fix things I find.

great, improvements are always welcome, as you might assume :)

> /Martin

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
