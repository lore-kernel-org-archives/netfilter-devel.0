From: Florian Westphal <fw@strlen.de>
Subject: Re: BUG: unable to handle kernel paging request in ebt_do_table
Date: Sun, 10 Jun 2018 01:54:57 +0200
Message-ID: <20180609235457.d5shmwhewlvss3vf@breakpoint.cc>
References: <0000000000008fa9d0056e3d4bc9@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+93f34882275ae7caf9db@syzkaller.appspotmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0000000000008fa9d0056e3d4bc9@google.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

fixed via:

#syz dup: WARNING in ebt_do_table
