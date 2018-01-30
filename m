From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [netfilter-core] kernel panic: Out of memory and no killable
 processes... (2)
Date: Tue, 30 Jan 2018 10:51:34 +0100
Message-ID: <20180130095134.GU21609@dhcp22.suse.cz>
References: <001a1144b0caee2e8c0563d9de0a@google.com>
 <201801290020.w0T0KK8V015938@www262.sakura.ne.jp>
 <20180129072357.GD5906@breakpoint.cc>
 <20180129082649.sysf57wlp7i7ltb2@node.shutemov.name>
 <20180129165722.GF5906@breakpoint.cc>
 <20180129182811.fze4vrb5zd5cojmr@node.shutemov.name>
 <20180129223522.GG5906@breakpoint.cc>
 <20180130075226.GL21609@dhcp22.suse.cz>
 <20180130081127.GH5906@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        aarcange@redhat.com, yang.s@alibaba-inc.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, linux-mm@kvack.org, rientjes@google.com,
        akpm@linux-foundation.org, guro@fb.com,
        kirill.shutemov@linux.intel.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180130081127.GH5906@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue 30-01-18 09:11:27, Florian Westphal wrote:
> Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 29-01-18 23:35:22, Florian Westphal wrote:
> > > Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > [...]
> > > > I hate what I'm saying, but I guess we need some tunable here.
> > > > Not sure what exactly.
> > > 
> > > Would memcg help?
> > 
> > That really depends. I would have to check whether vmalloc path obeys
> > __GFP_ACCOUNT (I suspect it does except for page tables allocations but
> > that shouldn't be a big deal). But then the other potential problem is
> > the life time of the xt_table_info (or other potentially large) data
> > structures. Are they bound to any process life time.
> 
> No.
> 
> > Because if they are
> > not then the OOM killer will not help. The OOM panic earlier in this
> > thread suggests it doesn't because the test case managed to eat all the
> > available memory and killed all the eligible tasks which didn't help.
> 
> Yes, which is why we do not want any OOM killer invocation in first
> place...

The problem is that as soon as you eat that memory and ask for more
until you fail with ENOMEM then the OOM is simply unavoidable.
-- 
Michal Hocko
SUSE Labs
