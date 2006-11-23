From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_nat tree updated
Date: Fri, 24 Nov 2006 01:24:34 +0900 (JST)
Message-ID: <200611231624.kANGOZDi010447@toshiba.co.jp>
References: <4565C47E.3030907@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4565C47E.3030907@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 23 Nov 2006 16:55:42 +0100

> I've rebased my nf_nat tree on top of Dave's net-2.6.20 tree
> (actually on top of my non-nf_nat patches on top of net-2.6.20)
> and uploaded the latest version to my people.netfilter.org space.
> 
> The tree includes only my local changes, you need to pull it
> into a net-2.6.20 tree like this:
> 
> git-clone git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.20.git
> cd net-2.6.20.git
> git-pull http://people.netfilter.org/~kaber/nf-2.6.20-nat.git/
> 
> Changes this the last version include:
> 
> - porting of all remaining conntrack/NAT helpers
> - resync with changes to IPv4 conntrack/NAT, mainly Al Viro's
>   endian annotations
> - multiple small fixes
> 
> Next I'm going to integrate Jozsef's patch for the helper
> assignment problem.
> 
> A few questions:
> 
> - this seems like a good chance to get rid of the helper naming
>   inconsistencies (nf_conntrack_helper_* vs nf_conntrack_*).
>   Should we rename all helpers to nf_conntrack_helper_XXX? We
>   have to provide module aliases for the old names anyway ..
> 
> - /proc-compatibility: since the plan is to get rid of the
>   old IPv4-only connection tracking ASAP, we need to think
>   of something to keep old scripts fiddling with /proc-files
>   working. So we probably need to do some symlinking (is that
>   possible?) of the old net/ipv4/netfilter files or just keep
>   the around as normal files. And we need a /proc/net/ip_conntrack
>   that only shows IPv4 entries I suppose.
> 
> - anything else we need to do for a drop-in replacement?

Sorry for long silence, but please wait a minites.

I've found that helper asignment problem was because my check was poor
to dc808fe28...

I'm writing a patch to fix them (to revert some change in that commits)
for current linus tree.

At least, I think we should use nf_ct_helper_find_get() in
nf_conntrack_netlink.c.

-- Yasuyuki Kozakai
