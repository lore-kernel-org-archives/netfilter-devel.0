From: Florian Westphal <fw@strlen.de>
Subject: Re: general protection fault in nf_tables_dump_obj_done
Date: Thu, 4 Jan 2018 18:16:28 +0100
Message-ID: <20180104171628.GA26320@breakpoint.cc>
References: <001a113fd5b81b33e40561f63c7a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+7ee59ac26bbfbd823f1f@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a113fd5b81b33e40561f63c7a@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

#syz fix: netfilter: nf_tables: fix potential NULL-ptr deref in nf_tables_dump_obj_done()
