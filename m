From: Florian Westphal <fw@strlen.de>
Subject: Re: possible deadlock in xt_find_revision
Date: Tue, 30 Jan 2018 10:05:25 +0100
Message-ID: <20180130090525.GJ5906@breakpoint.cc>
References: <001a1143d5606e7f3b0563db12de@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+0f8d41363dab80c9a3e9@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a1143d5606e7f3b0563db12de@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

#syz dup: possible deadlock in do_ip_getsockopt
