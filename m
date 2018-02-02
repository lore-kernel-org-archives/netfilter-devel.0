From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] kernel panic: Out of memory and no killable
 processes... (2)
Date: Fri, 2 Feb 2018 12:41:18 +0100
Message-ID: <20180202114118.6iktfm26wadxflfe@salvia>
References: <20180129182811.fze4vrb5zd5cojmr@node.shutemov.name>
 <20180129223522.GG5906@breakpoint.cc>
 <20180130075226.GL21609@dhcp22.suse.cz>
 <20180130081127.GH5906@breakpoint.cc>
 <20180130082817.cbax5qj4mxancx4b@node.shutemov.name>
 <CACT4Y+bFKwoxopr1dwnc7OHUoHy28ksVguqtMY6tD=aRh-7LyQ@mail.gmail.com>
 <20180130095739.GV21609@dhcp22.suse.cz>
 <20180130140104.GE21609@dhcp22.suse.cz>
 <20180130140111.GM5906@breakpoint.cc>
 <20180130143958.GG21609@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Dmitry Vyukov <dvyukov@google.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev <netdev@vger.kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Yang Shi <yang.s@alibaba-inc.com>, syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Linux-MM <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, guro@fb.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Michal Hocko <mhocko@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180130143958.GG21609@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 30, 2018 at 03:39:58PM +0100, Michal Hocko wrote:
> On Tue 30-01-18 15:01:11, Florian Westphal wrote:
> > > From d48e950f1b04f234b57b9e34c363bdcfec10aeee Mon Sep 17 00:00:00 2001
> > > From: Michal Hocko <mhocko@suse.com>
> > > Date: Tue, 30 Jan 2018 14:51:07 +0100
> > > Subject: [PATCH] net/netfilter/x_tables.c: make allocation less aggressive
> > 
> > Acked-by: Florian Westphal <fw@strlen.de>
> 
> Thanks! How should we route this change? Andrew, David?

I'll place this in the nf.git tree if everyone is happy with it.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
