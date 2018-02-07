From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] kernel panic: Out of memory and no killable
 processes... (2)
Date: Wed, 7 Feb 2018 20:15:18 +0100
Message-ID: <20180207191518.jehn3pyssyvupt7n@salvia>
References: <20180130075226.GL21609@dhcp22.suse.cz>
 <20180130081127.GH5906@breakpoint.cc>
 <20180130082817.cbax5qj4mxancx4b@node.shutemov.name>
 <CACT4Y+bFKwoxopr1dwnc7OHUoHy28ksVguqtMY6tD=aRh-7LyQ@mail.gmail.com>
 <20180130095739.GV21609@dhcp22.suse.cz>
 <20180130140104.GE21609@dhcp22.suse.cz>
 <20180130112745.934883e37e696ab7f875a385@linux-foundation.org>
 <20180131081916.GO21609@dhcp22.suse.cz>
 <20180207174439.esm4djxb4trbotne@salvia>
 <20180207110642.dbb3fe499a134d1369f05a2f@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Hocko <mhocko@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Yang Shi <yang.s@alibaba-inc.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	netdev <netdev@vger.kernel.org>, guro@fb.com,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
	syzkaller-bugs@googlegroups.com, Linux-MM <linux-mm@kvack.org>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	David Rientjes <rientjes@google.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	David Miller <davem@davemloft.net>,
	Dmitry Vyukov <dvyukov@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180207110642.dbb3fe499a134d1369f05a2f@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Feb 07, 2018 at 11:06:42AM -0800, Andrew Morton wrote:
> From: Michal Hocko <mhocko@suse.com>
> Subject: net/netfilter/x_tables.c: remove size check
> 
> Back in 2002 vmalloc used to BUG on too large sizes.  We are much better
> behaved these days and vmalloc simply returns NULL for those.  Remove the
> check as it simply not needed and the comment is even misleading.

Applied, thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
