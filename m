From: Alexander Larsson <alexl@redhat.com>
Subject: Re: [PATCH] netbios broadcast connection tracking module
Date: Tue, 26 Oct 2004 13:10:20 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098789020.20339.5.camel@greebo.homeip.net>
References: <1098175785.6562.60.camel@greebo.homeip.net>
	<1098206621.1108.105.camel@tux.rsn.bth.se>
	<1098214482.6562.125.camel@greebo.homeip.net>
	<20041022105504.GC3551@sunbeam.de.gnumonks.org>
	<1098782757.6562.310.camel@greebo.homeip.net>
	<Pine.LNX.4.58.0410261203110.18582@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0410261203110.18582@tux.rsn.bth.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-10-26 at 12:11 +0200, Martin Josefsson wrote:
> On Tue, 26 Oct 2004, Alexander Larsson wrote:
> 
> > > you just need to re-issue the expectation as soon as it is confirmed by
> > > the first packet (from the expectfn).  If I'm not mistaken, there are
> > > already helpers doing that, although I forgot which ones.
> >
> > I've been experimenting a bit here. And it seems that it *does* accept
> > several packages after calling ip_conntrack_expect_related(), before the
> > timeout is passed (although expectfn is only called once). At least if
> > the packages are from the same ip.
> 
> Yes if it's the same source/destination ip/port and protocol then the
> packets match the conntrack entry the first packet set up.

Ah.

> > I took a look at ip_conntrack_ftp.c, and it only calls
> > ip_conntrack_expect_related() from "help". Does this mean it only
> > accepts one related packet on the side-channel?. Actually, none of the
> > in-tree conntrack helpers use expectfn.
> 
> Each command in ftp creates one data-channel. This is per connection, not
> packet. the data-channels never setup more data-channels.
> 
> > Anyway, while testing I digged a bit deeper into the netbios traffic
> > going on here, and it seems like we really only expect one reply anyway.
> > The broadcast request is basically "who has the name <foo>" or "who is
> > the local master browser".
> 
> Ok, then it might work fine to just expect one reply.
> 
> How about when machines broadcast for a domain controller to login to and
> they get multiple replies and tries each one of the servers until it
> succeeds? Then we might want to allow multiple replies, but on the other
> hand if they answer they should be able to handle the login...

Is having several domain controllers on the same subnet common? Sounds
pretty unlikely to me.

> > static struct ip_conntrack_helper netbios_ns;
> >
> > static int __init init(void)
> > {
> > 	memset(&netbios_ns, 0, sizeof(struct ip_conntrack_helper));
> 
> This memset isn't needed as the BSS is initialized to zero by default in
> kernel.

Ok.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 Alexander Larsson                                            Red Hat, Inc 
                   alexl@redhat.com    alla@lysator.liu.se 
He's an unconventional Catholic dog-catcher with a mysterious suitcase 
handcuffed to his arm. She's a ditzy paranoid mechanic operating on the wrong 
side of the law. They fight crime! 
