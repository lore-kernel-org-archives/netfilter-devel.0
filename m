From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [netfilter-core] kernel panic: Out of memory and no killable
 processes... (2)
Date: Wed, 31 Jan 2018 09:19:16 +0100
Message-ID: <20180131081916.GO21609@dhcp22.suse.cz>
References: <20180129165722.GF5906@breakpoint.cc>
 <20180129182811.fze4vrb5zd5cojmr@node.shutemov.name>
 <20180129223522.GG5906@breakpoint.cc>
 <20180130075226.GL21609@dhcp22.suse.cz>
 <20180130081127.GH5906@breakpoint.cc>
 <20180130082817.cbax5qj4mxancx4b@node.shutemov.name>
 <CACT4Y+bFKwoxopr1dwnc7OHUoHy28ksVguqtMY6tD=aRh-7LyQ@mail.gmail.com>
 <20180130095739.GV21609@dhcp22.suse.cz>
 <20180130140104.GE21609@dhcp22.suse.cz>
 <20180130112745.934883e37e696ab7f875a385@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Florian Westphal <fw@strlen.de>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev <netdev@vger.kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Yang Shi <yang.s@alibaba-inc.com>, syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Linux-MM <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>,
	guro@fb.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180130112745.934883e37e696ab7f875a385@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-Id: netfilter-devel.vger.kernel.org

On Tue 30-01-18 11:27:45, Andrew Morton wrote:
> On Tue, 30 Jan 2018 15:01:04 +0100 Michal Hocko <mhocko@kernel.org> wrote:
> 
> > > Well, this is not about syzkaller, it merely pointed out a potential
> > > DoS... And that has to be addressed somehow.
> > 
> > So how about this?
> > ---
> 
> argh ;)

doh, those hardwired moves...

> > >From d48e950f1b04f234b57b9e34c363bdcfec10aeee Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.com>
> > Date: Tue, 30 Jan 2018 14:51:07 +0100
> > Subject: [PATCH] net/netfilter/x_tables.c: make allocation less aggressive
> > 
> > syzbot has noticed that xt_alloc_table_info can allocate a lot of
> > memory. This is an admin only interface but an admin in a namespace
> > is sufficient as well. eacd86ca3b03 ("net/netfilter/x_tables.c: use
> > kvmalloc() in xt_alloc_table_info()") has changed the opencoded
> > kmalloc->vmalloc fallback into kvmalloc. It has dropped __GFP_NORETRY on
> > the way because vmalloc has simply never fully supported __GFP_NORETRY
> > semantic. This is still the case because e.g. page tables backing the
> > vmalloc area are hardcoded GFP_KERNEL.
> > 
> > Revert back to __GFP_NORETRY as a poors man defence against excessively
> > large allocation request here. We will not rule out the OOM killer
> > completely but __GFP_NORETRY should at least stop the large request
> > in most cases.
> > 
> > Fixes: eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()")
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  net/netfilter/x_tables.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> > index d8571f414208..a5f5c29bcbdc 100644
> > --- a/net/netfilter/x_tables.c
> > +++ b/net/netfilter/x_tables.c
> > @@ -1003,7 +1003,13 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
> >  	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
> >  		return NULL;
> 
> offtopic: preceding comment here is "prevent them from hitting BUG() in
> vmalloc.c".  I suspect this is ancient code and vmalloc sure as heck
> shouldn't go BUG with this input.  And it should be using `sz' ;)

Yeah, we do not BUG but rather fail instead. See __vmalloc_node_range.
My excavation tools pointed me to "VM: Rework vmalloc code to support mapping of arbitray pages"
by Christoph back in 2002. So yes, we can safely remove it finally. Se
below.


>From 8d52e1d939d101b0dafed6ae5c3c1376183e65bb Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 31 Jan 2018 09:16:56 +0100
Subject: [PATCH] net/netfilter/x_tables.c: remove size check

Back in 2002 vmalloc used to BUG on too large sizes. We are much better
behaved these days and vmalloc simply returns NULL for those. Remove
the check as it simply not needed and the comment even misleading.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 net/netfilter/x_tables.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b55ec5aa51a6..48a6ff620493 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -999,10 +999,6 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	if (sz < sizeof(*info))
 		return NULL;
 
-	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
-		return NULL;
-
 	/* __GFP_NORETRY is not fully supported by kvmalloc but it should
 	 * work reasonably well if sz is too large and bail out rather
 	 * than shoot all processes down before realizing there is nothing
-- 
2.15.1

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
