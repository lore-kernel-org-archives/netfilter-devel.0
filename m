From: Florian Westphal <fw@strlen.de>
Subject: Re: possible deadlock in xt_find_table_lock
Date: Tue, 30 Jan 2018 10:04:33 +0100
Message-ID: <20180130090433.GI5906@breakpoint.cc>
References: <089e082603c4d3bea10563fa816b@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+ed1af231da07c4aee030@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <089e082603c4d3bea10563fa816b@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

#syz dup: possible deadlock in do_ip_getsockopt
