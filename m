From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: ebtables: handle string from userspace with
 care
Date: Fri, 27 Apr 2018 11:26:22 +0200
Message-ID: <20180427092622.4ifhb4zjoncwawmi@breakpoint.cc>
References: <8710122d42aa1f3e081812f2abf406973f834982.1524818458.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        syzbot <syzbot+4e42a04e0bc33cb6c087@syzkaller.appspotmail.com>,
        fw@strlen.de, coreteam@netfilter.org,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8710122d42aa1f3e081812f2abf406973f834982.1524818458.git.pabeni@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:
> strlcpy() can't be safely used on a user-space provided string,
> as it can try to read beyond the buffer's end, if the latter is
> not NULL terminated.

Yes.

> Leveraging the above, syzbot has been able to trigger the following
> splat:
> 
> BUG: KASAN: stack-out-of-bounds in strlcpy include/linux/string.h:300
> [inline]
> BUG: KASAN: stack-out-of-bounds in compat_mtw_from_user
> net/bridge/netfilter/ebtables.c:1957 [inline]
> BUG: KASAN: stack-out-of-bounds in ebt_size_mwt
> net/bridge/netfilter/ebtables.c:2059 [inline]
> BUG: KASAN: stack-out-of-bounds in size_entry_mwt
> net/bridge/netfilter/ebtables.c:2155 [inline]
> BUG: KASAN: stack-out-of-bounds in compat_copy_entries+0x96c/0x14a0
> net/bridge/netfilter/ebtables.c:2194
> Write of size 33 at addr ffff8801b0abf888 by task syz-executor0/4504

Which is weird, I don't understand this report.
The code IS wrong, but it should cause out-of-bounds read (strlen on
src), but not out-of-bounds write.

Yes, I sent a recent patch (dceb48d86b4871984b8ce9ad5057fb2c01aa33de in
nf.git) that would now allow to get rid of the strlcpy and use the
source directly.
