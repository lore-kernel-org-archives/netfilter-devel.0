From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [netfilter-core] kernel panic: Out of memory and no killable
 processes... (2)
Date: Mon, 29 Jan 2018 11:26:49 +0300
Message-ID: <20180129082649.sysf57wlp7i7ltb2@node.shutemov.name>
References: <001a1144b0caee2e8c0563d9de0a@google.com>
 <201801290020.w0T0KK8V015938@www262.sakura.ne.jp>
 <20180129072357.GD5906@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        aarcange@redhat.com, yang.s@alibaba-inc.com, mhocko@suse.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, linux-mm@kvack.org, rientjes@google.com,
        akpm@linux-foundation.org, guro@fb.com,
        kirill.shutemov@linux.intel.com
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180129072357.GD5906@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 29, 2018 at 08:23:57AM +0100, Florian Westphal wrote:
> > vmalloc() once became killable by commit 5d17a73a2ebeb8d1 ("vmalloc: back
> > off when the current task is killed") but then became unkillable by commit
> > b8c8a338f75e052d ("Revert "vmalloc: back off when the current task is
> > killed""). Therefore, we can't handle this problem from MM side.
> > Please consider adding some limit from networking side.
> 
> I don't know what "some limit" would be.  I would prefer if there was
> a way to supress OOM Killer in first place so we can just -ENOMEM user.

Just supressing OOM kill is a bad idea. We still leave a way to allocate
arbitrary large buffer in kernel.

-- 
 Kirill A. Shutemov
