From: Alexander Larsson <alexl@redhat.com>
Subject: Re: [PATCH] netbios broadcast connection tracking module
Date: Tue, 26 Oct 2004 13:11:57 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098789117.20339.8.camel@greebo.homeip.net>
References: <1098175785.6562.60.camel@greebo.homeip.net>
	<1098206621.1108.105.camel@tux.rsn.bth.se>
	<1098214482.6562.125.camel@greebo.homeip.net>
	<20041022105504.GC3551@sunbeam.de.gnumonks.org>
	<1098782757.6562.310.camel@greebo.homeip.net>
	<20041026094205.GM18934@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041026094205.GM18934@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-10-26 at 11:42 +0200, Harald Welte wrote:
> On Tue, Oct 26, 2004 at 11:25:57AM +0200, Alexander Larsson wrote:
> > On Fri, 2004-10-22 at 12:55 +0200, Harald Welte wrote:
> > > Hi!
> > > 
> > > First of all, let me say that I am much in favour of a conntrack helper
> > > than an ipt_recent-based solution.
> > > 
> > > > Hmm. I though by setting max_expected to 0 would allow me to get
> > > > multiple expected replies, but i could easily have misread the code. Is
> > > > there no way to expect multiple packets in reply to a single udp
> > > > package?
> > > 
> > > you just need to re-issue the expectation as soon as it is confirmed by
> > > the first packet (from the expectfn).  If I'm not mistaken, there are
> > > already helpers doing that, although I forgot which ones.
> > 
> > I've been experimenting a bit here. And it seems that it *does* accept
> > several packages after calling ip_conntrack_expect_related(), before the
> > timeout is passed (although expectfn is only called once). At least if
> > the packages are from the same ip.
> > 
> > I took a look at ip_conntrack_ftp.c, and it only calls
> > ip_conntrack_expect_related() from "help". Does this mean it only
> > accepts one related packet on the side-channel?. Actually, none of the
> > in-tree conntrack helpers use expectfn.
> 
> expectations are on a connection level, not on a per-packet level.
> However, broadcast packets don't have connections, since you send
> packets to .255 and receive them back from inidividual ip addresses.
> Since you don't know how many clients in the broadcast domain will
> reply, you need to re-create the expectation every time it is confirmed
> (via expectfn).

So, how exactly would you do this? I tried ip_conntrack_expect_alloc() a
new ip_conntrack_expect, set it up and called
	ip_conntrack_expect_related(exp, ct);

However, this just got me a kernel panic.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 Alexander Larsson                                            Red Hat, Inc 
                   alexl@redhat.com    alla@lysator.liu.se 
He's a suicidal white trash boxer from the 'hood. She's an enchanted 
wisecracking detective living homeless in New York's sewers. They fight crime! 
