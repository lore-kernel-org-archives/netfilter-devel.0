From: Florian Westphal <fw@strlen.de>
Subject: Re: possible deadlock in do_ip_getsockopt
Date: Sun, 28 Jan 2018 22:41:18 +0100
Message-ID: <20180128214118.GA5906@breakpoint.cc>
References: <001a114099b0f606e80563db15d3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com
To: syzbot <syzbot+c6ac05d30245e21f783b@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a114099b0f606e80563db15d3@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

syzbot <syzbot+c6ac05d30245e21f783b@syzkaller.appspotmail.com> wrote:
> syzbot hit the following crash on upstream commit
> c4e0ca7fa24137e372d6135fe16e8df8e123f116 (Fri Jan 26 23:10:50 2018 +0000)
> Merge tag 'riscv-for-linus-4.15-maintainers' of
> git://git.kernel.org/pub/scm/linux/kernel/git/palmer/riscv-linux
> 
> So far this crash happened 3 times on net-next, upstream.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c6ac05d30245e21f783b@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 4.15.0-rc9+ #283 Not tainted
> ------------------------------------------------------
> syz-executor7/5121 is trying to acquire lock:
>  (sk_lock-AF_INET){+.+.}, at: [<00000000fe4e3d75>] lock_sock
> include/net/sock.h:1461 [inline]
>  (sk_lock-AF_INET){+.+.}, at: [<00000000fe4e3d75>]
> do_ip_getsockopt+0x1b3/0x2170 net/ipv4/ip_sockglue.c:1331

all of these deadlocks boil down to fact that we acquire sk lock
before calling nf set/getsockopt handlers, yet its not clear to me why
we do this in the first place.

Paolo Abeni is looking at pushing the sk locking down in those nf
handlers that need it which would avoid these deadlocks.
