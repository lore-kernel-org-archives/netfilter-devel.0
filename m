From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: x_tables vs. nf-hipac
Date: Tue, 11 Oct 2005 16:55:46 +0000
Message-ID: <1129049746.3378.11.camel@localhost.localdomain>
References: <434A4B11.4030103@gmx.net> <20051010163442.GC5627@rama>
	<1128983497.3377.4.camel@localhost.localdomain>
	<20051011143314.GC4756@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051011143314.GC4756@rama.de.gnumonks.org>
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

Op di, 11-10-2005 te 16:33 +0200, schreef Harald Welte:
> At the moment, I'm still busy in consolidation of kernelspace.  I'm not
> sure how easy this will get for the userspace side.  Once I've done the
> userspace counterpart (consolidation of libipt_FOO / libipXt_FOO), I'll
> look at the arptables userspace code and see if we can integrate that
> somehow.
> 
> One rally sad thing is that arp_tables was deprived of matches, so we
> only have targets.  This means we cannot use any of the x_tables matches 
> (such as limit, mark, ...).

Yeah, I know. But I don't see why it can't be added, this shouldn't
break backwards compatibility. The struct arpt_entry has the members
target_offset and next_offset...

> If you would be willing to harmonize here (I think this only affects
> kernel space data structures that are not shared with userspace, so no
> compatibility issues), then eb_tables could directly use x_tables
> matches - if that is desired.

It's probably not worth it...

> However, ebtables matches quite nicely with pkt_tables (some people have
> suggested renaming it into nf_tables).  This is mainly because of the
> "watchers".  A pkt_tables rule has 
> - any number of matches
> - any number of targets (that have a "void" function and don't return
>   anything)
> - one user-specified verdict.
> 
> so all watchers can be implemented as targets.  So it all boils down on
> how much time I can find to complete pkt_tables. Maybe at some point
> early 2006, after we've survived the nf_conntrack merge, and added
> proper support for userspace conntrack helpers.

I'll wait for that then. Hopefully it will allow the RETURN verdict for
target modules. I'll concentrate on finalising the current ebtables
version in cvs for now.

cheers,
Bart
