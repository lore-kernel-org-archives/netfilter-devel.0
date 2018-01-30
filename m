From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [netfilter-core] kernel panic: Out of memory and no killable
 processes... (2)
Date: Tue, 30 Jan 2018 11:28:17 +0300
Message-ID: <20180130082817.cbax5qj4mxancx4b@node.shutemov.name>
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
Cc: Michal Hocko <mhocko@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        aarcange@redhat.com, yang.s@alibaba-inc.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, linux-mm@kvack.org, rientjes@google.com,
        akpm@linux-foundation.org, guro@fb.com,
        kirill.shutemov@linux.intel.com
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180130081127.GH5906@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 30, 2018 at 09:11:27AM +0100, Florian Westphal wrote:
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

Well, IIUC they bound to net namespace life time, so killing all
proccesses in the namespace would help to get memory back. :)

-- 
 Kirill A. Shutemov
